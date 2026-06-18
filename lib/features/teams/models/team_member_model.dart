class TeamMemberModel {
  const TeamMemberModel({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.role,
    required this.status,
    this.invitedBy,
    this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.fullName,
  });
  final String id;
  final String teamId;
  final String userId;
  final String role;
  final String status;
  final String? invitedBy;
  final DateTime? joinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? email;
  final String? fullName;
  bool get canManage => role == 'owner' || role == 'admin';
  bool get canEdit => role == 'owner' || role == 'admin' || role == 'editor';
  bool get isOwner => role == 'owner';
  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] is Map<String, dynamic>
        ? json['profiles'] as Map<String, dynamic>
        : <String, dynamic>{};
    return TeamMemberModel(
      id: json['id']?.toString() ?? '',
      teamId: json['team_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'viewer',
      status: json['status']?.toString() ?? 'active',
      invitedBy: json['invited_by']?.toString(),
      joinedAt: _dateOrNull(json['joined_at']),
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
      email: json['email']?.toString() ?? profile['email']?.toString(),
      fullName:
          json['full_name']?.toString() ?? profile['full_name']?.toString(),
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'team_id': teamId,
    'user_id': userId,
    'role': role,
    'status': status,
    'invited_by': invitedBy,
    'joined_at': joinedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  TeamMemberModel copyWith({
    String? id,
    String? teamId,
    String? userId,
    String? role,
    String? status,
    String? invitedBy,
    DateTime? joinedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? fullName,
  }) => TeamMemberModel(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    status: status ?? this.status,
    invitedBy: invitedBy ?? this.invitedBy,
    joinedAt: joinedAt ?? this.joinedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
DateTime? _dateOrNull(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
