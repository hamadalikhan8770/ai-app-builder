class UserUsageSummaryModel {
  const UserUsageSummaryModel({
    required this.id,
    required this.userId,
    required this.monthKey,
    required this.projectsCreated,
    required this.aiGenerations,
    required this.aiGenerationFailures,
    required this.templateOutputs,
    required this.pdfExports,
    required this.notificationsReceived,
    this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String monthKey;
  final int projectsCreated;
  final int aiGenerations;
  final int aiGenerationFailures;
  final int templateOutputs;
  final int pdfExports;
  final int notificationsReceived;
  final DateTime? lastActiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserUsageSummaryModel.empty(String userId) {
    final now = DateTime.now();
    return UserUsageSummaryModel(
      id: '',
      userId: userId,
      monthKey: now.toIso8601String().substring(0, 7),
      projectsCreated: 0,
      aiGenerations: 0,
      aiGenerationFailures: 0,
      templateOutputs: 0,
      pdfExports: 0,
      notificationsReceived: 0,
      lastActiveAt: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserUsageSummaryModel.fromJson(Map<String, dynamic> json) =>
      UserUsageSummaryModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        monthKey: json['month_key']?.toString() ?? '',
        projectsCreated: _int(json['projects_created']),
        aiGenerations: _int(json['ai_generations']),
        aiGenerationFailures: _int(json['ai_generation_failures']),
        templateOutputs: _int(json['template_outputs']),
        pdfExports: _int(json['pdf_exports']),
        notificationsReceived: _int(json['notifications_received']),
        lastActiveAt: _dateOrNull(json['last_active_at']),
        createdAt: _date(json['created_at']),
        updatedAt: _date(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'month_key': monthKey,
    'projects_created': projectsCreated,
    'ai_generations': aiGenerations,
    'ai_generation_failures': aiGenerationFailures,
    'template_outputs': templateOutputs,
    'pdf_exports': pdfExports,
    'notifications_received': notificationsReceived,
    'last_active_at': lastActiveAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  UserUsageSummaryModel copyWith({
    String? id,
    String? userId,
    String? monthKey,
    int? projectsCreated,
    int? aiGenerations,
    int? aiGenerationFailures,
    int? templateOutputs,
    int? pdfExports,
    int? notificationsReceived,
    DateTime? lastActiveAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserUsageSummaryModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    monthKey: monthKey ?? this.monthKey,
    projectsCreated: projectsCreated ?? this.projectsCreated,
    aiGenerations: aiGenerations ?? this.aiGenerations,
    aiGenerationFailures: aiGenerationFailures ?? this.aiGenerationFailures,
    templateOutputs: templateOutputs ?? this.templateOutputs,
    pdfExports: pdfExports ?? this.pdfExports,
    notificationsReceived: notificationsReceived ?? this.notificationsReceived,
    lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  static int _int(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
  static DateTime _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  static DateTime? _dateOrNull(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
