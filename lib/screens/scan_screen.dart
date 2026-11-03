import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../core/booking_providers.dart';
import '../core/bookings.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';

/// Mode scan (5.3, 7.4) : choix de la séance à contrôler.
class ScanSessionsScreen extends ConsumerWidget {
  const ScanSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final sessions = ref.watch(scanSessionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.scanMode)),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(scanSessionsProvider),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text(t.scanChoose, style: TextStyle(color: palette.muted)),
          const SizedBox(height: 14),
          sessions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => RetryCard(onRetry: () => ref.invalidate(scanSessionsProvider)),
            data: (list) => list.isEmpty
                ? DowriCard(mood: DowriMood.repos, text: t.scanNoSession)
                : Column(children: [
                    for (final session in list)
                      Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          title: Text(session.eventTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text('${formatDateTime(lang, session.startsAt)}${session.label != null ? ' · ${session.label}' : ''}\n${session.organizer}'),
                          isThreeLine: true,
                          trailing: Text('${session.admitted} / ${session.expected}', style: TextStyle(fontWeight: FontWeight.w800, color: palette.accent)),
                          onTap: () => context.push('/scan/${session.id}'),
                        ),
                      ),
                  ]),
          ),
        ]),
      ),
    );
  }
}

/// Résultat affiché après un scan.
class _Result {
  const _Result(this.color, this.title, this.detail);

  final String color;
  final String title;
  final String? detail;
}

/// Contrôle des entrées d'une séance. La liste des billets est gardée sur le téléphone : chaque scan est jugé
/// sur place (vert, orange, rouge), même sans réseau, et envoyé dès que le réseau revient.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key, required this.sessionId, this.camera = true});

  final int sessionId;

  /// Caméra désactivée dans les tests.
  final bool camera;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final Map<String, ScanTicket> _tickets = {};
  final List<Map<String, dynamic>> _pending = [];
  String? _title;
  String? _syncedAt;
  bool _loading = true;
  bool _online = true;
  bool _syncing = false;
  _Result? _result;
  String? _last;
  DateTime _lastAt = DateTime(2000);
  Timer? _timer;
  final _manual = TextEditingController();

  String get _key => 'dowra_offline_scan_${widget.sessionId}';
  int get _admitted => _tickets.values.where((ticket) => ticket.status == 'utilise').length;
  int get _expected => _tickets.values.where((ticket) => ticket.status != 'annule').length;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _sync());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final store = ref.read(offlineStoreProvider);
    final cached = await store.readJson(_key);
    if (cached is Map) {
      _title = cached['title'] as String?;
      _syncedAt = cached['synced_at'] as String?;
      for (final item in cached['tickets'] as List? ?? const []) {
        final ticket = ScanTicket.fromJson(Map<String, dynamic>.from(item as Map));
        _tickets[ticket.code] = ticket;
      }
      _pending.addAll([for (final p in cached['pending'] as List? ?? const []) Map<String, dynamic>.from(p as Map)]);
    }
    try {
      final data = await ref.read(repositoryProvider).scanTickets(widget.sessionId);
      _title = '${(data['session'] as Map)['event']}';
      final fresh = {for (final item in data['tickets'] as List) '${item['code']}': ScanTicket.fromJson(item as Map<String, dynamic>)};
      // Les entrées faites ici sans réseau et pas encore envoyées restent comptées.
      for (final scan in _pending) {
        final code = ticketCodeFrom('${scan['code']}');
        if (code != null && fresh[code] != null && fresh[code]!.status == 'valide') {
          fresh[code]!
            ..status = 'utilise'
            ..scannedAt = DateTime.tryParse('${scan['scanned_at']}');
        }
      }
      _tickets
        ..clear()
        ..addAll(fresh);
      _syncedAt = data['downloaded_at'] as String?;
      _online = true;
    } catch (_) {
      _online = false;
    }
    await _save();
    if (mounted) setState(() => _loading = false);
    _sync();
  }

  Future<void> _save() => ref.read(offlineStoreProvider).writeJson(_key, {
        'title': _title,
        'synced_at': _syncedAt,
        'tickets': [for (final ticket in _tickets.values) ticket.toJson()],
        'pending': _pending,
      });

  /// Envoie les scans en attente, puis applique les statuts du serveur (entrées scannées sur d'autres téléphones).
  Future<void> _sync() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final batch = List<Map<String, dynamic>>.from(_pending);
      final data = await ref.read(repositoryProvider).syncScans(widget.sessionId, batch, since: null);
      _pending.removeWhere(batch.contains);
      for (final item in data['tickets'] as List? ?? const []) {
        final ticket = _tickets['${item['code']}'];
        if (ticket != null) {
          ticket
            ..status = '${item['status']}'
            ..scannedAt = DateTime.tryParse(item['scanned_at'] as String? ?? '');
        }
      }
      _syncedAt = data['synced_at'] as String?;
      _online = true;
      await _save();
    } catch (_) {
      _online = false;
    } finally {
      _syncing = false;
      if (mounted) setState(() {});
    }
  }

  String _uuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  void _check(String raw, {bool manual = false}) {
    final now = DateTime.now();
    if (raw == _last && now.difference(_lastAt) < const Duration(seconds: 3)) return;
    _last = raw;
    _lastAt = now;
    final t = AppLocalizations.of(context);
    final lang = ref.read(localeProvider);
    final code = ticketCodeFrom(raw);
    final ticket = code == null ? null : _tickets[code];
    _Result result;
    if (ticket == null) {
      result = _Result('rouge', t.scanUnknown, code);
    } else if (ticket.status == 'annule') {
      result = _Result('rouge', t.scanCancelled, ticket.holderName ?? ticket.code);
    } else if (ticket.status == 'utilise') {
      result = _Result('orange', t.scanAlreadyUsed, [ticket.holderName ?? ticket.code, if (ticket.scannedAt != null) t.scannedOn(formatDateTime(lang, ticket.scannedAt!))].join('\n'));
    } else {
      ticket
        ..status = 'utilise'
        ..scannedAt = now;
      _pending.add({'uuid': _uuid(), 'code': raw, 'scanned_at': now.toUtc().toIso8601String(), 'manual': manual});
      result = _Result('vert', t.scanValid, [ticket.holderName, ticket.type, ticket.pickup].whereType<String>().join(' · '));
      _save();
      _sync();
    }
    HapticFeedback.heavyImpact();
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final color = switch (_result?.color) { 'vert' => DowraColors.success, 'orange' => DowraColors.warning, 'rouge' => DowraColors.error, _ => palette.pale };
    return Scaffold(
      appBar: AppBar(title: Text(_title ?? t.scanMode)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 30), children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.scanAdmitted, style: TextStyle(color: palette.muted)),
              Text('$_admitted / $_expected', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [
              Icon(_online ? Icons.cloud_done_outlined : Icons.cloud_off_rounded, size: 18, color: _online ? DowraColors.success : DowraColors.warning),
              const SizedBox(width: 4),
              Text(_online ? t.scanOnline : t.scanOffline, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ]),
            if (_pending.isNotEmpty) Text(t.scanPending(_pending.length), style: TextStyle(color: palette.muted, fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 12),
        if (widget.camera)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 300,
              child: MobileScanner(
                onDetect: (capture) {
                  final value = capture.barcodes.firstOrNull?.rawValue;
                  if (value != null) _check(value);
                },
                errorBuilder: (context, error) => ColoredBox(
                  color: palette.pale,
                  child: Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(t.scanCameraError, textAlign: TextAlign.center))),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22)),
          child: _result == null
              ? Text(t.scanHint, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600))
              : Column(children: [
                  Icon(_result!.color == 'vert' ? Icons.check_circle_rounded : (_result!.color == 'orange' ? Icons.history_rounded : Icons.cancel_rounded), color: Colors.white, size: 48),
                  Text(_result!.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  if (_result!.detail != null) Text(_result!.detail!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _manual,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(labelText: t.scanManual, hintText: 'T…'),
              onSubmitted: (value) {
                _check(value, manual: true);
                _manual.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {
              _check(_manual.text, manual: true);
              _manual.clear();
            },
            icon: const Icon(Icons.check_rounded),
            tooltip: t.scanCheck,
          ),
        ]),
        const SizedBox(height: 10),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(onPressed: _syncing ? null : _sync, icon: const Icon(Icons.sync_rounded), label: Text(t.scanSync)),
        ),
        if (_syncedAt != null) Text(t.scanSyncedAt(formatDateTime(ref.watch(localeProvider), DateTime.parse(_syncedAt!))), style: TextStyle(color: palette.muted, fontSize: 12)),
      ]),
    );
  }
}
