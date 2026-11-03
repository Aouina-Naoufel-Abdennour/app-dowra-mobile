import 'api.dart';

/// Adresse d'une image de l'API. Sur l'émulateur Android, « localhost » désigne le téléphone :
/// les adresses locales sont réécrites vers l'hôte de l'API (10.0.2.2).
String? mediaUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final uri = Uri.tryParse(url);
  if (uri == null || !(uri.host == 'localhost' || uri.host == '127.0.0.1')) return url;
  final api = Uri.parse(defaultApiUrl());
  return uri.replace(host: api.host, port: api.hasPort ? uri.port : null).toString();
}

class Sizes {
  const Sizes({required this.thumb, required this.card, required this.full});

  final String thumb;
  final String card;
  final String full;

  static Sizes? fromJson(Object? json) {
    if (json is! Map) return null;
    return Sizes(thumb: mediaUrl(json['thumb'] as String?)!, card: mediaUrl(json['card'] as String?)!, full: mediaUrl(json['full'] as String?)!);
  }
}

class EventLabels {
  const EventLabels({this.hiddenGem = false, this.featured = false, this.wilayaOfDay = false, this.family = false, this.womenOnly = false, this.pmr = false});

  final bool hiddenGem;
  final bool featured;
  final bool wilayaOfDay;
  final bool family;
  final bool womenOnly;
  final bool pmr;

  factory EventLabels.fromJson(Map<String, dynamic> json) => EventLabels(
        hiddenGem: json['hidden_gem'] == true,
        featured: json['featured'] == true,
        wilayaOfDay: json['wilaya_of_day'] == true,
        family: json['family'] == true,
        womenOnly: json['women_only'] == true,
        pmr: json['pmr'] == true,
      );
}

/// Sortie en carte (listes, accueil, favoris).
class EventCard {
  const EventCard({
    required this.id,
    required this.slug,
    required this.title,
    this.summary,
    this.cover,
    required this.typeSlug,
    required this.typeName,
    this.typeIcon,
    required this.wilayaCode,
    required this.wilayaName,
    this.place,
    required this.organizerSlug,
    required this.organizerName,
    required this.organizerVerified,
    this.nextSessionAt,
    this.priceFrom,
    required this.isFree,
    required this.status,
    required this.labels,
    this.lat,
    this.lng,
    this.distanceKm,
  });

  final int id;
  final String slug;
  final String title;
  final String? summary;
  final Sizes? cover;
  final String typeSlug;
  final String typeName;
  final String? typeIcon;
  final int wilayaCode;
  final String wilayaName;
  final String? place;
  final String organizerSlug;
  final String organizerName;
  final bool organizerVerified;
  final DateTime? nextSessionAt;
  final int? priceFrom;
  final bool isFree;
  final String status;
  final EventLabels labels;
  final double? lat;
  final double? lng;
  final double? distanceKm;

  factory EventCard.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as Map<String, dynamic>? ?? const {};
    final wilaya = json['wilaya'] as Map<String, dynamic>? ?? const {};
    final organizer = json['organizer'] as Map<String, dynamic>? ?? const {};
    final coordinates = json['coordinates'] as Map<String, dynamic>?;
    return EventCard(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      cover: Sizes.fromJson(json['cover']),
      typeSlug: type['slug'] as String? ?? '',
      typeName: type['name'] as String? ?? '',
      typeIcon: type['icon'] as String?,
      wilayaCode: int.tryParse('${wilaya['code']}') ?? 0,
      wilayaName: wilaya['name'] as String? ?? '',
      place: json['place'] as String?,
      organizerSlug: organizer['slug'] as String? ?? '',
      organizerName: organizer['name'] as String? ?? '',
      organizerVerified: organizer['verified'] == true,
      nextSessionAt: DateTime.tryParse(json['next_session_at'] as String? ?? ''),
      priceFrom: json['price_from'] as int?,
      isFree: json['is_free'] == true,
      status: json['status'] as String? ?? 'publie',
      labels: EventLabels.fromJson(json['labels'] as Map<String, dynamic>? ?? const {}),
      lat: (coordinates?['lat'] as num?)?.toDouble(),
      lng: (coordinates?['lng'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );
  }
}

class EventSessionInfo {
  const EventSessionInfo({required this.id, required this.startsAt, this.endsAt, this.label, this.capacity, this.remaining, this.pickupPoints = const []});

  final int id;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? label;
  final int? capacity;
  final int? remaining;
  final List<({String label, String? time})> pickupPoints;

  factory EventSessionInfo.fromJson(Map<String, dynamic> json) => EventSessionInfo(
        id: json['id'] as int,
        startsAt: DateTime.parse(json['starts_at'] as String),
        endsAt: DateTime.tryParse(json['ends_at'] as String? ?? ''),
        label: json['label'] as String?,
        capacity: json['capacity'] as int?,
        remaining: json['remaining'] as int?,
        pickupPoints: [
          for (final point in json['pickup_points'] as List? ?? const []) (label: '${point['label']}', time: point['time'] as String?),
        ],
      );
}

class TicketInfo {
  const TicketInfo({required this.id, required this.kind, required this.name, required this.price, required this.seats, required this.onSale});

  final int id;
  final String kind;
  final String name;
  final int price;
  final int seats;
  final bool onSale;

  factory TicketInfo.fromJson(Map<String, dynamic> json) => TicketInfo(
        id: json['id'] as int,
        kind: json['kind'] as String? ?? 'normal',
        name: json['name'] as String? ?? '',
        price: json['price'] as int? ?? 0,
        seats: json['seats'] as int? ?? 1,
        onSale: json['on_sale'] != false,
      );
}

class OrganizerCard {
  const OrganizerCard({required this.slug, required this.name, required this.verified, required this.isPro, this.rating, required this.reviewsCount, required this.followersCount});

  final String slug;
  final String name;
  final bool verified;
  final bool isPro;
  final double? rating;
  final int reviewsCount;
  final int followersCount;

  factory OrganizerCard.fromJson(Map<String, dynamic> json) => OrganizerCard(
        slug: json['slug'] as String,
        name: json['name'] as String? ?? '',
        verified: json['verified'] == true,
        isPro: json['is_pro'] == true,
        rating: (json['rating'] as num?)?.toDouble(),
        reviewsCount: json['reviews_count'] as int? ?? 0,
        followersCount: json['followers_count'] as int? ?? 0,
      );
}

class Weather {
  const Weather({required this.date, required this.icon, required this.label, required this.tempMax, required this.tempMin, this.rainChance});

  final DateTime date;
  final String icon;
  final String label;
  final double tempMax;
  final double tempMin;
  final int? rainChance;

  static Weather? fromJson(Object? json) {
    if (json is! Map) return null;
    return Weather(
      date: DateTime.parse(json['date'] as String),
      icon: json['icon'] as String? ?? 'sun',
      label: json['label'] as String? ?? '',
      tempMax: (json['temp_max'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      rainChance: json['rain_chance'] as int?,
    );
  }
}

/// Fiche complète d'une sortie (GET /events/{slug}).
class EventDetail {
  const EventDetail({
    required this.card,
    this.description,
    required this.photos,
    this.videoUrl,
    required this.categories,
    required this.bookingLabel,
    required this.typeFields,
    required this.includes,
    required this.program,
    this.venueName,
    this.venueAddress,
    this.meetingPoint,
    this.commune,
    required this.organizer,
    required this.sessions,
    required this.tickets,
    required this.saleMode,
    required this.cancellationPolicy,
    required this.maxPerPerson,
    required this.setting,
    this.ageMin,
    this.weather,
    required this.isFavorite,
    required this.shareUrl,
  });

  final EventCard card;
  final String? description;
  final List<Sizes> photos;
  final String? videoUrl;
  final List<String> categories;
  final String bookingLabel;
  final Map<String, String> typeFields;
  final List<String> includes;
  final List<({String day, String title, String? text})> program;
  final String? venueName;
  final String? venueAddress;
  final String? meetingPoint;
  final String? commune;
  final OrganizerCard organizer;
  final List<EventSessionInfo> sessions;
  final List<TicketInfo> tickets;
  final String saleMode;
  final String cancellationPolicy;
  final int maxPerPerson;
  final String setting;
  final int? ageMin;
  final Weather? weather;
  final bool isFavorite;
  final String shareUrl;

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    final venue = json['venue'] as Map<String, dynamic>?;
    return EventDetail(
      card: EventCard.fromJson({...json, 'organizer': {'slug': json['organizer']['slug'], 'name': json['organizer']['name'], 'verified': json['organizer']['verified']}}),
      description: json['description'] as String?,
      photos: [
        for (final media in json['media'] as List? ?? const [])
          if (media['kind'] == 'photo' && Sizes.fromJson(media['url']) != null) Sizes.fromJson(media['url'])!,
      ],
      videoUrl: json['video_url'] as String?,
      categories: [for (final category in json['categories'] as List? ?? const []) '${category['name']}'],
      bookingLabel: (json['type'] as Map<String, dynamic>?)?['booking_label'] as String? ?? '',
      typeFields: {for (final entry in (json['type_fields'] as Map? ?? const {}).entries) '${entry.key}': '${entry.value}'},
      includes: [for (final item in json['includes'] as List? ?? const []) '$item'],
      program: [
        for (final step in json['program'] as List? ?? const []) (day: '${step['day']}', title: '${step['title']}', text: step['text'] as String?),
      ],
      venueName: venue?['name'] as String?,
      venueAddress: venue?['address'] as String?,
      meetingPoint: json['meeting_point'] as String?,
      commune: json['commune'] as String?,
      organizer: OrganizerCard.fromJson(json['organizer'] as Map<String, dynamic>),
      sessions: [for (final session in json['sessions'] as List? ?? const []) EventSessionInfo.fromJson(session as Map<String, dynamic>)],
      tickets: [for (final ticket in json['tickets'] as List? ?? const []) TicketInfo.fromJson(ticket as Map<String, dynamic>)],
      saleMode: (json['sale_mode'] as Map<String, dynamic>?)?['label'] as String? ?? '',
      cancellationPolicy: (json['cancellation_policy'] as Map<String, dynamic>?)?['label'] as String? ?? '',
      maxPerPerson: json['max_per_person'] as int? ?? 10,
      setting: (json['setting'] as Map<String, dynamic>?)?['label'] as String? ?? '',
      ageMin: json['age_min'] as int?,
      weather: Weather.fromJson(json['weather']),
      isFavorite: json['is_favorite'] == true,
      shareUrl: json['share_url'] as String? ?? '',
    );
  }
}

/// Page organisateur (GET /organizers/{slug}).
class OrganizerPage {
  const OrganizerPage({required this.card, this.description, this.cover, this.wilayaName, this.phone, this.email, required this.socials, required this.isFollowing, required this.events, required this.pastEventsCount});

  final OrganizerCard card;
  final String? description;
  final Sizes? cover;
  final String? wilayaName;
  final String? phone;
  final String? email;
  final Map<String, String> socials;
  final bool isFollowing;
  final List<EventCard> events;
  final int pastEventsCount;

  factory OrganizerPage.fromJson(Map<String, dynamic> json) => OrganizerPage(
        card: OrganizerCard.fromJson(json),
        description: json['description'] as String?,
        cover: Sizes.fromJson(json['cover']),
        wilayaName: (json['wilaya'] as Map<String, dynamic>?)?['name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        socials: {for (final entry in (json['socials'] as Map? ?? const {}).entries) '${entry.key}': '${entry.value}'},
        isFollowing: json['is_following'] == true,
        events: [for (final event in json['upcoming_events'] as List? ?? const []) EventCard.fromJson(event as Map<String, dynamic>)],
        pastEventsCount: json['past_events_count'] as int? ?? 0,
      );
}

/// Accueil (GET /home).
class HomeData {
  const HomeData({required this.featured, required this.weekend, this.nearMe, required this.hiddenGems, required this.recent, this.wilayaOfDay});

  final List<EventCard> featured;
  final List<EventCard> weekend;
  final List<EventCard>? nearMe;
  final List<EventCard> hiddenGems;
  final List<EventCard> recent;
  final ({int code, String name, String? headline, String? text, Sizes? photo, List<EventCard> events})? wilayaOfDay;

  factory HomeData.fromJson(Map<String, dynamic> json) {
    List<EventCard> cards(Object? list) => [for (final item in list as List? ?? const []) EventCard.fromJson(item as Map<String, dynamic>)];
    final today = json['wilaya_of_day'] as Map<String, dynamic>?;
    return HomeData(
      featured: cards(json['featured']),
      weekend: cards((json['this_weekend'] as Map<String, dynamic>?)?['events']),
      nearMe: json['near_me'] == null ? null : cards(json['near_me']),
      hiddenGems: cards(json['hidden_gems']),
      recent: cards(json['new']),
      wilayaOfDay: today == null
          ? null
          : (
              code: int.tryParse('${today['wilaya']['code']}') ?? 0,
              name: '${today['wilaya']['name']}',
              headline: today['headline'] as String?,
              text: today['text'] as String?,
              photo: Sizes.fromJson(today['photo']),
              events: cards(today['events']),
            ),
    );
  }
}

class MapPoint {
  const MapPoint({required this.slug, required this.title, required this.lat, required this.lng, this.priceFrom});

  final String slug;
  final String title;
  final double lat;
  final double lng;
  final int? priceFrom;

  factory MapPoint.fromJson(Map<String, dynamic> json) => MapPoint(
        slug: json['slug'] as String,
        title: json['title'] as String? ?? '',
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        priceFrom: json['price_from'] as int?,
      );
}

/// Filtres de l'onglet Explorer (mêmes paramètres que l'API).
class EventFilters {
  const EventFilters({this.q, this.wilaya, this.category, this.type, this.when, this.price, this.family = false, this.women = false, this.pmr = false, this.hiddenGem = false, this.setting, this.sort, this.lat, this.lng});

  final String? q;
  final int? wilaya;
  final String? category;
  final String? type;
  final String? when;
  final String? price;
  final bool family;
  final bool women;
  final bool pmr;
  final bool hiddenGem;
  final String? setting;
  final String? sort;
  final double? lat;
  final double? lng;

  bool get nearMe => lat != null && lng != null;

  int get activeCount => [wilaya, category, type, when, price, setting].where((v) => v != null).length + [family, women, pmr, hiddenGem].where((v) => v).length;

  Map<String, Object> toQuery() => {
        if (q != null && q!.isNotEmpty) 'q': q!,
        'wilaya': ?wilaya,
        'category': ?category,
        'type': ?type,
        'when': ?when,
        'price': ?price,
        if (family) 'family': 1,
        if (women) 'women': 1,
        if (pmr) 'pmr': 1,
        if (hiddenGem) 'hidden_gem': 1,
        'setting': ?setting,
        'sort': ?sort,
        'lat': ?lat,
        'lng': ?lng,
        if (lat != null) 'radius': 30,
      };

  EventFilters copyWith({
    Object? q = _keep,
    Object? wilaya = _keep,
    Object? category = _keep,
    Object? type = _keep,
    Object? when = _keep,
    Object? price = _keep,
    bool? family,
    bool? women,
    bool? pmr,
    bool? hiddenGem,
    Object? setting = _keep,
    Object? sort = _keep,
    Object? lat = _keep,
    Object? lng = _keep,
  }) =>
      EventFilters(
        q: q == _keep ? this.q : q as String?,
        wilaya: wilaya == _keep ? this.wilaya : wilaya as int?,
        category: category == _keep ? this.category : category as String?,
        type: type == _keep ? this.type : type as String?,
        when: when == _keep ? this.when : when as String?,
        price: price == _keep ? this.price : price as String?,
        family: family ?? this.family,
        women: women ?? this.women,
        pmr: pmr ?? this.pmr,
        hiddenGem: hiddenGem ?? this.hiddenGem,
        setting: setting == _keep ? this.setting : setting as String?,
        sort: sort == _keep ? this.sort : sort as String?,
        lat: lat == _keep ? this.lat : lat as double?,
        lng: lng == _keep ? this.lng : lng as double?,
      );

  @override
  bool operator ==(Object other) => other is EventFilters && other.toQuery().toString() == toQuery().toString();

  @override
  int get hashCode => toQuery().toString().hashCode;
}

const _keep = Object();
