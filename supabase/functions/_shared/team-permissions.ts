export async function canViewProject(admin: any, projectId: string, userId: string): Promise<boolean> {
  const { data, error } = await admin.rpc('can_view_team_project', { p_project_id: projectId, p_user_id: userId });
  if (error) throw error;
  return data === true;
}

export async function canEditProject(admin: any, projectId: string, userId: string): Promise<boolean> {
  const { data, error } = await admin.rpc('can_edit_team_project', { p_project_id: projectId, p_user_id: userId });
  if (error) throw error;
  return data === true;
}

export async function assertCanGenerateForProject(admin: any, projectId: string, userId: string): Promise<void> {
  const allowed = await canEditProject(admin, projectId, userId);
  if (!allowed) {
    throw new Error('You need owner, admin, or editor access to generate AI outputs for this project.');
  }
}

export async function assertCanExportProject(admin: any, projectId: string, userId: string): Promise<void> {
  const allowed = await canViewProject(admin, projectId, userId);
  if (!allowed) {
    throw new Error('You do not have access to export this project.');
  }
}

export async function logTeamProjectAction(admin: any, projectId: string, actorUserId: string, action: string, metadata: Record<string, unknown> = {}) {
  const { data: project } = await admin.from('app_projects').select('team_id').eq('id', projectId).maybeSingle();
  if (project?.team_id) {
    await admin.from('team_activity_logs').insert({
      team_id: project.team_id,
      actor_user_id: actorUserId,
      action,
      entity_type: 'project',
      entity_id: projectId,
      metadata,
    });
  }
}
