class GeneratedOutputModel {
  const GeneratedOutputModel({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.title,
    required this.outputType,
    required this.content,
    required this.createdAt,
    this.projectTitle,
    this.aiProvider,
    this.modelName,
  });

  final String id;
  final String? projectId;
  final String? userId;
  final String title;
  final String outputType;
  final String content;
  final DateTime createdAt;
  final String? projectTitle;
  final String? aiProvider;
  final String? modelName;

  factory GeneratedOutputModel.fromJson(Map<String, dynamic> json) {
    final project = json['app_projects'] is Map<String, dynamic>
        ? json['app_projects'] as Map<String, dynamic>
        : json['projects'] is Map<String, dynamic>
        ? json['projects'] as Map<String, dynamic>
        : null;

    final title = json['title']?.toString();
    final projectTitle =
        project?['title']?.toString() ?? project?['name']?.toString();

    return GeneratedOutputModel(
      id: json['id']?.toString() ?? '',
      projectId: json['project_id']?.toString(),
      userId: json['user_id']?.toString(),
      title: (title == null || title.trim().isEmpty)
          ? '${projectTitle ?? 'Generated Output'} - ${json['output_type']?.toString() ?? 'output'}'
          : title,
      outputType: json['output_type']?.toString() ?? 'output',
      content: json['content']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']),
      projectTitle: projectTitle,
      aiProvider: json['ai_provider']?.toString(),
      modelName: json['model_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'project_id': projectId,
    'user_id': userId,
    'title': title,
    'output_type': outputType,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    'project_title': projectTitle,
    'ai_provider': aiProvider,
    'model_name': modelName,
  };

  GeneratedOutputModel copyWith({
    String? id,
    String? projectId,
    String? userId,
    String? title,
    String? outputType,
    String? content,
    DateTime? createdAt,
    String? projectTitle,
    String? aiProvider,
    String? modelName,
  }) {
    return GeneratedOutputModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      outputType: outputType ?? this.outputType,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      projectTitle: projectTitle ?? this.projectTitle,
      aiProvider: aiProvider ?? this.aiProvider,
      modelName: modelName ?? this.modelName,
    );
  }
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) return value;
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}
