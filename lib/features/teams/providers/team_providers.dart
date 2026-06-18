import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';
import 'package:my_first_app/features/projects/models/app_project_model.dart';
import 'package:my_first_app/features/teams/data/team_repository.dart';
import 'package:my_first_app/features/teams/models/team_activity_log_model.dart';
import 'package:my_first_app/features/teams/models/team_invite_model.dart';
import 'package:my_first_app/features/teams/models/team_member_model.dart';
import 'package:my_first_app/features/teams/models/team_model.dart';

final teamRepositoryProvider = Provider<TeamRepository>(
  (ref) => TeamRepository(ref.watch(supabaseClientProvider)),
);
final myTeamsProvider = FutureProvider<List<TeamModel>>(
  (ref) => ref.watch(teamRepositoryProvider).getMyTeams(),
);
final teamByIdProvider = FutureProvider.family<TeamModel?, String>(
  (ref, teamId) => ref.watch(teamRepositoryProvider).getTeamById(teamId),
);
final teamMembersProvider =
    FutureProvider.family<List<TeamMemberModel>, String>(
      (ref, teamId) => ref.watch(teamRepositoryProvider).getTeamMembers(teamId),
    );
final teamInvitesProvider =
    FutureProvider.family<List<TeamInviteModel>, String>(
      (ref, teamId) => ref.watch(teamRepositoryProvider).getTeamInvites(teamId),
    );
final pendingTeamInvitesProvider = FutureProvider<List<TeamInviteModel>>(
  (ref) => ref.watch(teamRepositoryProvider).getPendingInvitesForMe(),
);
final teamActivityProvider =
    FutureProvider.family<List<TeamActivityLogModel>, String>(
      (ref, teamId) =>
          ref.watch(teamRepositoryProvider).getTeamActivity(teamId),
    );
final sharedProjectsProvider =
    FutureProvider.family<List<AppProjectModel>, String>(
      (ref, teamId) =>
          ref.watch(teamRepositoryProvider).getSharedProjects(teamId),
    );
final selectedTeamProvider = StateProvider<TeamModel?>((ref) => null);
final teamActionControllerProvider =
    StateNotifierProvider<TeamActionController, AsyncValue<void>>(
      (ref) => TeamActionController(ref),
    );

class TeamActionController extends StateNotifier<AsyncValue<void>> {
  TeamActionController(this.ref) : super(const AsyncData(null));
  final Ref ref;
  TeamRepository get _repo => ref.read(teamRepositoryProvider);

  Future<void> createTeam(String name, String? description) async =>
      _run(() async {
        await _repo.createTeam(name, description);
        ref.invalidate(myTeamsProvider);
      });
  Future<void> inviteMember(String teamId, String email, String role) async =>
      _run(() async {
        await _repo.inviteMember(teamId, email, role);
        ref.invalidate(teamInvitesProvider(teamId));
        ref.invalidate(teamActivityProvider(teamId));
      });
  Future<void> acceptInvite(String token) async => _run(() async {
    await _repo.acceptInvite(token);
    ref.invalidate(myTeamsProvider);
    ref.invalidate(pendingTeamInvitesProvider);
  });
  Future<void> declineInvite(String token) async => _run(() async {
    await _repo.declineInvite(token);
    ref.invalidate(pendingTeamInvitesProvider);
  });
  Future<void> updateMemberRole(
    String teamId,
    String memberUserId,
    String role,
  ) async => _run(() async {
    await _repo.updateMemberRole(teamId, memberUserId, role);
    ref.invalidate(teamMembersProvider(teamId));
  });
  Future<void> removeMember(String teamId, String memberUserId) async =>
      _run(() async {
        await _repo.removeMember(teamId, memberUserId);
        ref.invalidate(teamMembersProvider(teamId));
      });
  Future<void> shareProject(
    String projectId,
    String teamId,
    String permission,
  ) async => _run(() async {
    await _repo.shareProjectWithTeam(projectId, teamId, permission);
    ref.invalidate(sharedProjectsProvider(teamId));
  });
  Future<void> unshareProject(String projectId, String teamId) async =>
      _run(() async {
        await _repo.unshareProjectFromTeam(projectId, teamId);
        ref.invalidate(sharedProjectsProvider(teamId));
      });

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
