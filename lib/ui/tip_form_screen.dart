import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/tips_service.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'widgets.dart';

/// A rider's first-hand experience at a place: when it happened, what
/// happened, and under which conditions. Reviewed before others see it.
class TipFormScreen extends ConsumerStatefulWidget {
  const TipFormScreen({super.key, this.spotId});
  final String? spotId;

  @override
  ConsumerState<TipFormScreen> createState() => _TipFormScreenState();
}

class _TipFormScreenState extends ConsumerState<TipFormScreen> {
  late String? _spotId = widget.spotId;
  late VehicleClass _vehicle = ref.read(checkContextProvider).vehicle;
  DateTime _when = DateTime.now();
  var _pickingWhen = false;
  var _stay = 60;
  var _outcome = TipOutcome.parkedAndRetrieved;
  var _left = Tri.unknown;
  var _check = StaffCheck.unknown;
  final _note = TextEditingController();
  String? _photoPath;
  var _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickSpot() async {
    final spots = ref.read(evidenceProvider).value?.snapshot.spots ?? const [];
    final id = await showCupertinoModalPopup<String>(
      context: context,
      builder: (c) => CupertinoActionSheet(
        title: const Text('Which place?'),
        actions: [
          for (final s in spots) CupertinoActionSheetAction(onPressed: () => Navigator.pop(c, s.id), child: Text(s.name)),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
      ),
    );
    if (id != null) setState(() => _spotId = id);
  }

  Future<void> _submit() async {
    final spotId = _spotId;
    if (spotId == null) return;
    setState(() => _sending = true);
    final services = ref.read(servicesProvider);
    await services.tips.submit(TipDraft(
      spotId: spotId,
      vehicle: _vehicle,
      eventTime: _when,
      stayMinutes: _outcome == TipOutcome.refusedEntry ? 0 : _stay,
      outcome: _outcome,
      leftPremises: _left,
      staffCheck: _check,
      note: _note.text,
      photoSourcePath: _photoPath,
    ));
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    toast(
      context,
      services.net.online ? 'Sending your tip. A reviewer will check it.' : 'Saved on your phone. We’ll send it when you’re connected.',
      icon: services.net.online ? CupertinoIcons.paperplane_fill : CupertinoIcons.tray_arrow_up_fill,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final spot = _spotId == null ? null : ref.watch(evidenceProvider).value?.snapshot.spot(_spotId!);

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      navigationBar: CupertinoNavigationBar(backgroundColor: pz.background, middle: const Text('Share a tip'), previousPageTitle: 'Back'),
      child: SafeArea(
        child: ListView(padding: const EdgeInsets.only(bottom: Space.x4), children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xl, Space.l, Space.xl, 0),
            child: Text('Tell the next rider what actually happened. Reviewed before anyone sees it; accepted tips earn 10 points.',
                style: t.bodyMedium),
          ),
          Group(header: 'Where and when', children: [
            CupertinoListTile(
              title: const Text('Place'),
              additionalInfo: Text(spot?.name ?? 'Choose', maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const CupertinoListTileChevron(),
              onTap: _pickSpot,
            ),
            CupertinoListTile(
              title: const Text('When it happened'),
              additionalInfo: Text(formatIstDateTime(_when), style: const TextStyle(fontFeatures: Fonts.tabular)),
              onTap: () => setState(() => _pickingWhen = !_pickingWhen),
            ),
            if (_pickingWhen)
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  initialDateTime: _when,
                  maximumDate: DateTime.now().add(const Duration(minutes: 1)),
                  onDateTimeChanged: (d) => setState(() => _when = d),
                ),
              ),
          ]),
          Group(header: 'Your vehicle', children: [
            Padding(
              padding: const EdgeInsets.all(Space.m),
              child: CupertinoSlidingSegmentedControl<VehicleClass>(
                groupValue: _vehicle,
                children: {for (final v in VehicleClass.values) v: Padding(padding: const EdgeInsets.all(8), child: Text(v.label))},
                onValueChanged: (v) => setState(() => _vehicle = v ?? _vehicle),
              ),
            ),
          ]),
          Group(header: 'What happened', children: [
            for (final o in TipOutcome.values)
              CupertinoListTile(
                title: Text(o.label),
                trailing: _outcome == o ? Icon(CupertinoIcons.checkmark_alt, color: pz.tint) : null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _outcome = o);
                },
              ),
          ]),
          if (_outcome != TipOutcome.refusedEntry)
            Group(header: 'How long you stayed', children: [
              CupertinoListTile(
                title: Text(formatDuration(Duration(minutes: _stay)), style: const TextStyle(fontFeatures: Fonts.tabular)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  CupertinoButton(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                    onPressed: _stay > 15 ? () => setState(() => _stay -= 15) : null,
                    child: const Icon(CupertinoIcons.minus_circle),
                  ),
                  CupertinoButton(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                    onPressed: _stay < 24 * 60 ? () => setState(() => _stay += 15) : null,
                    child: const Icon(CupertinoIcons.plus_circle),
                  ),
                ]),
              ),
            ]),
          Group(header: 'Did you leave the premises?', children: [
            Padding(
              padding: const EdgeInsets.all(Space.m),
              child: CupertinoSlidingSegmentedControl<Tri>(
                groupValue: _left,
                children: const {
                  Tri.yes: Padding(padding: EdgeInsets.all(8), child: Text('Yes')),
                  Tri.no: Padding(padding: EdgeInsets.all(8), child: Text('No')),
                  Tri.unknown: Padding(padding: EdgeInsets.all(8), child: Text('Not relevant')),
                },
                onValueChanged: (v) => setState(() => _left = v ?? _left),
              ),
            ),
          ]),
          Group(header: 'Did anyone check you?', children: [
            for (final c in StaffCheck.values)
              CupertinoListTile(
                title: Text(c.label),
                trailing: _check == c ? Icon(CupertinoIcons.checkmark_alt, color: pz.tint) : null,
                onTap: () => setState(() => _check = c),
              ),
          ]),
          Group(header: 'Anything else (optional)', children: [
            Padding(
              padding: const EdgeInsets.all(Space.s),
              child: CupertinoTextField(
                controller: _note,
                maxLength: 280,
                maxLines: 3,
                minLines: 2,
                placeholder: 'e.g. Guard asked after 2 hours',
                decoration: const BoxDecoration(),
              ),
            ),
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.camera_fill),
              title: Text(_photoPath == null ? 'Add a photo' : 'Photo added'),
              trailing: _photoPath == null
                  ? const CupertinoListTileChevron()
                  : CupertinoButton(padding: EdgeInsets.zero, onPressed: () => setState(() => _photoPath = null), child: const Text('Remove')),
              onTap: _photoPath != null
                  ? null
                  : () async {
                      final f = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
                      if (f != null) setState(() => _photoPath = f.path);
                    },
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.l, Space.l, Space.l, 0),
            child: PzButton(
              label: 'Send tip',
              icon: CupertinoIcons.paperplane_fill,
              loading: _sending,
              onPressed: _spotId == null ? null : _submit,
            ),
          ),
        ]),
      ),
    );
  }
}
