class MarketplaceReviewModel {
  const MarketplaceReviewModel({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.rating,
    this.reviewText,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String userId;
  final String templateId;
  final int rating;
  final String? reviewText;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory MarketplaceReviewModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceReviewModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        templateId: json['template_id']?.toString() ?? '',
        rating: json['rating'] is num
            ? (json['rating'] as num).toInt()
            : int.tryParse(json['rating']?.toString() ?? '') ?? 5,
        reviewText: json['review_text']?.toString(),
        status: json['status']?.toString() ?? 'pending',
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'template_id': templateId,
    'rating': rating,
    'review_text': reviewText,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  MarketplaceReviewModel copyWith({
    String? id,
    String? userId,
    String? templateId,
    int? rating,
    String? reviewText,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MarketplaceReviewModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    templateId: templateId ?? this.templateId,
    rating: rating ?? this.rating,
    reviewText: reviewText ?? this.reviewText,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
