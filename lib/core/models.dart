/// Compte connecté (GET /api/v1/me).
class DowraUser {
  const DowraUser({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    required this.locale,
    required this.themeMode,
    this.wilayaId,
    this.wilayaName,
    required this.interests,
    required this.level,
    required this.levelLabel,
    required this.points,
    required this.isAmbassador,
    required this.roles,
    required this.onboarded,
  });

  final int id;
  final String phone;
  final String? name;
  final String? email;
  final String locale;
  final String themeMode;
  final int? wilayaId;
  final String? wilayaName;
  final List<String> interests;
  final String level;
  final String levelLabel;
  final int points;
  final bool isAmbassador;
  final List<String> roles;
  final bool onboarded;

  factory DowraUser.fromJson(Map<String, dynamic> json) => DowraUser(
        id: json['id'] as int,
        phone: json['phone'] as String? ?? '',
        name: json['name'] as String?,
        email: json['email'] as String?,
        locale: json['locale'] as String? ?? 'fr',
        themeMode: json['theme_mode'] as String? ?? 'systeme',
        wilayaId: json['wilaya_id'] as int?,
        wilayaName: (json['wilaya'] as Map<String, dynamic>?)?['name'] as String?,
        interests: [for (final slug in json['interests'] as List? ?? const []) slug.toString()],
        level: json['level'] as String? ?? 'explorateur',
        levelLabel: json['level_label'] as String? ?? '',
        points: json['points'] as int? ?? 0,
        isAmbassador: json['is_ambassador'] as bool? ?? false,
        roles: [for (final role in json['roles'] as List? ?? const []) role.toString()],
        onboarded: json['onboarded'] as bool? ?? false,
      );

  /// Initiales affichées dans la pastille du compte.
  String get initials {
    final parts = (name ?? 'D').trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p.substring(0, 1).toUpperCase()).join();
  }

  String get firstName => (name ?? '').trim().split(RegExp(r'\s+')).first;
}

class Wilaya {
  const Wilaya({required this.id, required this.code, required this.name, required this.isActive});

  final int id;
  final int code;
  final String name;
  final bool isActive;

  factory Wilaya.fromJson(Map<String, dynamic> json) =>
      Wilaya(id: json['id'] as int, code: json['code'] as int, name: json['name'] as String, isActive: json['is_active'] as bool? ?? false);

  String get label => '${code.toString().padLeft(2, '0')} · $name';
}

class Category {
  const Category({required this.slug, required this.name, this.icon, this.color});

  final String slug;
  final String name;
  final String? icon;
  final String? color;

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(slug: json['slug'] as String, name: json['name'] as String, icon: json['icon'] as String?, color: json['color'] as String?);
}

class OutingType {
  const OutingType({required this.slug, required this.name, required this.bookingLabel, this.icon});

  final String slug;
  final String name;
  final String bookingLabel;
  final String? icon;

  factory OutingType.fromJson(Map<String, dynamic> json) => OutingType(
        slug: json['slug'] as String,
        name: json['name'] as String,
        bookingLabel: json['booking_label'] as String? ?? '',
        icon: json['icon'] as String?,
      );
}
