class MarketplaceTemplateModel {
  const MarketplaceTemplateModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    required this.templateType,
    required this.targetPlatform,
    required this.recommendedStack,
    required this.difficulty,
    required this.accessType,
    this.coverImageUrl,
    required this.previewImages,
    required this.tags,
    required this.features,
    required this.includedOutputs,
    required this.templatePayload,
    this.createdBy,
    required this.status,
    required this.isFeatured,
    required this.usageCount,
    required this.favoriteCount,
    required this.ratingAverage,
    required this.ratingCount,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String title;
  final String slug;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final String templateType;
  final String targetPlatform;
  final String recommendedStack;
  final String difficulty;
  final String accessType;
  final String? coverImageUrl;
  final List<String> previewImages;
  final List<String> tags;
  final List<String> features;
  final List<String> includedOutputs;
  final Map<String, dynamic> templatePayload;
  final String? createdBy;
  final String status;
  final bool isFeatured;
  final int usageCount;
  final int favoriteCount;
  final double ratingAverage;
  final int ratingCount;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool get isPremium => accessType == 'premium';
  bool get isAdminOnly => accessType == 'admin_only';
  bool get isFree => accessType == 'free';
  factory MarketplaceTemplateModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceTemplateModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        shortDescription: json['short_description']?.toString() ?? '',
        fullDescription: json['full_description']?.toString() ?? '',
        category: json['category']?.toString() ?? 'other',
        templateType: json['template_type']?.toString() ?? 'app_starter',
        targetPlatform: json['target_platform']?.toString() ?? 'ios_android',
        recommendedStack:
            json['recommended_stack']?.toString() ?? 'Flutter + Supabase',
        difficulty: json['difficulty']?.toString() ?? 'beginner',
        accessType: json['access_type']?.toString() ?? 'free',
        coverImageUrl: json['cover_image_url']?.toString(),
        previewImages: _stringList(json['preview_images']),
        tags: _stringList(json['tags']),
        features: _stringList(json['features']),
        includedOutputs: _stringList(json['included_outputs']),
        templatePayload: _map(json['template_payload']),
        createdBy: json['created_by']?.toString(),
        status: json['status']?.toString() ?? 'draft',
        isFeatured: json['is_featured'] == true,
        usageCount: _int(json['usage_count']),
        favoriteCount: _int(json['favorite_count']),
        ratingAverage: _double(json['rating_average']),
        ratingCount: _int(json['rating_count']),
        publishedAt: _dateOrNull(json['published_at']),
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'short_description': shortDescription,
    'full_description': fullDescription,
    'category': category,
    'template_type': templateType,
    'target_platform': targetPlatform,
    'recommended_stack': recommendedStack,
    'difficulty': difficulty,
    'access_type': accessType,
    'cover_image_url': coverImageUrl,
    'preview_images': previewImages,
    'tags': tags,
    'features': features,
    'included_outputs': includedOutputs,
    'template_payload': templatePayload,
    'created_by': createdBy,
    'status': status,
    'is_featured': isFeatured,
    'usage_count': usageCount,
    'favorite_count': favoriteCount,
    'rating_average': ratingAverage,
    'rating_count': ratingCount,
    'published_at': publishedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  MarketplaceTemplateModel copyWith({
    String? id,
    String? title,
    String? slug,
    String? shortDescription,
    String? fullDescription,
    String? category,
    String? templateType,
    String? targetPlatform,
    String? recommendedStack,
    String? difficulty,
    String? accessType,
    String? coverImageUrl,
    List<String>? previewImages,
    List<String>? tags,
    List<String>? features,
    List<String>? includedOutputs,
    Map<String, dynamic>? templatePayload,
    String? createdBy,
    String? status,
    bool? isFeatured,
    int? usageCount,
    int? favoriteCount,
    double? ratingAverage,
    int? ratingCount,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MarketplaceTemplateModel(
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    shortDescription: shortDescription ?? this.shortDescription,
    fullDescription: fullDescription ?? this.fullDescription,
    category: category ?? this.category,
    templateType: templateType ?? this.templateType,
    targetPlatform: targetPlatform ?? this.targetPlatform,
    recommendedStack: recommendedStack ?? this.recommendedStack,
    difficulty: difficulty ?? this.difficulty,
    accessType: accessType ?? this.accessType,
    coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    previewImages: previewImages ?? this.previewImages,
    tags: tags ?? this.tags,
    features: features ?? this.features,
    includedOutputs: includedOutputs ?? this.includedOutputs,
    templatePayload: templatePayload ?? this.templatePayload,
    createdBy: createdBy ?? this.createdBy,
    status: status ?? this.status,
    isFeatured: isFeatured ?? this.isFeatured,
    usageCount: usageCount ?? this.usageCount,
    favoriteCount: favoriteCount ?? this.favoriteCount,
    ratingAverage: ratingAverage ?? this.ratingAverage,
    ratingCount: ratingCount ?? this.ratingCount,
    publishedAt: publishedAt ?? this.publishedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
DateTime? _dateOrNull(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
List<String> _stringList(dynamic value) =>
    value is List ? value.map((e) => e.toString()).toList() : <String>[];
Map<String, dynamic> _map(dynamic value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};
int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
double _double(dynamic value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;
