class ProjectShareModel {
  const ProjectShareModel({
    required this.id,
    required this.projectId,
    required this.teamId,
    required this.sharedBy,
    required this.permission,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String projectId;
  final String teamId;
  final String sharedBy;
  final String permission;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory ProjectShareModel.fromJson(Map<String, dynamic> json) =>
      ProjectShareModel(
        id: json['id']?.toString() ?? '',
        projectId: json['project_id']?.toString() ?? '',
        teamId: json['team_id']?.toString() ?? '',
        sharedBy: json['shared_by']?.toString() ?? '',
        permission: json['permission']?.toString() ?? 'view',
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': projectId,
    'team_id': teamId,
    'shared_by': sharedBy,
    'permission': permission,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  ProjectShareModel copyWith({
    String? id,
    String? projectId,
    String? teamId,
    String? sharedBy,
    String? permission,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectShareModel(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    teamId: teamId ?? this.teamId,
    sharedBy: sharedBy ?? this.sharedBy,
    permission: permission ?? this.permission,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
