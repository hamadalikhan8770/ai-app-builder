class TeamModel {
  const TeamModel({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.slug,
    this.description,
    this.avatarUrl,
    required this.planType,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String ownerUserId;
  final String name;
  final String slug;
  final String? description;
  final String? avatarUrl;
  final String planType;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    id: json['id']?.toString() ?? '',
    ownerUserId: json['owner_user_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    slug: json['slug']?.toString() ?? '',
    description: json['description']?.toString(),
    avatarUrl: json['avatar_url']?.toString(),
    planType: json['plan_type']?.toString() ?? 'free',
    createdAt: _date(json['created_at']),
    updatedAt: _date(json['updated_at']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_user_id': ownerUserId,
    'name': name,
    'slug': slug,
    'description': description,
    'avatar_url': avatarUrl,
    'plan_type': planType,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  TeamModel copyWith({
    String? id,
    String? ownerUserId,
    String? name,
    String? slug,
    String? description,
    String? avatarUrl,
    String? planType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TeamModel(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    description: description ?? this.description,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    planType: planType ?? this.planType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
