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

import 'package:leads_management/screens/onboarding_screen.dart';
import 'package:leads_management/screens/all_leads_screen.dart';
import 'package:leads_management/screens/todays_leads_screen.dart';
import 'package:leads_management/screens/ai_assistant_screen.dart';
import 'package:leads_management/widgets/mobile_simulator_wrapper.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const MobileSimulatorWrapper(child: OnboardingScreen()),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MobileSimulatorWrapper(child: LoginScreen()),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/leads',
      builder: (context, state) => const MobileSimulatorWrapper(child: LeadsScreen()),
    ),
    GoRoute(
      path: '/leads/details',
      builder: (context, state) => const MobileSimulatorWrapper(child: LeadDetailScreen()),
    ),
    GoRoute(
      path: '/pipeline',
      builder: (context, state) => const MobileSimulatorWrapper(child: PipelineScreen()),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const MobileSimulatorWrapper(child: TasksScreen()),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const MobileSimulatorWrapper(child: AnalyticsScreen()),
    ),
    GoRoute(
      path: '/team',
      builder: (context, state) => const MobileSimulatorWrapper(child: TeamScreen()),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const MobileSimulatorWrapper(child: SettingsScreen()),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const MobileSimulatorWrapper(child: NotificationsScreen()),
    ),
    GoRoute(
      path: '/forms',
      builder: (context, state) => const MobileSimulatorWrapper(child: FormsListScreen()),
    ),
    GoRoute(
      path: '/forms/builder',
      builder: (context, state) => const MobileSimulatorWrapper(child: FormBuilderScreen()),
    ),
    GoRoute(
      path: '/proposals',
      builder: (context, state) => const MobileSimulatorWrapper(child: ProposalListScreen()),
    ),
    GoRoute(
      path: '/proposals/builder',
      builder: (context, state) => const MobileSimulatorWrapper(child: ProposalBuilderScreen()),
    ),
    GoRoute(
      path: '/all-leads',
      builder: (context, state) => const MobileSimulatorWrapper(child: AllLeadsScreen()),
    ),
    GoRoute(
      path: '/today-leads',
      builder: (context, state) => const MobileSimulatorWrapper(child: TodaysLeadsScreen()),
    ),
    GoRoute(
      path: '/ai-assistant',
      builder: (context, state) => const MobileSimulatorWrapper(child: AIAssistantScreen()),
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
