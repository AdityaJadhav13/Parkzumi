import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/device_db.dart';
import '../data/tips_service.dart';
import '../domain/time_ist.dart';
import 'widgets.dart';

/// Failure injection and evidence for the demo: what the outbox holds, what
/// the server did, and the event trail that reconstructs it.
class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> {
  String? _filter;
  var _syncing = false;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final t = Theme.of(context).textTheme;
    final services = ref.watch(servicesProvider);
    final net = ref.watch(networkProvider).value ?? services.net;
    final ops = ref.watch(outboxProvider).value ?? const <OutboxOp>[];
    final events = ref.watch(eventsProvider).value ?? const <EventLogData>[];
    final cached = ref.watch(evidenceProvider).value;
    final shown = _filter == null ? events : events.where((e) => e.correlationId == _filter).toList();
    final open = ops.where((o) => o.state != OpState.done).toList();

    return CupertinoPageScaffold(
      backgroundColor: pz.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: pz.background,
        middle: const Text('Diagnostics'),
        previousPageTitle: 'More',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: await services.log.exportJson()));
            if (context.mounted) toast(context, 'Event log copied as JSON', icon: CupertinoIcons.doc_on_clipboard_fill);
          },
          child: const Text('Export'),
        ),
      ),
      child: SafeArea(
        child: ListView(children: [
          Group(
            header: 'Simulate failures',
            footer: 'Between this phone and the simulated server. Reviewer actions are a different client and aren’t affected.',
            children: [
              CupertinoListTile(
                leading: Icon(net.online ? CupertinoIcons.wifi : CupertinoIcons.wifi_slash),
                title: const Text('Online'),
                trailing: CupertinoSwitch(
                  value: net.online,
                  onChanged: (v) {
                    services.net.update((n) => n.online = v);
                    if (v) services.sync.retryNow();
                  },
                ),
              ),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.antenna_radiowaves_left_right),
                title: const Text('Lose the reply to the next tip'),
                subtitle: const Text('Server saves it; the phone never hears back'),
                trailing: CupertinoSwitch(value: net.dropNextResponse, onChanged: (v) => services.net.update((n) => n.dropNextResponse = v)),
              ),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.exclamationmark_circle),
                title: const Text('Next 2 requests fail (503)'),
                additionalInfo: Text(net.failNextRequests > 0 ? '${net.failNextRequests} left' : ''),
                onTap: () => services.net.update((n) => n.failNextRequests = 2),
              ),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.hourglass),
                title: const Text('Slow network (2.5 s)'),
                trailing: CupertinoSwitch(
                  value: net.latency.inMilliseconds >= 2500,
                  onChanged: (v) => services.net.update((n) => n.latency = Duration(milliseconds: v ? 2500 : 350)),
                ),
              ),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.sparkles),
                title: const Text('Photo check times out'),
                trailing: CupertinoSwitch(value: net.aiTimeout, onChanged: (v) => services.net.update((n) => n.aiTimeout = v)),
              ),
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.sparkles),
                title: const Text('Photo check returns broken JSON'),
                trailing: CupertinoSwitch(value: net.aiMalformed, onChanged: (v) => services.net.update((n) => n.aiMalformed = v)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.l),
            child: PzButton(
              label: 'Sync now',
              icon: CupertinoIcons.arrow_clockwise,
              kind: PzButtonKind.secondary,
              loading: _syncing,
              onPressed: () async {
                setState(() => _syncing = true);
                await services.sync.retryNow();
                if (mounted) setState(() => _syncing = false);
              },
            ),
          ),
          Group(
            header: 'Outbox (${open.length} open)',
            footer: 'Each operation keeps its id across retries, so the server can recognise a repeat.',
            children: [
              if (ops.isEmpty) const CupertinoListTile(title: Text('Empty')),
              for (final o in ops.take(12))
                CupertinoListTile(
                  title: Text('${o.kind} · ${o.state}', style: const TextStyle(fontFeatures: Fonts.tabular)),
                  subtitle: Text(
                    '${o.opId.split('-').last} · attempts ${o.attempts}'
                    '${o.state == OpState.pending ? ' · next ${formatIstTime(o.nextAttemptAt)}' : ''}'
                    '${o.lastError == null ? '' : ' · ${o.lastError}'}',
                  ),
                  onTap: () => setState(() => _filter = o.correlationId),
                ),
            ],
          ),
          Group(header: 'Evidence', children: [
            CupertinoListTile(
              title: const Text('On this phone'),
              additionalInfo: Text(cached == null ? '—' : 'v${cached.snapshot.version} · ${formatAge(DateTime.now().difference(cached.fetchedAt))}'),
            ),
            CupertinoListTile(
              title: const Text('Photo check'),
              additionalInfo: Text(services.aiConfigured ? services.ai.modelName : 'not configured'),
            ),
          ]),
          Group(
            header: _filter == null ? 'Event trail' : 'Event trail · ${_filter!.split('-').last}',
            footer: 'Tap an event to follow its id. No photos, notes or exact locations are logged.',
            children: [
              if (_filter != null)
                CupertinoListTile(title: const Text('Show all events'), leading: const Icon(CupertinoIcons.xmark), onTap: () => setState(() => _filter = null)),
              for (final e in shown.take(120)) _EventTile(event: e, onTap: () => setState(() => _filter = e.correlationId)),
            ],
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + Space.x4),
          Text('', style: t.labelSmall),
        ]),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, required this.onTap});
  final EventLogData event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pz = Pz.of(context);
    final (fg, bg) = switch (event.origin) {
      'server' => (pz.community.fg, pz.community.bg),
      'network' => (pz.caution.fg, pz.caution.bg),
      _ => (pz.textSecondary, pz.unknown.bg),
    };
    final attrs = (jsonDecode(event.attrs) as Map).entries.map((e) => '${e.key}=${e.value}').join(' ');
    final w = istWall(event.at);
    final time = '${w.hour.toString().padLeft(2, '0')}:${w.minute.toString().padLeft(2, '0')}:${w.second.toString().padLeft(2, '0')}';
    return CupertinoListTile(
      onTap: event.correlationId == null ? null : onTap,
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
        child: Text(event.origin, style: TextStyle(fontFamily: Fonts.body, fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
      ),
      leadingSize: 52,
      title: Text(event.type, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        '$time${event.correlationId == null ? '' : ' · ${event.correlationId!.split('-').last}'}${attrs.isEmpty ? '' : ' · $attrs'}',
        maxLines: 2,
        style: const TextStyle(fontFeatures: Fonts.tabular),
      ),
    );
  }
}
