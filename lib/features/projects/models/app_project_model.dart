class AppProjectModel {
  const AppProjectModel({
    required this.id,
    required this.name,
    this.description,
    this.ownerUserId,
    this.createdByUserId,
    this.teamId,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String name;
  final String? description;
  final String? ownerUserId;
  final String? createdByUserId;
  final String? teamId;
  final String visibility;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory AppProjectModel.fromJson(Map<String, dynamic> json) =>
      AppProjectModel(
        id: json['id']?.toString() ?? '',
        name:
            json['name']?.toString() ??
            json['title']?.toString() ??
            'Untitled Project',
        description: json['description']?.toString(),
        ownerUserId:
            json['owner_user_id']?.toString() ?? json['user_id']?.toString(),
        createdByUserId: json['created_by_user_id']?.toString(),
        teamId: json['team_id']?.toString(),
        visibility: json['visibility']?.toString() ?? 'private',
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'owner_user_id': ownerUserId,
    'created_by_user_id': createdByUserId,
    'team_id': teamId,
    'visibility': visibility,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  AppProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerUserId,
    String? createdByUserId,
    String? teamId,
    String? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppProjectModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    teamId: teamId ?? this.teamId,
    visibility: visibility ?? this.visibility,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
