import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/projects/models/app_project_model.dart';
import 'package:my_first_app/features/teams/models/project_share_model.dart';
import 'package:my_first_app/features/teams/models/team_activity_log_model.dart';
import 'package:my_first_app/features/teams/models/team_invite_model.dart';
import 'package:my_first_app/features/teams/models/team_member_model.dart';
import 'package:my_first_app/features/teams/models/team_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamRepository {
  const TeamRepository(this._client);
  final SupabaseClient _client;

  Future<List<TeamModel>> getMyTeams() async {
    try {
      final response = await _client
          .from('teams')
          .select()
          .order('created_at', ascending: false);
      return response
          .map<TeamModel>((item) => TeamModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<TeamModel?> getTeamById(String teamId) async {
    try {
      final response = await _client
          .from('teams')
          .select()
          .eq('id', teamId)
          .maybeSingle();
      return response == null ? null : TeamModel.fromJson(response);
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    }
  }

  Future<List<TeamMemberModel>> getTeamMembers(String teamId) async {
    try {
      final response = await _client
          .from('team_members')
          .select()
          .eq('team_id', teamId)
          .neq('status', 'removed')
          .order('created_at');
      return response
          .map<TeamMemberModel>((item) => TeamMemberModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeamInviteModel>> getTeamInvites(String teamId) async {
    try {
      final response = await _client
          .from('team_invites')
          .select()
          .eq('team_id', teamId)
          .order('created_at', ascending: false);
      return response
          .map<TeamInviteModel>((item) => TeamInviteModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeamInviteModel>> getPendingInvitesForMe() async {
    final email = _client.auth.currentUser?.email;
    if (email == null) return [];
    try {
      final response = await _client
          .from('team_invites')
          .select()
          .eq('email', email.toLowerCase())
          .eq('status', 'pending')
          .order('created_at', ascending: false);
      return response
          .map<TeamInviteModel>((item) => TeamInviteModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeamActivityLogModel>> getTeamActivity(String teamId) async {
    try {
      final response = await _client
          .from('team_activity_logs')
          .select()
          .eq('team_id', teamId)
          .order('created_at', ascending: false)
          .limit(50);
      return response
          .map<TeamActivityLogModel>(
            (item) => TeamActivityLogModel.fromJson(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<TeamModel> createTeam(String name, String? description) async {
    final response = await _invokeMap('create-team', {
      'name': name,
      'description': description,
    });
    return TeamModel.fromJson(
      Map<String, dynamic>.from(response['team'] as Map),
    );
  }

  Future<TeamInviteModel> inviteMember(
    String teamId,
    String email,
    String role,
  ) async {
    final response = await _invokeMap('invite-team-member', {
      'teamId': teamId,
      'email': email,
      'role': role,
    });
    return TeamInviteModel.fromJson(
      Map<String, dynamic>.from(response['invite'] as Map),
    );
  }

  Future<TeamModel> acceptInvite(String token) async {
    final response = await _invokeMap('accept-team-invite', {'token': token});
    return TeamModel.fromJson(
      Map<String, dynamic>.from(response['team'] as Map),
    );
  }

  Future<void> declineInvite(String token) async =>
      _invokeVoid('decline-team-invite', {'token': token});
  Future<void> updateMemberRole(
    String teamId,
    String memberUserId,
    String newRole,
  ) async => _invokeVoid('update-team-member-role', {
    'teamId': teamId,
    'memberUserId': memberUserId,
    'newRole': newRole,
  });
  Future<void> removeMember(String teamId, String memberUserId) async =>
      _invokeVoid('remove-team-member', {
        'teamId': teamId,
        'memberUserId': memberUserId,
      });

  Future<void> leaveTeam(String teamId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AppException('You must be logged in.');
    await removeMember(teamId, userId);
  }

  Future<ProjectShareModel> shareProjectWithTeam(
    String projectId,
    String teamId,
    String permission,
  ) async {
    final response = await _invokeMap('share-project-with-team', {
      'projectId': projectId,
      'teamId': teamId,
      'permission': permission,
    });
    return ProjectShareModel.fromJson(
      Map<String, dynamic>.from(response['share'] as Map),
    );
  }

  Future<void> unshareProjectFromTeam(String projectId, String teamId) async =>
      _invokeVoid('unshare-project-from-team', {
        'projectId': projectId,
        'teamId': teamId,
      });

  Future<List<ProjectShareModel>> getProjectShares(String projectId) async {
    try {
      final response = await _client
          .from('project_shares')
          .select()
          .eq('project_id', projectId)
          .order('created_at', ascending: false);
      return response
          .map<ProjectShareModel>((item) => ProjectShareModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<AppProjectModel>> getSharedProjects(String teamId) async {
    try {
      final response = await _client
          .from('app_projects')
          .select()
          .eq('team_id', teamId)
          .order('updated_at', ascending: false);
      return response
          .map<AppProjectModel>((item) => AppProjectModel.fromJson(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _invokeMap(
    String functionName,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client.functions.invoke(functionName, body: body);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['error'] != null) throw AppException(data['error'].toString());
        return data;
      }
      throw const AppException('Invalid server response.');
    } on FunctionException catch (error) {
      throw AppException(
        error.details?.toString() ??
            error.reasonPhrase ??
            'Server function failed.',
      );
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    }
  }

  Future<void> _invokeVoid(
    String functionName,
    Map<String, dynamic> body,
  ) async {
    await _invokeMap(functionName, body);
  }
}
