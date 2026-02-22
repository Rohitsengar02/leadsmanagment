import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/screens/login_screen.dart';
import 'package:leads_management/screens/dashboard_screen.dart';
import 'package:leads_management/screens/leads_screen.dart';
import 'package:leads_management/screens/lead_detail_screen.dart';
import 'package:leads_management/screens/pipeline_screen.dart';
import 'package:leads_management/screens/tasks_screen.dart';
import 'package:leads_management/screens/analytics_screen.dart';
import 'package:leads_management/screens/team_screen.dart';
import 'package:leads_management/screens/settings_screen.dart';
import 'package:leads_management/screens/notifications_screen.dart';
import 'package:leads_management/screens/forms_list_screen.dart';
import 'package:leads_management/screens/form_builder_screen.dart';
import 'package:leads_management/screens/proposal_list_screen.dart';
import 'package:leads_management/screens/proposal_builder_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(path: '/leads', builder: (context, state) => const LeadsScreen()),
    GoRoute(
      path: '/leads/details',
      builder: (context, state) => const LeadDetailScreen(),
    ),
    GoRoute(
      path: '/pipeline',
      builder: (context, state) => const PipelineScreen(),
    ),
    GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(path: '/team', builder: (context, state) => const TeamScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/forms',
      builder: (context, state) => const FormsListScreen(),
    ),
    GoRoute(
      path: '/forms/builder',
      builder: (context, state) => const FormBuilderScreen(),
    ),
    GoRoute(
      path: '/proposals',
      builder: (context, state) => const ProposalListScreen(),
    ),
    GoRoute(
      path: '/proposals/builder',
      builder: (context, state) => const ProposalBuilderScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Premium CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
