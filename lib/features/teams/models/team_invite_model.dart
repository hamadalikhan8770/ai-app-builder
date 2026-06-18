class TeamInviteModel {
  const TeamInviteModel({
    required this.id,
    required this.teamId,
    required this.email,
    required this.role,
    required this.token,
    this.invitedBy,
    required this.status,
    required this.expiresAt,
    this.acceptedAt,
    this.declinedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String teamId;
  final String email;
  final String role;
  final String token;
  final String? invitedBy;
  final String status;
  final DateTime expiresAt;
  final DateTime? acceptedAt;
  final DateTime? declinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory TeamInviteModel.fromJson(Map<String, dynamic> json) =>
      TeamInviteModel(
        id: json['id']?.toString() ?? '',
        teamId: json['team_id']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: json['role']?.toString() ?? 'viewer',
        token: json['token']?.toString() ?? '',
        invitedBy: json['invited_by']?.toString(),
        status: json['status']?.toString() ?? 'pending',
        expiresAt: _date(json['expires_at']),
        acceptedAt: _dateOrNull(json['accepted_at']),
        declinedAt: _dateOrNull(json['declined_at']),
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'team_id': teamId,
    'email': email,
    'role': role,
    'token': token,
    'invited_by': invitedBy,
    'status': status,
    'expires_at': expiresAt.toIso8601String(),
    'accepted_at': acceptedAt?.toIso8601String(),
    'declined_at': declinedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  TeamInviteModel copyWith({
    String? id,
    String? teamId,
    String? email,
    String? role,
    String? token,
    String? invitedBy,
    String? status,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? declinedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TeamInviteModel(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    email: email ?? this.email,
    role: role ?? this.role,
    token: token ?? this.token,
    invitedBy: invitedBy ?? this.invitedBy,
    status: status ?? this.status,
    expiresAt: expiresAt ?? this.expiresAt,
    acceptedAt: acceptedAt ?? this.acceptedAt,
    declinedAt: declinedAt ?? this.declinedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
DateTime? _dateOrNull(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
