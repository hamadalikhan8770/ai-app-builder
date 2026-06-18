class MarketplaceFavoriteModel {
  const MarketplaceFavoriteModel({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.createdAt,
  });
  final String id;
  final String userId;
  final String templateId;
  final DateTime createdAt;
  factory MarketplaceFavoriteModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceFavoriteModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        templateId: json['template_id']?.toString() ?? '',
        createdAt: _date(json['created_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'template_id': templateId,
    'created_at': createdAt.toIso8601String(),
  };
  MarketplaceFavoriteModel copyWith({
    String? id,
    String? userId,
    String? templateId,
    String? projectId,
    String? actionType,
    DateTime? createdAt,
  }) => MarketplaceFavoriteModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    templateId: templateId ?? this.templateId,
    createdAt: createdAt ?? this.createdAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
