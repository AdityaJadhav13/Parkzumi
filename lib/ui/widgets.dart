import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/theme.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';

/// Colour, symbol and words for a verdict. Colour never carries the meaning
/// alone: every status also has an icon and a label.
class VerdictLook {
  const VerdictLook(this.fg, this.bg, this.icon, this.label);
  final Color fg;
  final Color bg;
  final IconData icon;
  final String label;

  static VerdictLook of(BuildContext context, Verdict verdict, {bool fitsStay = true}) {
    final pz = Pz.of(context);
    return switch (verdict) {
      Verdict.permitted => VerdictLook(pz.permitted.fg, pz.permitted.bg, CupertinoIcons.checkmark_shield_fill, 'Permitted'),
      Verdict.conditional when fitsStay =>
        VerdictLook(pz.permitted.fg, pz.permitted.bg, CupertinoIcons.checkmark_seal_fill, 'Allowed with conditions'),
      Verdict.conditional =>
        VerdictLook(pz.caution.fg, pz.caution.bg, CupertinoIcons.exclamationmark_triangle_fill, 'Doesn’t fit your plan'),
      Verdict.prohibited => VerdictLook(pz.restriction.fg, pz.restriction.bg, CupertinoIcons.xmark_octagon_fill, 'Restriction found'),
      Verdict.unknown => VerdictLook(pz.unknown.fg, pz.unknown.bg, CupertinoIcons.question_circle_fill, 'Can’t verify'),
    };
  }

  static VerdictLook forAssessment(BuildContext context, Assessment a) => of(context, a.verdict, fitsStay: a.fitsStay);
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.look, {super.key, this.compact = false});
  final VerdictLook look;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(color: look.bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(look.icon, size: compact ? 13 : 15, color: look.fg),
        const SizedBox(width: 5),
        Flexible(
          child: Text(look.label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: Fonts.body, fontSize: compact ? 12 : 13, fontWeight: FontWeight.w700, color: look.fg)),
        ),
      ]),
    );
  }
}

({IconData icon, Color color}) levelLook(BuildContext context, Level level, {SourceClass? source}) {
  final pz = Pz.of(context);
  if (source == SourceClass.community && (level == Level.info || level == Level.good)) {
    return (icon: CupertinoIcons.person_2_fill, color: pz.community.fg);
  }
  return switch (level) {
    Level.good => (icon: CupertinoIcons.checkmark_circle_fill, color: pz.permitted.fg),
    Level.info => (icon: CupertinoIcons.info_circle_fill, color: pz.textSecondary),
    Level.caution => (icon: CupertinoIcons.exclamationmark_triangle_fill, color: pz.caution.fg),
    Level.blocker => (icon: CupertinoIcons.xmark_octagon_fill, color: pz.restriction.fg),
    Level.unknown => (icon: CupertinoIcons.question_circle, color: pz.unknown.fg),
  };
}

/// Explicit source class instead of a generic "verified" badge.
class SourceTag extends StatelessWidget {
  const SourceTag(this.source, {super.key});
  final SourceClass source;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final (fg, bg) = switch (source) {
      SourceClass.official => (pz.textPrimary, pz.unknown.bg),
      SourceClass.operator => (pz.textPrimary, pz.unknown.bg),
      SourceClass.community => (pz.community.fg, pz.community.bg),
      SourceClass.ai => (pz.textSecondary, pz.unknown.bg),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(source.label, style: TextStyle(fontFamily: Fonts.body, fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

enum PzButtonKind { primary, secondary, destructive, plain }

/// Pressable with a quick scale-down, haptic tick and explicit loading state.
class PzButton extends StatefulWidget {
  const PzButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.kind = PzButtonKind.primary,
    this.loading = false,
    this.expand = true,
    this.semanticsHint,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PzButtonKind kind;
  final bool loading;
  final bool expand;
  final String? semanticsHint;

  @override
  State<PzButton> createState() => _PzButtonState();
}

class _PzButtonState extends State<PzButton> {
  var _down = false;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final enabled = widget.onPressed != null && !widget.loading;
    final (bg, fg, border) = switch (widget.kind) {
      PzButtonKind.primary => (Pz.lime, Pz.ink, Colors.transparent),
      PzButtonKind.secondary => (pz.surface, pz.textPrimary, pz.textSecondary.withValues(alpha: 0.5)),
      PzButtonKind.destructive => (pz.restriction.bg, pz.restriction.fg, Colors.transparent),
      PzButtonKind.plain => (Colors.transparent, pz.tint, Colors.transparent),
    };
    final child = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          CupertinoActivityIndicator(color: fg, radius: 9)
        else if (widget.icon != null)
          Icon(widget.icon, size: 19, color: fg),
        if (widget.loading || widget.icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: Fonts.body, fontSize: 16, height: 1.25, fontWeight: FontWeight.w700, color: fg)),
        ),
      ],
    );
    return Semantics(
      button: true,
      enabled: enabled,
      hint: widget.semanticsHint,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                widget.onPressed!();
              }
            : null,
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: Motion.of(context, Motion.quick),
          curve: Motion.curve,
          child: AnimatedOpacity(
            opacity: enabled || widget.loading ? 1 : 0.45,
            duration: Motion.of(context, Motion.standard),
            child: Container(
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(Radii.control),
                border: Border.all(color: border, width: widget.kind == PzButtonKind.secondary ? 1.2 : 0),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class PzCard extends StatelessWidget {
  const PzCard({super.key, required this.child, this.padding = const EdgeInsets.all(Space.l), this.color, this.borderColor});
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? pz.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: borderColor ?? pz.border),
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(Space.xs, Space.xl, Space.xs, Space.s),
        child: Row(children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge)),
          ?trailing,
        ]),
      );
}

/// Inline notice: concrete event first, then what the rider can do.
class Notice extends StatelessWidget {
  const Notice({super.key, required this.level, required this.title, this.message, this.action, this.onAction, this.icon});
  final Level level;
  final String title;
  final String? message;
  final String? action;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final colors = switch (level) {
      Level.blocker => pz.restriction,
      Level.caution => pz.caution,
      Level.good => pz.permitted,
      _ => pz.unknown,
    };
    final look = levelLook(context, level);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.m),
      decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(Radii.control)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon ?? look.icon, size: 20, color: colors.fg),
        const SizedBox(width: Space.s),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.w700, fontSize: 15, color: colors.fg)),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(message!, style: TextStyle(fontFamily: Fonts.body, fontSize: 14, height: 1.35, color: colors.fg)),
              ),
            if (action != null)
              CupertinoButton(
                padding: const EdgeInsets.only(top: 6),
                minimumSize: const Size(44, 32),
                onPressed: onAction,
                child: Text(action!, style: TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.w700, fontSize: 15, color: colors.fg, decoration: TextDecoration.underline)),
              ),
          ]),
        ),
      ]),
    );
  }
}

/// Zumi, the lime street cat. Decorative: hidden from screen readers.
class Zumi extends StatelessWidget {
  const Zumi({super.key, this.size = 72, this.tilt = 0});
  final double size;

  /// Head tilt in turns: a curious tilt for uncertainty.
  final double tilt;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: AnimatedRotation(
          turns: tilt,
          duration: Motion.of(context, Motion.context),
          curve: Motion.curve,
          child: SvgPicture.asset('assets/brand/zumi_head.svg', width: size, height: size),
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message, this.action, this.tilt = 0});
  final String title;
  final String message;
  final Widget? action;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.x3, vertical: Space.x4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Zumi(size: 88, tilt: tilt),
        const SizedBox(height: Space.l),
        Text(title, textAlign: TextAlign.center, style: t.titleLarge),
        const SizedBox(height: Space.s),
        Text(message, textAlign: TextAlign.center, style: t.bodyMedium),
        if (action != null) ...[const SizedBox(height: Space.xl), action!],
      ]),
    );
  }
}

/// iOS-style grouped list with Parkzumi surfaces.
class Group extends StatelessWidget {
  const Group({super.key, required this.children, this.header, this.footer});
  final List<Widget> children;
  final String? header;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    return CupertinoListSection.insetGrouped(
      margin: const EdgeInsets.fromLTRB(Space.l, Space.s, Space.l, Space.s),
      backgroundColor: pz.background,
      decoration: BoxDecoration(color: pz.surface, borderRadius: BorderRadius.circular(Radii.control)),
      separatorColor: pz.border,
      header: header == null ? null : Text(header!.toUpperCase(), style: TextStyle(fontFamily: Fonts.body, fontSize: 12, letterSpacing: 0.4, color: pz.textSecondary)),
      footer: footer == null ? null : Text(footer!, style: TextStyle(fontFamily: Fonts.body, fontSize: 13, color: pz.textSecondary)),
      children: children,
    );
  }
}

IconData vehicleIcon(VehicleClass v) => v == VehicleClass.car ? CupertinoIcons.car_fill : Icons.two_wheeler;

String distanceLabel(double? metres) {
  if (metres == null) return '';
  if (metres < 1000) return '${(metres / 10).round() * 10} m';
  return '${(metres / 1000).toStringAsFixed(1)} km';
}

/// Walking minutes at ~4.5 km/h, for the walk back to the vehicle.
int walkMinutes(double metres) => (metres / 75).ceil().clamp(1, 600);

Future<void> showInfo(BuildContext context, String title, String message) => showCupertinoDialog<void>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(c), child: const Text('OK'))],
      ),
    );

Future<bool> confirm(BuildContext context, {required String title, required String message, required String action, bool destructive = false}) async =>
    await showCupertinoDialog<bool>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          CupertinoDialogAction(isDestructiveAction: destructive, isDefaultAction: !destructive, onPressed: () => Navigator.pop(c, true), child: Text(action)),
        ],
      ),
    ) ??
    false;

/// Brief confirmation that floats above the content, then fades.
void toast(BuildContext context, String message, {IconData icon = CupertinoIcons.checkmark_circle_fill}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (c) => _Toast(message: message, icon: icon, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _Toast extends StatefulWidget {
  const _Toast({required this.message, required this.icon, required this.onDone});
  final String message;
  final IconData icon;
  final VoidCallback onDone;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> {
  var _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _visible = true);
      SemanticsService.sendAnnouncement(View.of(context), widget.message, TextDirection.ltr);
      await Future<void>.delayed(const Duration(milliseconds: 2200));
      if (!mounted) return;
      setState(() => _visible = false);
      await Future<void>.delayed(const Duration(milliseconds: 260));
      widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom + 96;
    return Positioned(
      left: Space.l,
      right: Space.l,
      bottom: bottom,
      child: IgnorePointer(
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.4),
          duration: Motion.of(context, Motion.context),
          curve: Motion.curve,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: Motion.of(context, Motion.standard),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.m),
                decoration: BoxDecoration(color: Pz.ink, borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(widget.icon, color: Pz.lime, size: 18),
                  const SizedBox(width: Space.s),
                  Flexible(
                    child: Text(widget.message,
                        style: const TextStyle(fontFamily: Fonts.body, color: Pz.paper, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.none)),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
