import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/features/ai_generation/screens/generated_output_detail_screen.dart';
import 'package:my_first_app/features/analytics/screens/my_usage_screen.dart';
import 'package:my_first_app/features/admin/screens/admin_insights_screen.dart';
import 'package:my_first_app/features/export/screens/pdf_preview_screen.dart';

import 'package:my_first_app/features/marketplace/admin/screens/admin_create_marketplace_template_screen.dart';
import 'package:my_first_app/features/marketplace/admin/screens/admin_edit_marketplace_template_screen.dart';
import 'package:my_first_app/features/marketplace/admin/screens/admin_marketplace_list_screen.dart';
import 'package:my_first_app/features/marketplace/admin/screens/admin_marketplace_reviews_screen.dart';
import 'package:my_first_app/features/marketplace/screens/marketplace_favorites_screen.dart';
import 'package:my_first_app/features/marketplace/screens/marketplace_home_screen.dart';
import 'package:my_first_app/features/marketplace/screens/marketplace_review_screen.dart';
import 'package:my_first_app/features/marketplace/screens/marketplace_search_screen.dart';
import 'package:my_first_app/features/marketplace/screens/marketplace_template_detail_screen.dart';
import 'package:my_first_app/features/projects/screens/create_project_screen.dart';
import 'package:my_first_app/features/projects/screens/project_detail_screen.dart';
import 'package:my_first_app/features/teams/screens/create_team_screen.dart';
import 'package:my_first_app/features/teams/screens/invite_member_screen.dart';
import 'package:my_first_app/features/teams/screens/pending_invites_screen.dart';
import 'package:my_first_app/features/teams/screens/share_project_screen.dart';
import 'package:my_first_app/features/teams/screens/team_detail_screen.dart';
import 'package:my_first_app/features/teams/screens/team_members_screen.dart';
import 'package:my_first_app/features/teams/screens/team_settings_screen.dart';
import 'package:my_first_app/features/teams/screens/teams_list_screen.dart';
import 'package:my_first_app/routing/route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.dashboard,
        builder: (context, state) => const AnalyticsDemoDashboard(),
      ),
      GoRoute(
        path: '/my-usage',
        name: RouteNames.myUsage,
        builder: (context, state) => const MyUsageScreen(),
      ),
      GoRoute(
        path: '/admin/insights',
        name: RouteNames.adminInsights,
        builder: (context, state) => const AdminInsightsScreen(),
      ),
      GoRoute(
        path: '/upgrade',
        name: RouteNames.upgrade,
        builder: (context, state) => const UpgradePlaceholderScreen(),
      ),
      GoRoute(
        path: '/teams',
        name: RouteNames.teams,
        builder: (context, state) => const TeamsListScreen(),
      ),
      GoRoute(
        path: '/teams/create',
        name: RouteNames.createTeam,
        builder: (context, state) => const CreateTeamScreen(),
      ),
      GoRoute(
        path: '/teams/invites',
        name: RouteNames.pendingInvites,
        builder: (context, state) => const PendingInvitesScreen(),
      ),
      GoRoute(
        path: '/teams/:id',
        name: RouteNames.teamDetail,
        builder: (context, state) =>
            TeamDetailScreen(teamId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teams/:id/members',
        name: RouteNames.teamMembers,
        builder: (context, state) =>
            TeamMembersScreen(teamId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teams/:id/invite',
        name: RouteNames.inviteMember,
        builder: (context, state) =>
            InviteMemberScreen(teamId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teams/:id/settings',
        name: RouteNames.teamSettings,
        builder: (context, state) =>
            TeamSettingsScreen(teamId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: '/marketplace',
        name: RouteNames.marketplace,
        builder: (context, state) => const MarketplaceHomeScreen(),
      ),
      GoRoute(
        path: '/marketplace/search',
        name: RouteNames.marketplaceSearch,
        builder: (context, state) => const MarketplaceSearchScreen(),
      ),
      GoRoute(
        path: '/marketplace/favorites',
        name: RouteNames.marketplaceFavorites,
        builder: (context, state) => const MarketplaceFavoritesScreen(),
      ),
      GoRoute(
        path: '/marketplace/templates/:id',
        name: RouteNames.marketplaceTemplateDetail,
        builder: (context, state) => MarketplaceTemplateDetailScreen(
          templateId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/marketplace/templates/:id/review',
        name: RouteNames.marketplaceReview,
        builder: (context, state) =>
            MarketplaceReviewScreen(templateId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/admin/marketplace',
        name: RouteNames.adminMarketplace,
        builder: (context, state) => const AdminMarketplaceListScreen(),
      ),
      GoRoute(
        path: '/admin/marketplace/create',
        name: RouteNames.adminCreateMarketplaceTemplate,
        builder: (context, state) =>
            const AdminCreateMarketplaceTemplateScreen(),
      ),
      GoRoute(
        path: '/admin/marketplace/:id/edit',
        name: RouteNames.adminEditMarketplaceTemplate,
        builder: (context, state) => const AdminEditMarketplaceTemplateScreen(),
      ),
      GoRoute(
        path: '/admin/marketplace/reviews',
        name: RouteNames.adminMarketplaceReviews,
        builder: (context, state) => const AdminMarketplaceReviewsScreen(),
      ),
      GoRoute(
        path: '/projects/create',
        name: RouteNames.createProject,
        builder: (context, state) => const CreateProjectScreen(),
      ),
      GoRoute(
        path: '/projects/:id',
        name: RouteNames.projectDetail,
        builder: (context, state) =>
            ProjectDetailScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/projects/:id/share',
        name: RouteNames.shareProject,
        builder: (context, state) =>
            ShareProjectScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/outputs/:id',
        name: RouteNames.generatedOutputDetail,
        builder: (context, state) =>
            GeneratedOutputDetailScreen(outputId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/outputs/:id/pdf-preview',
        name: RouteNames.pdfPreview,
        builder: (context, state) =>
            PdfPreviewScreen(outputId: state.pathParameters['id']!),
      ),
    ],
  );
});

class AnalyticsDemoDashboard extends ConsumerWidget {
  const AnalyticsDemoDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 860;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'AI App Builder',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            actions: isWide
                ? [
                    _NavButton(
                      label: 'Usage',
                      onPressed: () => context.pushNamed(RouteNames.myUsage),
                    ),
                    _NavButton(
                      label: 'Teams',
                      onPressed: () => context.pushNamed(RouteNames.teams),
                    ),
                    _NavButton(
                      label: 'Marketplace',
                      onPressed: () =>
                          context.pushNamed(RouteNames.marketplace),
                    ),
                    const SizedBox(width: 12),
                  ]
                : [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.menu),
                      onSelected: (value) => context.pushNamed(value),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: RouteNames.marketplace,
                          child: Text('Marketplace'),
                        ),
                        PopupMenuItem(
                          value: RouteNames.teams,
                          child: Text('Teams'),
                        ),
                        PopupMenuItem(
                          value: RouteNames.myUsage,
                          child: Text('My Usage'),
                        ),
                        PopupMenuItem(
                          value: RouteNames.adminInsights,
                          child: Text('Admin Insights'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroPanel(isWide: isWide),
                        const SizedBox(height: 18),
                        const _MetricGrid(),
                        const SizedBox(height: 18),
                        _ActionGrid(
                          isWide: isWide,
                          actions: [
                            _DashboardAction(
                              icon: Icons.storefront,
                              title: 'Template Marketplace',
                              subtitle:
                                  'Browse starter flows, premium templates, '
                                  'and launch-ready app structures.',
                              color: const Color(0xFF2563EB),
                              onTap: () =>
                                  context.pushNamed(RouteNames.marketplace),
                            ),
                            _DashboardAction(
                              icon: Icons.groups_2,
                              title: 'Team Workspace',
                              subtitle:
                                  'Invite collaborators, review shared '
                                  'projects, and manage roles.',
                              color: const Color(0xFF0F766E),
                              onTap: () => context.pushNamed(RouteNames.teams),
                            ),
                            _DashboardAction(
                              icon: Icons.query_stats,
                              title: 'Usage Analytics',
                              subtitle:
                                  'Track generation limits, activity, and '
                                  'export history in one place.',
                              color: const Color(0xFF7C3AED),
                              onTap: () =>
                                  context.pushNamed(RouteNames.myUsage),
                            ),
                            _DashboardAction(
                              icon: Icons.admin_panel_settings,
                              title: 'Admin Insights',
                              subtitle:
                                  'Monitor templates, users, activity, and '
                                  'system health.',
                              color: const Color(0xFFDC2626),
                              onTap: () =>
                                  context.pushNamed(RouteNames.adminInsights),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(onPressed: onPressed, child: Text(label)),
  );
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isWide ? 34 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF172554), Color(0xFF0F766E), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _HeroCopy(theme: theme)),
                const SizedBox(width: 28),
                const Expanded(flex: 4, child: _HeroPreview()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCopy(theme: theme),
                const SizedBox(height: 24),
                const _HeroPreview(),
              ],
            ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _StatusPill(label: 'Phase 15 installed'),
      const SizedBox(height: 20),
      Text(
        'Build, manage, and ship app ideas from one workspace.',
        style: theme.textTheme.displaySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          height: 1.05,
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Marketplace templates, team collaboration, usage '
        'analytics, and admin controls are ready for your workflow.',
        style: theme.textTheme.titleMedium?.copyWith(
          color: const Color(0xFFD1FAE5),
          height: 1.45,
        ),
      ),
    ],
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    ),
  );
}

class _HeroPreview extends StatelessWidget {
  const _HeroPreview();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
    ),
    child: Column(
      children: const [
        _PreviewRow(icon: Icons.widgets, label: '42 templates ready'),
        _PreviewRow(icon: Icons.lock_open, label: 'Secure function layer'),
        _PreviewRow(icon: Icons.group_work, label: 'Teams and roles enabled'),
        _PreviewRow(icon: Icons.picture_as_pdf, label: 'PDF exports tracked'),
      ],
    ),
  );
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF0F766E), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900 ? 4 : 2;
      return GridView.count(
        crossAxisCount: columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: columns == 4 ? 2.35 : 1.65,
        children: const [
          _MetricCard(value: '15', label: 'Product phase'),
          _MetricCard(value: '4', label: 'Core workspaces'),
          _MetricCard(value: '8', label: 'Migrations'),
          _MetricCard(value: '17', label: 'Edge functions'),
        ],
      );
    },
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.isWide, required this.actions});

  final bool isWide;
  final List<_DashboardAction> actions;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: actions.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isWide ? 4 : 1,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: isWide ? 0.95 : 2.8,
    ),
    itemBuilder: (context, index) => _ActionCard(action: actions[index]),
  );
}

class _DashboardAction {
  const _DashboardAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _DashboardAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(action.icon, color: action.color),
              ),
              const SizedBox(height: 18),
              Text(
                action.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  action.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Open',
                    style: TextStyle(
                      color: action.color,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: action.color, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpgradePlaceholderScreen extends StatelessWidget {
  const UpgradePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Upgrade')),
    body: const Center(child: Text('Premium upgrade screen placeholder.')),
  );
}
