import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../ai/photo_interpreter.dart';
import '../app/providers.dart';
import '../app/theme.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/photo_findings.dart';
import 'widgets.dart';

/// Photo → rider marks the exact spot → structured observations.
/// Pops with [PhotoFindings], or null if the rider continues without.
class PhotoCheckScreen extends ConsumerStatefulWidget {
  const PhotoCheckScreen({super.key, required this.spot, required this.vehicle});
  final Spot spot;
  final VehicleClass vehicle;

  @override
  ConsumerState<PhotoCheckScreen> createState() => _PhotoCheckScreenState();
}

class _PhotoCheckScreenState extends ConsumerState<PhotoCheckScreen> {
  XFile? _photo;
  Offset? _mark;
  var _checking = false;
  PhotoFindings? _findings;
  PhotoCheckError? _error;
  var _attempt = 0;

  Future<void> _pick(ImageSource source) async {
    try {
      final f = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 80);
      if (f == null) return;
      setState(() {
        _photo = f;
        _mark = null;
        _findings = null;
        _error = null;
      });
    } on PlatformException {
      if (mounted) await showInfo(context, 'Camera not available', 'Choose a photo from your library instead.');
    }
  }

  Future<void> _check() async {
    final photo = _photo;
    final mark = _mark;
    if (photo == null || mark == null) return;
    final services = ref.read(servicesProvider);
    final attempt = ++_attempt;
    setState(() {
      _checking = true;
      _error = null;
    });
    final started = DateTime.now();
    await services.log.record('ai.request', correlationId: widget.spot.id, attrs: {'model': services.ai.modelName});
    try {
      final findings = await services.ai.interpret(
        jpeg: await photo.readAsBytes(),
        spotX: mark.dx,
        spotY: mark.dy,
        vehicle: widget.vehicle,
      );
      await services.log.record('ai.response', correlationId: widget.spot.id, attrs: {
        'ms': DateTime.now().difference(started).inMilliseconds,
        'signs': findings.signs.length,
        'objects': findings.objects.length,
        'uncertainties': findings.uncertainties.length,
      });
      if (!mounted || attempt != _attempt) return;
      await HapticFeedback.lightImpact();
      setState(() => _findings = findings);
    } on PhotoCheckError catch (e) {
      await services.log.record('ai.failed', correlationId: widget.spot.id,
          attrs: {'error': e.code, 'ms': DateTime.now().difference(started).inMilliseconds});
      if (!mounted || attempt != _attempt) return;
      setState(() => _error = e);
    } finally {
      if (mounted && attempt == _attempt) setState(() => _checking = false);
    }
  }

  void _cancel() => setState(() {
        _attempt++;
        _checking = false;
      });

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: pz.background,
        middle: const Text('Check with a photo'),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: ListView(padding: const EdgeInsets.all(Space.l), children: [
          if (_photo == null) ...[
            const SizedBox(height: Space.l),
            const EmptyState(
              title: 'Show Zumi the spot',
              message: 'Stand where you can see the kerb or entrance, and any signs nearby. Then tap where you’d leave your vehicle.',
            ),
            PzButton(label: 'Take a photo', icon: CupertinoIcons.camera_fill, onPressed: () => _pick(ImageSource.camera)),
            const SizedBox(height: Space.s),
            PzButton(label: 'Choose from library', kind: PzButtonKind.secondary, onPressed: () => _pick(ImageSource.gallery)),
          ] else ...[
            Text(_mark == null ? 'Tap where you’d leave your vehicle' : 'Marked. Tap again to move it.', style: t.titleMedium),
            const SizedBox(height: Space.s),
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.card),
              child: LayoutBuilder(builder: (context, box) {
                return GestureDetector(
                  onTapDown: _checking
                      ? null
                      : (d) {
                          HapticFeedback.selectionClick();
                          final size = context.size!;
                          setState(() {
                            _mark = Offset(d.localPosition.dx / size.width, d.localPosition.dy / size.height);
                            _findings = null;
                          });
                        },
                  child: Stack(children: [
                    Image.file(File(_photo!.path), width: box.maxWidth, fit: BoxFit.fitWidth),
                    if (_mark case final m?)
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (c, b) => Stack(children: [
                            Positioned(
                              left: m.dx * b.maxWidth - 22,
                              top: m.dy * b.maxHeight - 22,
                              child: Semantics(
                                label: 'Your marked spot',
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Pz.lime.withValues(alpha: 0.85),
                                    border: Border.all(color: Pz.ink, width: 3),
                                  ),
                                  child: const Icon(Icons.two_wheeler, color: Pz.ink, size: 22),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                  ]),
                );
              }),
            ),
            const SizedBox(height: Space.l),
            if (_checking)
              PzCard(
                child: Column(children: [
                  const _ThinkingZumi(),
                  const SizedBox(height: Space.m),
                  Text('Checking the photo…', style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text('Looking for signs, gates and entrances. Nothing is decided yet.', textAlign: TextAlign.center, style: t.bodyMedium),
                  const SizedBox(height: Space.m),
                  PzButton(label: 'Cancel', kind: PzButtonKind.plain, onPressed: _cancel),
                ]),
              )
            else if (_error case final e?) ...[
              Notice(level: Level.caution, title: 'Photo check unavailable', message: e.userMessage),
              const SizedBox(height: Space.m),
              if (e is! AiNotConfigured) PzButton(label: 'Try again', icon: CupertinoIcons.arrow_clockwise, onPressed: _check),
              const SizedBox(height: Space.s),
              PzButton(label: 'Continue without the photo', kind: PzButtonKind.secondary, onPressed: () => Navigator.pop(context)),
            ] else if (_findings case final f?) ...[
              _FindingsCard(findings: f),
              const SizedBox(height: Space.l),
              PzButton(label: 'Use these observations', icon: CupertinoIcons.checkmark, onPressed: () => Navigator.pop(context, f)),
              const SizedBox(height: Space.s),
              PzButton(label: 'Retake', kind: PzButtonKind.secondary, onPressed: () => _pick(ImageSource.camera)),
            ] else ...[
              PzButton(label: 'Check this spot', icon: CupertinoIcons.sparkles, onPressed: _mark == null ? null : _check),
              const SizedBox(height: Space.s),
              Text('Sent to Gemini (${ref.watch(servicesProvider).ai.modelName}): the photo and your mark. Not your location.',
                  textAlign: TextAlign.center, style: t.labelSmall),
            ],
          ],
        ]),
      ),
    );
  }
}

class _FindingsCard extends StatelessWidget {
  const _FindingsCard({required this.findings});
  final PhotoFindings findings;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pz = Pz.of(context);
    Widget row(IconData icon, Color color, String title, String? detail) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: Space.s),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                if (detail != null && detail.isNotEmpty) Text(detail, style: t.bodyMedium),
              ]),
            ),
          ]),
        );
    return PzCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('What the photo shows', style: t.labelLarge),
          const Spacer(),
          const SourceTag(SourceClass.ai),
        ]),
        const SizedBox(height: Space.s),
        if (findings.signs.isEmpty && findings.objects.isEmpty)
          row(CupertinoIcons.eye_fill, pz.textSecondary, 'No signs or obstructions spotted', 'That isn’t permission.'),
        for (final s in findings.signs)
          row(s.kind.prohibits ? CupertinoIcons.exclamationmark_triangle_fill : CupertinoIcons.info_circle_fill,
              s.kind.prohibits ? pz.caution.fg : pz.textSecondary,
              '${s.kind.label} sign · ${(s.confidence * 100).round()}% sure',
              s.text.isEmpty ? null : '“${s.text}”'),
        for (final o in findings.objects)
          row(o.possibleObstruction && o.nearSpot ? CupertinoIcons.hand_raised_fill : CupertinoIcons.eye_fill,
              o.possibleObstruction && o.nearSpot ? pz.caution.fg : pz.textSecondary,
              '${o.kind.label}${o.nearSpot ? ' near your spot' : ''}',
              o.label),
        for (final u in findings.uncertainties) row(CupertinoIcons.question_circle, pz.unknown.fg, 'Unclear', u),
      ]),
    );
  }
}

class _ThinkingZumi extends StatefulWidget {
  const _ThinkingZumi();

  @override
  State<_ThinkingZumi> createState() => _ThinkingZumiState();
}

class _ThinkingZumiState extends State<_ThinkingZumi> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) => Transform.rotate(angle: (Curves.easeInOut.transform(_c.value) - 0.5) * 0.18, child: child),
        child: const Zumi(size: 64),
      );
}
