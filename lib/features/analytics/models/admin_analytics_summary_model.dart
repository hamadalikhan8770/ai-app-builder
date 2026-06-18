class AdminAnalyticsSummaryModel {
  const AdminAnalyticsSummaryModel({
    required this.totalUsers,
    required this.newUsers,
    required this.activeUsers,
    required this.freeUsers,
    required this.premiumUsers,
    required this.totalProjects,
    required this.aiGenerations,
    required this.aiGenerationFailures,
    required this.pdfExports,
    required this.subscriptionsStarted,
    required this.notificationsSent,
    required this.feedbackCount,
  });

  final int totalUsers;
  final int newUsers;
  final int activeUsers;
  final int freeUsers;
  final int premiumUsers;
  final int totalProjects;
  final int aiGenerations;
  final int aiGenerationFailures;
  final int pdfExports;
  final int subscriptionsStarted;
  final int notificationsSent;
  final int feedbackCount;

  factory AdminAnalyticsSummaryModel.empty() =>
      const AdminAnalyticsSummaryModel(
        totalUsers: 0,
        newUsers: 0,
        activeUsers: 0,
        freeUsers: 0,
        premiumUsers: 0,
        totalProjects: 0,
        aiGenerations: 0,
        aiGenerationFailures: 0,
        pdfExports: 0,
        subscriptionsStarted: 0,
        notificationsSent: 0,
        feedbackCount: 0,
      );

  factory AdminAnalyticsSummaryModel.fromJson(Map<String, dynamic> json) =>
      AdminAnalyticsSummaryModel(
        totalUsers: _int(json['total_users']),
        newUsers: _int(json['new_users']),
        activeUsers: _int(json['active_users']),
        freeUsers: _int(json['free_users']),
        premiumUsers: _int(json['premium_users']),
        totalProjects: _int(json['total_projects']),
        aiGenerations: _int(
          json['total_generations'] ?? json['ai_generations'],
        ),
        aiGenerationFailures: _int(
          json['failed_generations'] ?? json['ai_generation_failures'],
        ),
        pdfExports: _int(json['total_exports'] ?? json['pdf_exports']),
        subscriptionsStarted: _int(json['subscriptions_started']),
        notificationsSent: _int(json['notifications_sent']),
        feedbackCount: _int(json['feedback_count']),
      );

  Map<String, dynamic> toJson() => {
    'total_users': totalUsers,
    'new_users': newUsers,
    'active_users': activeUsers,
    'free_users': freeUsers,
    'premium_users': premiumUsers,
    'total_projects': totalProjects,
    'ai_generations': aiGenerations,
    'ai_generation_failures': aiGenerationFailures,
    'pdf_exports': pdfExports,
    'subscriptions_started': subscriptionsStarted,
    'notifications_sent': notificationsSent,
    'feedback_count': feedbackCount,
  };

  AdminAnalyticsSummaryModel copyWith({
    int? totalUsers,
    int? newUsers,
    int? activeUsers,
    int? freeUsers,
    int? premiumUsers,
    int? totalProjects,
    int? aiGenerations,
    int? aiGenerationFailures,
    int? pdfExports,
    int? subscriptionsStarted,
    int? notificationsSent,
    int? feedbackCount,
  }) => AdminAnalyticsSummaryModel(
    totalUsers: totalUsers ?? this.totalUsers,
    newUsers: newUsers ?? this.newUsers,
    activeUsers: activeUsers ?? this.activeUsers,
    freeUsers: freeUsers ?? this.freeUsers,
    premiumUsers: premiumUsers ?? this.premiumUsers,
    totalProjects: totalProjects ?? this.totalProjects,
    aiGenerations: aiGenerations ?? this.aiGenerations,
    aiGenerationFailures: aiGenerationFailures ?? this.aiGenerationFailures,
    pdfExports: pdfExports ?? this.pdfExports,
    subscriptionsStarted: subscriptionsStarted ?? this.subscriptionsStarted,
    notificationsSent: notificationsSent ?? this.notificationsSent,
    feedbackCount: feedbackCount ?? this.feedbackCount,
  );

  static int _int(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}
