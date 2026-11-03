import 'catalogue.dart';

typedef Label = ({String value, String label});

Label _label(Object? json) => json is Map ? (value: '${json['value']}', label: '${json['label']}') : (value: '', label: '');

/// Billet (QR code donné seulement à son porteur).
class Ticket {
  const Ticket({
    required this.code,
    required this.type,
    this.holderName,
    required this.status,
    required this.isMine,
    this.qr,
    this.scannedAt,
    this.transferredTo,
    this.transferredFrom,
    this.claimUrl,
  });

  final String code;
  final String type;
  final String? holderName;
  final Label status;
  final bool isMine;
  final String? qr;
  final DateTime? scannedAt;
  final String? transferredTo;
  final String? transferredFrom;
  final String? claimUrl;

  bool get isValid => status.value == 'valide';

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        code: '${json['code']}',
        type: '${json['type']}',
        holderName: json['holder_name'] as String?,
        status: _label(json['status']),
        isMine: json['is_mine'] == true,
        qr: json['qr'] as String?,
        scannedAt: DateTime.tryParse(json['scanned_at'] as String? ?? ''),
        transferredTo: json['transferred_to'] as String?,
        transferredFrom: json['transferred_from'] as String?,
        claimUrl: json['claim_url'] as String?,
      );
}

/// Réservation dans « Mes billets » (4.5).
class Booking {
  const Booking({
    required this.json,
    required this.code,
    required this.status,
    required this.channel,
    required this.isBuyer,
    required this.eventSlug,
    required this.eventTitle,
    this.cover,
    this.place,
    this.address,
    this.wilaya,
    this.lat,
    this.lng,
    required this.organizerName,
    this.organizerPhone,
    required this.policy,
    this.entryDeadline,
    required this.startsAt,
    this.sessionLabel,
    required this.items,
    required this.options,
    this.pickupPoint,
    this.total,
    this.depositAmount,
    this.paymentMethod,
    this.refundedAmount = 0,
    this.holdExpiresAt,
    this.respondBy,
    required this.fromWaitlist,
    required this.tickets,
    required this.canCancel,
    this.cancelledBy,
    this.cancelReason,
    this.groupUrl,
    required this.calendarUrl,
  });

  /// Réponse brute de l'API, gardée sur le téléphone pour l'affichage hors connexion.
  final Map<String, dynamic> json;
  final String code;
  final Label status;
  final String channel;
  final bool isBuyer;
  final String eventSlug;
  final String eventTitle;
  final Sizes? cover;
  final String? place;
  final String? address;
  final String? wilaya;
  final double? lat;
  final double? lng;
  final String organizerName;
  final String? organizerPhone;
  final String policy;
  final String? entryDeadline;
  final DateTime startsAt;
  final String? sessionLabel;
  final List<({String name, int quantity, int unitPrice})> items;
  final List<({String name, int quantity, int price})> options;
  final String? pickupPoint;
  final int? total;
  final int? depositAmount;
  final String? paymentMethod;
  final int refundedAmount;
  final DateTime? holdExpiresAt;
  final DateTime? respondBy;
  final bool fromWaitlist;
  final List<Ticket> tickets;
  final bool canCancel;
  final String? cancelledBy;
  final String? cancelReason;
  final String? groupUrl;
  final String calendarUrl;

  List<Ticket> get myTickets => tickets.where((t) => t.isMine).toList();

  factory Booking.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>;
    final session = json['session'] as Map<String, dynamic>;
    final coords = event['coordinates'] as Map<String, dynamic>?;
    final pickup = json['pickup_point'] as Map<String, dynamic>?;
    return Booking(
      json: json,
      code: '${json['code']}',
      status: _label(json['status']),
      channel: '${json['channel']}',
      isBuyer: json['is_buyer'] == true,
      eventSlug: '${event['slug']}',
      eventTitle: '${event['title']}',
      cover: Sizes.fromJson(event['cover']),
      place: event['place'] as String?,
      address: event['address'] as String?,
      wilaya: event['wilaya'] as String?,
      lat: (coords?['lat'] as num?)?.toDouble(),
      lng: (coords?['lng'] as num?)?.toDouble(),
      organizerName: '${(event['organizer'] as Map)['name']}',
      organizerPhone: (event['organizer'] as Map)['phone'] as String?,
      policy: _label(event['cancellation_policy']).label,
      entryDeadline: event['entry_deadline'] as String?,
      startsAt: DateTime.parse('${session['starts_at']}'),
      sessionLabel: session['label'] as String?,
      items: [for (final item in json['items'] as List? ?? const []) (name: '${item['name']}', quantity: item['quantity'] as int, unitPrice: item['unit_price'] as int)],
      options: [for (final option in json['options'] as List? ?? const []) (name: '${option['name']}', quantity: option['quantity'] as int, price: option['price'] as int)],
      pickupPoint: pickup == null ? null : [if (pickup['time'] != null) pickup['time'], pickup['label']].join(' · '),
      total: json['total'] as int?,
      depositAmount: json['deposit_amount'] as int?,
      paymentMethod: json['payment_method'] == null ? null : _label(json['payment_method']).label,
      refundedAmount: ((json['payment'] as Map?)?['refunded_amount'] as int?) ?? 0,
      holdExpiresAt: DateTime.tryParse(json['hold_expires_at'] as String? ?? ''),
      respondBy: DateTime.tryParse(json['respond_by'] as String? ?? ''),
      fromWaitlist: json['from_waitlist'] == true,
      tickets: [for (final ticket in json['tickets'] as List? ?? const []) Ticket.fromJson(ticket as Map<String, dynamic>)],
      canCancel: json['can_cancel'] == true,
      cancelledBy: json['cancelled_by'] == null ? null : _label(json['cancelled_by']).label,
      cancelReason: json['cancel_reason'] as String?,
      groupUrl: (json['group'] as Map?)?['share_url'] as String?,
      calendarUrl: '${json['calendar_url']}',
    );
  }
}

/// Places restantes et liste d'attente pour l'écran de réservation.
class Availability {
  const Availability({required this.sessions, required this.maxPerPerson, required this.alreadyBooked, required this.waitlist});

  final List<EventSessionInfo> sessions;
  final int maxPerPerson;
  final int alreadyBooked;

  /// Séance → 'en_attente' ou 'proposee'.
  final Map<int, String> waitlist;

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        sessions: [for (final s in json['sessions'] as List? ?? const []) EventSessionInfo.fromJson(s as Map<String, dynamic>)],
        maxPerPerson: json['max_per_person'] as int? ?? 10,
        alreadyBooked: json['already_booked'] as int? ?? 0,
        waitlist: {for (final w in json['waitlist'] as List? ?? const []) w['event_session_id'] as int: '${w['status']}'},
      );
}

/// Séance que l'équipe d'accueil peut contrôler.
class ScanSession {
  const ScanSession({required this.id, required this.startsAt, this.label, required this.eventTitle, required this.organizer, required this.admitted, required this.expected});

  final int id;
  final DateTime startsAt;
  final String? label;
  final String eventTitle;
  final String organizer;
  final int admitted;
  final int expected;

  factory ScanSession.fromJson(Map<String, dynamic> json) => ScanSession(
        id: json['id'] as int,
        startsAt: DateTime.parse('${json['starts_at']}'),
        label: json['label'] as String?,
        eventTitle: '${(json['event'] as Map)['title']}',
        organizer: '${json['organizer']}',
        admitted: json['admitted'] as int? ?? 0,
        expected: json['expected'] as int? ?? 0,
      );
}

/// Billet de la liste téléchargée pour scanner sans réseau.
class ScanTicket {
  ScanTicket({required this.code, required this.type, this.holderName, this.pickup, required this.status, this.scannedAt});

  final String code;
  final String type;
  final String? holderName;
  final String? pickup;
  String status;
  DateTime? scannedAt;

  factory ScanTicket.fromJson(Map<String, dynamic> json) => ScanTicket(
        code: '${json['code']}',
        type: '${json['type']}',
        holderName: json['holder_name'] as String?,
        pickup: json['pickup_point'] as String?,
        status: '${json['status']}',
        scannedAt: DateTime.tryParse(json['scanned_at'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'type': type,
        'holder_name': holderName,
        'pickup_point': pickup,
        'status': status,
        'scanned_at': scannedAt?.toUtc().toIso8601String(),
      };
}

/// Code du billet lu dans un QR Dowra (« DOWRA:code:signature ») ou saisi à la main (« T… »).
String? ticketCodeFrom(String scanned) {
  final value = scanned.trim();
  final qr = RegExp(r'^DOWRA:([A-Z0-9]{6,16}):[A-Za-z0-9_-]{12}$').firstMatch(value);
  if (qr != null) return qr.group(1);
  final manual = value.toUpperCase();
  return RegExp(r'^T[A-Z0-9]{9}$').hasMatch(manual) ? manual : null;
}
