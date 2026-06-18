import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/projects/models/app_project_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectRepository {
  const ProjectRepository(this._client);
  final SupabaseClient _client;

  Future<List<AppProjectModel>> getMyProjects() async {
    try {
      final response = await _client
          .from('app_projects')
          .select()
          .order('updated_at', ascending: false);
      return response
          .map<AppProjectModel>((item) => AppProjectModel.fromJson(item))
          .toList();
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    }
  }

  Future<AppProjectModel> createProject({
    required String name,
    String? description,
    String? teamId,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AppException('You must be logged in.');
    final response = await _client
        .from('app_projects')
        .insert({
          'name': name,
          'description': description,
          'owner_user_id': userId,
          'created_by_user_id': userId,
          'team_id': teamId,
          'visibility': teamId == null ? 'private' : 'team',
        })
        .select()
        .single();
    return AppProjectModel.fromJson(response);
  }
}
