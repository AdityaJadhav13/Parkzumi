import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'widgets.dart';

String contextSummary(CheckContext c) =>
    '${c.arrival == null ? 'Now' : formatIstDateTime(c.arrival!)} · ${formatDuration(c.stay)}';

/// Tappable summary of the plan: vehicle, arrival and stay.
class ContextChip extends ConsumerWidget {
  const ContextChip({super.key, this.onSurface = false});
  final bool onSurface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(checkContextProvider);
    final pz = Pz.of(context);
    return Semantics(
      button: true,
      label: 'Plan: ${c.vehicle.label}, ${contextSummary(c)}. Change',
      child: GestureDetector(
        onTap: () => showContextSheet(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Space.m, vertical: Space.s),
          decoration: BoxDecoration(
            color: onSurface ? pz.background : pz.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: pz.border),
            boxShadow: onSurface ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(vehicleIcon(c.vehicle), size: 18, color: pz.textPrimary),
            const SizedBox(width: 6),
            Text(c.vehicle.label, style: Theme.of(context).textTheme.labelMedium),
            Container(width: 1, height: 16, margin: const EdgeInsets.symmetric(horizontal: Space.s), color: pz.border),
            Icon(CupertinoIcons.clock, size: 16, color: pz.textPrimary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(contextSummary(c),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontFeatures: Fonts.tabular)),
            ),
            const SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_down, size: 14, color: pz.textSecondary),
          ]),
        ),
      ),
    );
  }
}

Future<void> showContextSheet(BuildContext context) =>
    showCupertinoModalPopup<void>(context: context, builder: (_) => const _ContextSheet());

class _ContextSheet extends ConsumerStatefulWidget {
  const _ContextSheet();

  @override
  ConsumerState<_ContextSheet> createState() => _ContextSheetState();
}

class _ContextSheetState extends ConsumerState<_ContextSheet> {
  static const presets = [Duration(minutes: 30), Duration(hours: 1), Duration(hours: 2), Duration(hours: 4), Duration(hours: 8)];
  late CheckContext draft = ref.read(checkContextProvider);
  var _pickingTime = false;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: pz.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.container))),
      padding: EdgeInsets.fromLTRB(Space.l, Space.m, Space.l, MediaQuery.paddingOf(context).bottom + Space.l),
      child: Material(
        color: Colors.transparent,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 36, height: 5, decoration: BoxDecoration(color: pz.border, borderRadius: BorderRadius.circular(3)))),
          const SizedBox(height: Space.m),
          Text('Your plan', style: t.headlineSmall),
          const SizedBox(height: Space.l),
          Text('Vehicle', style: t.labelMedium),
          const SizedBox(height: Space.s),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<VehicleClass>(
              groupValue: draft.vehicle,
              children: {
                for (final v in VehicleClass.values)
                  v: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(vehicleIcon(v), size: 18),
                      const SizedBox(width: 6),
                      Text(v.label, style: t.labelMedium),
                    ]),
                  ),
              },
              onValueChanged: (v) {
                if (v == null) return;
                HapticFeedback.selectionClick();
                setState(() => draft = draft.copyWith(vehicle: v));
              },
            ),
          ),
          const SizedBox(height: Space.xl),
          Row(children: [
            Expanded(child: Text('Arriving', style: t.labelMedium)),
            CupertinoSlidingSegmentedControl<bool>(
              groupValue: draft.arrival == null,
              children: const {true: Text('  Now  '), false: Text('  Later  ')},
              onValueChanged: (now) {
                HapticFeedback.selectionClick();
                setState(() {
                  if (now == true) {
                    draft = draft.copyWith(arriveNow: true);
                    _pickingTime = false;
                  } else {
                    final base = DateTime.now().add(const Duration(hours: 1));
                    draft = draft.copyWith(arrival: DateTime(base.year, base.month, base.day, base.hour));
                    _pickingTime = true;
                  }
                });
              },
            ),
          ]),
          if (draft.arrival != null) ...[
            const SizedBox(height: Space.s),
            GestureDetector(
              onTap: () => setState(() => _pickingTime = !_pickingTime),
              child: Text(formatIstDateTime(draft.arrival!),
                  style: t.titleMedium?.copyWith(color: pz.tint, fontFeatures: Fonts.tabular)),
            ),
            AnimatedSize(
              duration: Motion.of(context, Motion.context),
              curve: Motion.curve,
              child: _pickingTime
                  ? SizedBox(
                      height: 180,
                      child: CupertinoDatePicker(
                        initialDateTime: draft.arrival,
                        minuteInterval: 15,
                        use24hFormat: false,
                        onDateTimeChanged: (d) => setState(() => draft = draft.copyWith(arrival: d)),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
          const SizedBox(height: Space.xl),
          Text('How long you’ll stay', style: t.labelMedium),
          const SizedBox(height: Space.s),
          Wrap(spacing: Space.s, runSpacing: Space.s, children: [
            for (final d in presets)
              _Chip(
                label: formatDuration(d),
                selected: draft.stay == d,
                onTap: () => setState(() => draft = draft.copyWith(stay: d)),
              ),
          ]),
          const SizedBox(height: Space.xxl),
          PzButton(
            label: 'Check spots',
            icon: CupertinoIcons.checkmark,
            onPressed: () {
              ref.read(checkContextProvider.notifier).set(draft);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: Motion.of(context, Motion.standard),
          curve: Motion.curve,
          constraints: const BoxConstraints(minHeight: 44, minWidth: 64),
          padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
          decoration: BoxDecoration(
            color: selected ? Pz.lime : pz.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? Pz.ink : pz.border, width: selected ? 1.5 : 1),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.w700, fontSize: 15, color: selected ? Pz.ink : pz.textPrimary)),
        ),
      ),
    );
  }
}
