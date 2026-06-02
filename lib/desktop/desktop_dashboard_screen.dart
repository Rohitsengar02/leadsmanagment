import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;
import 'sound_helper.dart';
import 'ai_playground_screen.dart';
import 'team_screen.dart';
import 'chat_screen.dart';


class DesktopDashboardScreen extends StatefulWidget {
  const DesktopDashboardScreen({super.key});

  @override
  State<DesktopDashboardScreen> createState() => _DesktopDashboardScreenState();
}

class _DesktopDashboardScreenState extends State<DesktopDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  final ScrollController _pipelineScrollController = ScrollController();
  bool _isDarkMode = false;

  // Stateful tab routing
  String _currentTab = 'dashboard';
  String _selectedLeadStatusField = 'NEW';
  String? _toastMessage;
  String? _chatInitialMemberName;

  // AI Copywriting Copilot simulator states
  String _selectedCopyLead = 'Mudhu Naz';
  String _selectedCopyTemplate = 'Warm Introduction';
  String _selectedCopyTone = 'Formal';
  String _generatedCopyResult = 'Click "Generate Follow-up Text" to craft an AI strategy message... ⚡';
  bool _isCopyGenerating = false;

  // AI Intent scoring simulator states
  double _scoringBudgetSliderValue = 300000.0;
  bool _isScoringIntentCalculating = false;
  double _calculatedIntentScore = 94.0;
  double _calculatedWinProbability = 88.0;

  // AI Proposal & Quote Builder states
  String _selectedProposalLead = 'Mudhu Naz';
  String _selectedProposalScope = 'Full Brand Design Overhaul';
  String _selectedProposalTier = 'Value Package';
  double _proposalDiscountValue = 10.0; // 10% default
  bool _isProposalGenerating = false;
  String _generatedProposalResult = 'Select parameters and click "Generate AI Proposal Draft" above to create an automated enterprise contract... 📄';

  // Feature 4: Autopilot Mode
  String _selectedAutopilotMode = 'AI Performance Routing';

  // Feature 5: Pipeline Risks
  List<Map<String, dynamic>> _pipelineRisks = [
    {
      'id': 'risk1',
      'lead': 'Mudhu Naz',
      'issue': 'No contact in 5 days',
      'severity': 'HIGH',
      'action': 'Schedule VIP Strategy Sync',
      'isResolved': false,
    },
    {
      'id': 'risk2',
      'lead': 'Alex Rivera',
      'issue': 'Competitor benchmark requested',
      'severity': 'HIGH',
      'action': 'Auto-Send Integration Deck',
      'isResolved': false,
    },
    {
      'id': 'risk3',
      'lead': 'Sarah Chen',
      'issue': 'Budget verification pending',
      'severity': 'MEDIUM',
      'action': 'Trigger Pricing Nudge',
      'isResolved': false,
    },
  ];

  // Dynamic Leads state controllers
  final TextEditingController _leadNameController = TextEditingController();
  final TextEditingController _leadCompanyController = TextEditingController();
  final TextEditingController _leadValController = TextEditingController();
  final TextEditingController _leadPhoneController = TextEditingController();
  final TextEditingController _leadEmailController = TextEditingController();
  final TextEditingController _leadLocationController = TextEditingController();
  final TextEditingController _leadLinkedinController = TextEditingController();
  final TextEditingController _leadNotesController = TextEditingController();
  String _newLeadTemp = 'Hot';
  String _newLeadReq = 'UI Design';

  // Dynamic Tasks states
  final TextEditingController _taskTitleController = TextEditingController();
  String _newTaskPriority = '3'; // Default priority (1, 2, 3)
  String _newTaskTag = 'Landingpage';
  String _newTaskStatus = 'Backlog';

  List<Map<String, dynamic>> _tasksList = [
    {
      'id': 'task1',
      'title': 'Revisit Homepage Wickrpark.io',
      'tag': 'Landingpage',
      'priority': '3',
      'files': 2,
      'comments': 1,
      'status': 'Backlog',
      'avatars': ['https://i.pravatar.cc/150?u=dwayne', 'https://i.pravatar.cc/150?u=alex'],
    },
    {
      'id': 'task2',
      'title': 'Revise Feedback Analytics Page Wednesday.io',
      'tag': 'Dashboard',
      'priority': '3',
      'files': 1,
      'comments': 7,
      'status': 'Backlog',
      'avatars': ['https://i.pravatar.cc/150?u=sarah'],
    },
    {
      'id': 'task3',
      'title': 'Weekly Design Critique : Magiclean Mobile App',
      'tag': 'Design Critique',
      'priority': '1',
      'files': 1,
      'comments': 2,
      'status': 'Backlog',
      'avatars': ['https://i.pravatar.cc/150?u=mudhu', 'https://i.pravatar.cc/150?u=alex'],
    },
    {
      'id': 'task4',
      'title': 'Design Mindtree Profile Page',
      'tag': 'Landingpage',
      'priority': '2',
      'files': 2,
      'comments': 1,
      'status': 'In Progress',
      'avatars': ['https://i.pravatar.cc/150?u=dwayne', 'https://i.pravatar.cc/150?u=sarah'],
    },
    {
      'id': 'task5',
      'title': 'Sending Message Illustration for Mindtree App',
      'tag': 'Illustration',
      'priority': '1',
      'files': 1,
      'comments': 2,
      'status': 'In Progress',
      'avatars': ['https://i.pravatar.cc/150?u=alex', 'https://i.pravatar.cc/150?u=mudhu'],
      'hasIllustration': true,
    },
    {
      'id': 'task6',
      'title': 'Revise Feedback Sales Page Wednesday.io',
      'tag': 'Dashboard',
      'priority': '2',
      'files': 1,
      'comments': 3,
      'status': 'In Progress',
      'avatars': ['https://i.pravatar.cc/150?u=sarah'],
    },
    {
      'id': 'task7',
      'title': 'Covid App Dribbble Preview',
      'tag': 'Mobile App',
      'priority': '1',
      'files': 1,
      'comments': 2,
      'status': 'In Review',
      'avatars': ['https://i.pravatar.cc/150?u=mudhu'],
      'hasMockup': true,
    },
    {
      'id': 'task8',
      'title': 'Revise Feedback Product Page Wednesday.io',
      'tag': 'Dashboard',
      'priority': '2',
      'files': 1,
      'comments': 6,
      'status': 'In Review',
      'avatars': ['https://i.pravatar.cc/150?u=dwayne'],
    },
    {
      'id': 'task9',
      'title': 'Revise Feedback Product Page Wednesday.io',
      'tag': 'Dashboard',
      'priority': '2',
      'files': 1,
      'comments': 6,
      'status': 'Done',
      'avatars': ['https://i.pravatar.cc/150?u=sarah'],
    },
    {
      'id': 'task10',
      'title': 'Iconhub Dashboard Exploration Preview',
      'tag': 'Dashboard',
      'priority': '1',
      'files': 1,
      'comments': 2,
      'status': 'Done',
      'avatars': ['https://i.pravatar.cc/150?u=alex'],
      'hasDashboardPreview': true,
    },
  ];

  List<Map<String, String>> _pipelineLeads = [
    {
      'id': 'lead_1',
      'name': 'Mudhu Naz',
      'company': 'CreativeHQ',
      'val': '₹2,50,000',
      'req': 'UI Design',
      'temp': 'Hot',
      'phone': '+91 98765 43210',
      'email': 'mudhu@creativehq.com',
      'location': 'Mumbai, IN',
      'notes': 'Requires an Obsidian styled Dark mode UI Kit with scalloped elements.',
      'linkedin': 'linkedin.com/in/mudhu-naz',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Mudhu',
      'status': 'NEW',
    },
    {
      'id': 'lead_2',
      'name': 'Alex Rivera',
      'company': 'TechFlow Inc.',
      'val': '₹5,80,000',
      'req': 'Custom Software',
      'temp': 'Warm',
      'phone': '+1 (555) 432-1098',
      'email': 'alex@techflow.io',
      'location': 'San Francisco, US',
      'notes': 'Requested direct CRM sync using REST endpoints and high throughput queues.',
      'linkedin': 'linkedin.com/in/alexrivera',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Alex',
      'status': 'NEW',
    },
    {
      'id': 'lead_3',
      'name': 'Sarah Chen',
      'company': 'Global Media Group',
      'val': '₹3,20,000',
      'req': 'Web Platform',
      'temp': 'Cold',
      'phone': '+852 9123 4567',
      'email': 'sarah@globalmedia.com',
      'location': 'Hong Kong, HK',
      'notes': 'Exploring static web app hosting options for regional digital campaigns.',
      'linkedin': 'linkedin.com/in/sarah-chen',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Sarah',
      'status': 'NEW',
    },
    {
      'id': 'lead_4',
      'name': 'Jordan Peele',
      'company': 'Monkeypaw Prod',
      'val': '₹4,50,000',
      'req': 'App Dev',
      'temp': 'Hot',
      'phone': '+1 (555) 123-4567',
      'email': 'jordan@monkeypaw.com',
      'location': 'Los Angeles, US',
      'notes': 'Needs a storytelling mobile application with high density vector graphics.',
      'linkedin': 'linkedin.com/in/jordanpeele',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Jordan',
      'status': 'CONTACTED',
    },
    {
      'id': 'lead_5',
      'name': 'Mila Kunis',
      'company': 'Lola Media',
      'val': '₹1,90,000',
      'req': 'Graphic Design',
      'temp': 'Warm',
      'phone': '+1 (555) 987-6543',
      'email': 'mila@lolamedia.com',
      'location': 'Chicago, US',
      'notes': 'Wants premium dynamic brochures and vector icons for branding kits.',
      'linkedin': 'linkedin.com/in/milakunis',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Mila',
      'status': 'CONTACTED',
    },
    {
      'id': 'lead_6',
      'name': 'Robert Downey',
      'company': 'Stark Analytics',
      'val': '₹8,40,000',
      'req': 'AI Autopilot Custom',
      'temp': 'Hot',
      'phone': '+1 (555) 000-1111',
      'email': 'robert@starkanalytics.com',
      'location': 'New York, US',
      'notes': 'Requested an automated email and WhatsApp AI agent with sound notifications.',
      'linkedin': 'linkedin.com/in/robertdowney',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Robert',
      'status': 'PROPOSAL',
    },
    {
      'id': 'lead_7',
      'name': 'John Doe',
      'company': 'Acme Corp',
      'val': '₹2,20,000',
      'req': 'CRM Setup',
      'temp': 'Cold',
      'phone': '+1 (555) 222-3333',
      'email': 'john@acme.com',
      'location': 'Dallas, US',
      'notes': 'Migrating old legacy Excel sheets to active CRM pipeline tracking dashboard.',
      'linkedin': 'linkedin.com/in/johndoe',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=John',
      'status': 'PROPOSAL',
    },
    {
      'id': 'lead_8',
      'name': 'Elon Musk',
      'company': 'Tesla Tech',
      'val': '₹15,00,000',
      'req': 'Robotics CRM',
      'temp': 'Hot',
      'phone': '+1 (555) 333-4444',
      'email': 'elon@tesla.com',
      'location': 'Austin, US',
      'notes': 'High priority deal for scheduling factory robotics and logistics pipelines.',
      'linkedin': 'linkedin.com/in/elonmusk',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Elon',
      'status': 'DEMO / SYNC',
    },
    {
      'id': 'lead_9',
      'name': 'Satya Nadella',
      'company': 'Microsoft Cloud',
      'val': '₹12,50,000',
      'req': 'Enterprise Integrations',
      'temp': 'Warm',
      'phone': '+1 (555) 444-5555',
      'email': 'satya@microsoft.com',
      'location': 'Seattle, US',
      'notes': 'Requires corporate sync with active directories and federated single sign on.',
      'linkedin': 'linkedin.com/in/satyanadella',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Satya',
      'status': 'NEGOTIATION',
    },
    {
      'id': 'lead_10',
      'name': 'Sundar Pichai',
      'company': 'Alphabet Search',
      'val': '₹25,00,000',
      'req': 'AI Search Agents',
      'temp': 'Hot',
      'phone': '+1 (555) 555-6666',
      'email': 'sundar@google.com',
      'location': 'Mountain View, US',
      'notes': 'Strategic AI co-development deal for lead intent analysis engines.',
      'linkedin': 'linkedin.com/in/sundarpichai',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Sundar',
      'status': 'CONFIRMED',
    },
  ];

  void _showToast(String msg) {
    setState(() {
      _toastMessage = msg;
    });
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _toastMessage = null;
        });
      }
    });
  }

  bool _globalKeyHandler(KeyEvent event) {
    if (event is KeyDownEvent) {
      final isMetaPressed = HardwareKeyboard.instance.isMetaPressed;
      final isControlPressed = HardwareKeyboard.instance.isControlPressed;
      
      // Listen for Win+Space, Cmd+Space, or Ctrl+Space globally
      if ((isMetaPressed || isControlPressed) && event.logicalKey == LogicalKeyboardKey.space) {
        _triggerGlobalSearch();
        return true; // event handled
      }
    }
    return false;
  }

  void _triggerGlobalSearch() {
    playTukTukSound();
    
    // Scroll enclosing scroll view to top if available
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      scrollable.position.animateTo(
        0.0,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Spotlight Search',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _SearchOverlayDialog(
          pipelineLeads: _pipelineLeads,
          tasksList: _tasksList,
          onLeadSelected: (lead) {
            setState(() {
              _currentTab = 'stage-${lead['status']}';
            });
            _showToast("Viewing Stage: ${lead['name']} 🚀");
          },
          onTaskSelected: (task) {
            setState(() {
              _currentTab = 'tasks';
            });
            _showToast("Viewing Task: ${task['title']} 📋");
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 8.0 * animation.value,
            sigmaY: 8.0 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Infinite drifting background animation controller
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
    // Register global key event handler
    HardwareKeyboard.instance.addHandler(_globalKeyHandler);
  }

  @override
  void dispose() {
    // Unregister global key event handler
    HardwareKeyboard.instance.removeHandler(_globalKeyHandler);
    _bubbleController.dispose();
    _pipelineScrollController.dispose();
    _leadNameController.dispose();
    _leadCompanyController.dispose();
    _leadValController.dispose();
    _leadPhoneController.dispose();
    _leadEmailController.dispose();
    _leadLocationController.dispose();
    _leadLinkedinController.dispose();
    _leadNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F9FC),
      body: Stack(
        children: [
          // 1. INFINITE DRIFTING BACKGROUND GRADIENTS (MESH BACKDROP)
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              final angle = _bubbleController.value * 2.0 * math.pi;
              return Stack(
                children: [
                  Positioned(
                    top: 100 + 80 * math.sin(angle),
                    left: 200 + 100 * math.cos(angle),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF6A47).withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100 + 90 * math.cos(angle),
                    right: 150 + 90 * math.sin(angle),
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. MAIN 3-COLUMN LAYOUT CONTENT (WITH STATEFUL TABS)
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Column 1: Left Navigation Sidebar (Obsidian Theme with Tab Switching)
              _SidebarWidget(
                activeTab: _currentTab,
                pipelineLeads: _pipelineLeads,
                onTabChanged: (tab) {
                  setState(() {
                    _currentTab = tab;
                  });
                },
              ),

              // Column 2: Center Main Content (Swapped dynamically based on active tab)
              Expanded(
                child: _buildCenterContent(),
              ),

              // Column 3: Right Sidebar Utility Panel (Clock, Calendar, and Highlighted Actions)
              const _RightSidebarWidget(),
            ],
          ),

          // 3. Premium top-center floating glassmorphic Toast overlay
          if (_toastMessage != null)
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  builder: (context, val, child) {
                    return Transform.scale(
                      scale: val,
                      child: Opacity(
                        opacity: val,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F041C).withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFF3377).withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3377).withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFFFF3377), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _toastMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterContent() {
    switch (_currentTab) {
      case 'dashboard':
        return _buildAnalyticsView();
      case 'pipeline':
        return _buildLeadsDashboardView();
      case 'add-lead':
        return _buildAddLeadView();
      case 'ai-playground':
        return AIPlaygroundScreen(
          isDark: _isDarkMode,
          onBack: () {
            playTukTukSound();
            setState(() {
              _currentTab = 'pipeline';
            });
          },
          showToast: _showToast,
          onNavigate: (tab, name) {
            setState(() {
              _selectedCopyLead = name;
              _currentTab = tab;
            });
          },
        );
      case 'tasks':
        return _buildTasksView();
      case 'team':
        return TeamScreen(
          isDark: _isDarkMode,
          showToast: _showToast,
          onChatWithMember: (memberName) {
            playTukTukSound();
            setState(() {
              _chatInitialMemberName = memberName;
              _currentTab = 'chat';
            });
          },
        );
      case 'chat':
        return ChatScreen(
          isDark: _isDarkMode,
          showToast: _showToast,
          initialMemberName: _chatInitialMemberName,
        );
      case 'stage-NEW':
        return _buildStageLeadsView('NEW');
      case 'stage-CONTACTED':
        return _buildStageLeadsView('CONTACTED');
      case 'stage-DEMO':
        return _buildStageLeadsView('DEMO / SYNC');
      case 'stage-PROPOSAL':
        return _buildStageLeadsView('PROPOSAL');
      case 'stage-NEGOTIATION':
        return _buildStageLeadsView('NEGOTIATION');
      case 'stage-CONFIRMED':
        return _buildStageLeadsView('CONFIRMED');
      case 'analytics':
      default:
        return _buildAnalyticsView();
    }
  }

  Widget _buildTasksView() {
    final isDark = _isDarkMode;
    return SingleChildScrollView(
      key: const PageStorageKey('tasks_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderBar(),
          const SizedBox(height: 32),
          
          // MOCKUP HEADER TITLE & CONTROLS
          Row(
            children: [
              Text(
                'Weekly Sprint #4',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Date created',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '27 October 2020, 4:15 pm',
                    style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSprintTeamAvatars(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    playTukTukSound();
                    _showToast("Inviting team member... 📧");
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text('Invite People', style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Controls row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 16, color: Color(0xFF94A3B8)),
                    onPressed: () => _showToast("Opening search logs... 🔍"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded, size: 16, color: Color(0xFF94A3B8)),
                    onPressed: () => _showToast("Filtering active sprint... 📊"),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFFFECE7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFF3377).withValues(alpha: 0.15)),
                    ),
                    child: const Icon(Icons.view_kanban_outlined, size: 14, color: Color(0xFFFF3377)),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.list, size: 18, color: Color(0xFF94A3B8)),
                    onPressed: () => _showToast("Switched to List View mode."),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // HORIZONTAL KANBAN GRID (4 COLUMNS SIDE BY SIDE)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTasksColumn('Backlog', 'Backlog', const Color(0xFFFF523B), const Color(0xFFFFF2EF)),
                const SizedBox(width: 24),
                _buildTasksColumn('In Progress', 'In Progress', const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
                const SizedBox(width: 24),
                _buildTasksColumn('In Review', 'In Review', const Color(0xFF06B6D4), const Color(0xFFECFEFF)),
                const SizedBox(width: 24),
                _buildTasksColumn('Done', 'Done', const Color(0xFF10B981), const Color(0xFFDCFCE7)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksColumn(String status, String title, Color headingColor, Color bgCapsuleColor) {
    final isDark = _isDarkMode;
    // Filter tasks for this status
    List<Map<String, dynamic>> columnTasks = _tasksList.where((t) => t['status'] == status).toList();

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: headingColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: headingColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz, size: 16, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 20),

          // Tasks Cards List
          Column(
            children: columnTasks.map((task) {
              final String tag = task['tag'] as String;
              
              // Color tags
              Color tagTextColor = const Color(0xFF64748B);
              Color tagBgColor = const Color(0xFFF1F5F9);
              if (tag == 'Landingpage') {
                tagTextColor = const Color(0xFFF97316);
                tagBgColor = const Color(0xFFFFF7ED);
              } else if (tag == 'Dashboard') {
                tagTextColor = const Color(0xFF4F46E5);
                tagBgColor = const Color(0xFFEEF2FF);
              } else if (tag == 'Illustration') {
                tagTextColor = const Color(0xFF8B5CF6);
                tagBgColor = const Color(0xFFF5F3FF);
              } else if (tag == 'Design Critique') {
                tagTextColor = const Color(0xFFFF3377);
                tagBgColor = const Color(0xFFFFF2EF);
              } else if (tag == 'Mobile App') {
                tagTextColor = const Color(0xFF06B6D4);
                tagBgColor = const Color(0xFFECFEFF);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: tagTextColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Quick shifting status controller
                        PopupMenuButton<String>(
                          icon: Icon(Icons.arrow_forward_rounded, size: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8)),
                          tooltip: 'Shift stage',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 100),
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          onSelected: (String newStatus) {
                            playTukTukSound();
                            setState(() {
                              task['status'] = newStatus;
                            });
                            _showToast("Task shifted to $newStatus!");
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Backlog', 'In Progress', 'In Review', 'Done'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      task['title'] as String,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),

                    // Mockup Visual Graphics inserts
                    if (task['hasIllustration'] == true) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.1)),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.brush_outlined, size: 28, color: const Color(0xFF4F46E5).withValues(alpha: 0.15)),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [const Color(0xFF7000FF).withValues(alpha: 0.2), const Color(0xFFFF3377).withValues(alpha: 0.2)],
                                  ),
                                ),
                                child: const Icon(Icons.emoji_objects_outlined, color: Color(0xFF7000FF), size: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (task['hasMockup'] == true) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2EF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFF3377).withValues(alpha: 0.1)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFFFF3377).withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 3),
                                    const CircleAvatar(radius: 4, backgroundColor: Color(0xFFFFF2EF)),
                                    const SizedBox(height: 3),
                                    Container(width: 16, height: 3, color: Colors.grey.shade200),
                                    const SizedBox(height: 2),
                                    Container(width: 12, height: 3, color: Colors.grey.shade100),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 28,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 3),
                                    Container(width: 20, height: 4, color: const Color(0xFFEEF2FF)),
                                    const SizedBox(height: 4),
                                    const Icon(Icons.show_chart, size: 16, color: Color(0xFF4F46E5)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (task['hasDashboardPreview'] == true) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.1)),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(width: 14, height: 3, color: Colors.grey.shade300),
                                      Container(width: 6, height: 3, color: const Color(0xFF10B981)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(width: 4, height: 14, color: const Color(0xFF10B981)),
                                      Container(width: 4, height: 25, color: const Color(0xFFDCFCE7)),
                                      Container(width: 4, height: 10, color: const Color(0xFF10B981)),
                                      Container(width: 4, height: 20, color: const Color(0xFF4F46E5)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    // Card Footer
                    Row(
                      children: [
                        // Attachments Count
                        const Icon(Icons.attachment_rounded, size: 10, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 2),
                        Text(
                          '${task['files']} files',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9.5),
                        ),
                        const SizedBox(width: 10),
                        // Comments Count
                        const Icon(Icons.mode_comment_outlined, size: 10, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 2),
                        Text(
                          '${task['comments']}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9.5),
                        ),
                        const Spacer(),
                        // Avatars stacked
                        _buildAssignedAvatars(task['avatars'] as List<dynamic>),
                        const SizedBox(width: 6),
                        // Priority Badge in circle
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF2EF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              task['priority'] as String,
                              style: const TextStyle(
                                color: Color(0xFFFF3377),
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Trash Delete
                        InkWell(
                          onTap: () {
                            playTukTukSound();
                            setState(() {
                              _tasksList.removeWhere((t) => t['id'] == task['id']);
                            });
                            _showToast("Task removed from sprint.");
                          },
                          child: const Icon(Icons.delete_outline_rounded, size: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          
          // ADD NEW TASK CAPSULED BUTTON (styled purple pill)
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: () => _showAddTaskDialog(status),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7000FF), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 14, color: Color(0xFF7000FF)),
                  SizedBox(width: 6),
                  Text('Add New Task', style: TextStyle(color: Color(0xFF7000FF), fontSize: 10.5, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprintTeamAvatars() {
    List<String> teamList = [
      'https://i.pravatar.cc/150?u=dwayne',
      'https://i.pravatar.cc/150?u=alex',
      'https://i.pravatar.cc/150?u=sarah',
      'https://i.pravatar.cc/150?u=mudhu',
      'https://i.pravatar.cc/150?u=ceo',
    ];
    List<Widget> children = [];
    for (int i = 0; i < teamList.length; i++) {
      children.add(
        Positioned(
          left: i * 20.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(teamList[i]),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: teamList.length * 20.0 + 8.0,
      height: 30,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }

  Widget _buildAssignedAvatars(List<dynamic> avatars) {
    List<Widget> children = [];
    for (int i = 0; i < avatars.length; i++) {
      children.add(
        Positioned(
          left: i * 12.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: CircleAvatar(
              radius: 8,
              backgroundImage: NetworkImage(avatars[i]),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: avatars.length * 12.0 + 4.0,
      height: 20,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }

  void _showAddLeadDialog(String status) {
    _leadNameController.clear();
    _leadCompanyController.clear();
    _leadValController.text = '₹';
    _leadPhoneController.clear();
    _leadEmailController.clear();
    _leadLocationController.clear();
    _leadLinkedinController.clear();
    _leadNotesController.clear();
    _newLeadTemp = 'Hot';
    _newLeadReq = 'UI Design';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF4F46E5), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add Lead to $status',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lead Name', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _leadNameController,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Enter lead full name...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Company Name', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _leadCompanyController,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Enter company name...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Deal Value', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _leadValController,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Phone Number', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _leadPhoneController,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: '+91 98765 43210',
                                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email Address', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _leadEmailController,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: 'lead@company.com',
                                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Location', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _leadLocationController,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: 'Mumbai, IN',
                                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('LinkedIn Profile', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _leadLinkedinController,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'linkedin.com/in/profile',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Requirement', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _newLeadReq,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      items: ['UI Design', 'App Dev', 'Custom Software', 'Graphic Design', 'AI Autopilot Custom', 'CRM Setup', 'Enterprise Integrations'].map((String val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        if (newVal != null) {
                                          playTukTukSound();
                                          setDialogState(() {
                                            _newLeadReq = newVal;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Temperature', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _newLeadTemp,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      items: ['Hot', 'Warm', 'Cold'].map((String val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        if (newVal != null) {
                                          playTukTukSound();
                                          setDialogState(() {
                                            _newLeadTemp = newVal;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Detailed Notes / Requirements', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _leadNotesController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Enter detailed scope of work or notes...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Checkpoints & Validations
                    if (_leadNameController.text.trim().isEmpty) {
                      _showToast("Lead Name cannot be empty! ❌");
                      return;
                    }
                    if (_leadCompanyController.text.trim().isEmpty) {
                      _showToast("Company Name cannot be empty! ❌");
                      return;
                    }
                    if (_leadValController.text.trim().length <= 1) {
                      _showToast("Please enter a valid Deal Value! ❌");
                      return;
                    }
                    final phoneText = _leadPhoneController.text.trim();
                    if (phoneText.isEmpty) {
                      _showToast("Phone Number cannot be empty! ❌");
                      return;
                    }
                    if (phoneText.length < 10) {
                      _showToast("Please enter a valid 10-digit Phone Number! ❌");
                      return;
                    }
                    final emailText = _leadEmailController.text.trim();
                    if (emailText.isEmpty || !emailText.contains('@') || !emailText.contains('.')) {
                      _showToast("Please enter a valid Email Address! ❌");
                      return;
                    }
                    final notesText = _leadNotesController.text.trim();
                    if (notesText.length < 5) {
                      _showToast("Please provide more detailed notes (min 5 chars)! ❌");
                      return;
                    }

                    // Success creation
                    playTukTukSound();
                    final String cleanName = _leadNameController.text.trim();
                    setState(() {
                      _pipelineLeads.add({
                        'id': 'lead_${DateTime.now().millisecondsSinceEpoch}',
                        'name': cleanName,
                        'company': _leadCompanyController.text.trim(),
                        'val': _leadValController.text.trim(),
                        'req': _newLeadReq,
                        'temp': _newLeadTemp,
                        'phone': phoneText,
                        'email': emailText,
                        'location': _leadLocationController.text.trim().isEmpty ? 'Mumbai, IN' : _leadLocationController.text.trim(),
                        'linkedin': _leadLinkedinController.text.trim().isEmpty ? 'linkedin.com' : _leadLinkedinController.text.trim(),
                        'notes': notesText,
                        'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=$cleanName',
                        'status': status,
                      });
                    });
                    Navigator.pop(context);
                    _showToast("Lead added to $status successfully! 🚀");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Create Lead', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTaskDialog(String status) {
    _taskTitleController.clear();
    _newTaskPriority = '3';
    _newTaskTag = 'Landingpage';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Add Task to $status',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Task Action Title', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _taskTitleController,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Enter task description...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7000FF))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tag Category', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _newTaskTag,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  items: ['Landingpage', 'Dashboard', 'Illustration', 'Design Critique', 'Mobile App'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    if (newVal != null) {
                                      playTukTukSound();
                                      setDialogState(() {
                                        _newTaskTag = newVal;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Priority Rank', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _newTaskPriority,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  items: ['1', '2', '3'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    if (newVal != null) {
                                      playTukTukSound();
                                      setDialogState(() {
                                        _newTaskPriority = newVal;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_taskTitleController.text.trim().isEmpty) {
                      _showToast("Task title cannot be empty!");
                      return;
                    }
                    playTukTukSound();
                    setState(() {
                      _tasksList.add({
                        'id': 'task_${DateTime.now().millisecondsSinceEpoch}',
                        'title': _taskTitleController.text.trim(),
                        'tag': _newTaskTag,
                        'priority': _newTaskPriority,
                        'files': 1,
                        'comments': 2,
                        'status': status,
                        'avatars': ['https://i.pravatar.cc/150?u=dwayne'],
                      });
                    });
                    Navigator.pop(context);
                    _showToast("Sprint Task added successfully! 🚀");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7000FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Create Task', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      key: const PageStorageKey('analytics_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderBar(),
          const SizedBox(height: 32),
          const _AnalyticsHeading(),
          const SizedBox(height: 32),
          const _MetricsGrid(),
          const SizedBox(height: 32),
          _LeadsCarouselWidget(
            onViewAll: () {
              playTukTukSound();
              setState(() {
                _currentTab = 'pipeline';
              });
            },
            onNavigate: (tab, leadName) {
              playTukTukSound();
              setState(() {
                _currentTab = tab;
                if (leadName != null) {
                  _selectedCopyLead = leadName;
                }
              });
            },
          ),
          const SizedBox(height: 32),
          const _ChartsRow(),
          const SizedBox(height: 32),
          const _BottomGrid(),
        ],
      ),
    );
  }

  Widget _buildLeadsDashboardView() {
    return SingleChildScrollView(
      key: const PageStorageKey('dashboard_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderBar(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads Intake Board',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    'Sociafy CRM live lead queues and stage analytics.',
                    style: TextStyle(
                      color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        _buildFilterChip('All stages', isActive: true),
                        _buildFilterChip('Hot Leads', isActive: false),
                        _buildFilterChip('Warm Leads', isActive: false),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      playTukTukSound();
                      setState(() {
                        _selectedLeadStatusField = 'NEW';
                        _currentTab = 'add-lead';
                      });
                    },
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: const Text(
                      'Add Lead',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildMiniKPICard('Total Leads Intake', '1,482', '+12.4%', Icons.person_add_alt_1_outlined, const Color(0xFFFF523B))),
              const SizedBox(width: 20),
              Expanded(child: _buildMiniKPICard('Deals Won Stage', '384', '+8.2%', Icons.emoji_events_outlined, const Color(0xFF10B981))),
              const SizedBox(width: 20),
              Expanded(child: _buildMiniKPICard('Pipeline Val', '₹42.8 Lakhs', '+15.1%', Icons.monetization_on_outlined, const Color(0xFF4F46E5))),
              const SizedBox(width: 20),
              Expanded(child: _buildMiniKPICard('Avg Close Time', '14 Days', '-3 days', Icons.speed_outlined, const Color(0xFFF59E0B))),
            ],
          ),
          const SizedBox(height: 24),
          // Stage Carousel Navigator Row
          _buildStageCarouselNavigator(),
          const SizedBox(height: 24),

          // HORIZONTAL CAROUSEL GRID (6 COLUMNS SIDE BY SIDE WITH FLOATING BUTTONS)
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SingleChildScrollView(
                  controller: _pipelineScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKanbanColumn(
                        title: 'INTAKE / NEW',
                        status: 'NEW',
                        color: const Color(0xFFFF523B),
                      ),
                      const SizedBox(width: 20),
                      _buildKanbanColumn(
                        title: 'CONTACTED / STRATEGY',
                        status: 'CONTACTED',
                        color: const Color(0xFF4F46E5),
                      ),
                      const SizedBox(width: 20),
                      _buildKanbanColumn(
                        title: 'DEMO / LIVE SYNC',
                        status: 'DEMO / SYNC',
                        color: const Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 20),
                      _buildKanbanColumn(
                        title: 'PROPOSAL / CONTRACT',
                        status: 'PROPOSAL',
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 20),
                      _buildKanbanColumn(
                        title: 'NEGOTIATION / REVIEWS',
                        status: 'NEGOTIATION',
                        color: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 20),
                      _buildKanbanColumn(
                        title: 'CONFIRMED / WON',
                        status: 'CONFIRMED',
                        color: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),

              // Left Floating Chevron Button
              Positioned(
                left: 4,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: _isDarkMode ? const Color(0xFF1E293B).withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                      onPressed: () {
                        playTukTukSound();
                        final double currentOffset = _pipelineScrollController.offset;
                        final double targetOffset = (currentOffset - 280).clamp(0.0, _pipelineScrollController.position.maxScrollExtent);
                        _pipelineScrollController.animateTo(
                          targetOffset,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Right Floating Chevron Button
              Positioned(
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isDarkMode ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: _isDarkMode ? const Color(0xFF1E293B).withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                      onPressed: () {
                        playTukTukSound();
                        final double currentOffset = _pipelineScrollController.offset;
                        final double targetOffset = (currentOffset + 280).clamp(0.0, _pipelineScrollController.position.maxScrollExtent);
                        _pipelineScrollController.animateTo(
                          targetOffset,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lead Acquisition Sources',
                        style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSourceIndicator('LinkedIn Ads', '45%', const Color(0xFFFF3377)),
                          _buildSourceIndicator('Direct Web', '30%', const Color(0xFF4F46E5)),
                          _buildSourceIndicator('Referrals', '15%', const Color(0xFF10B981)),
                          _buildSourceIndicator('Google Search', '10%', const Color(0xFFF59E0B)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 12,
                          child: Row(
                            children: [
                              Expanded(flex: 45, child: Container(color: const Color(0xFFFF3377))),
                              Expanded(flex: 30, child: Container(color: const Color(0xFF4F46E5))),
                              Expanded(flex: 15, child: Container(color: const Color(0xFF10B981))),
                              Expanded(flex: 10, child: Container(color: const Color(0xFFF59E0B))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operational Logs',
                        style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildTimelineLog('09:42 AM', 'AI follow-up sent to Mudhu Naz.', Colors.purple),
                      const SizedBox(height: 12),
                      _buildTimelineLog('08:30 AM', 'Sarah Chen moved to Proposal Sent.', Colors.orange),
                      const SizedBox(height: 12),
                      _buildTimelineLog('Yesterday', 'WhatsApp campaign blast sent successfully.', Colors.green),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (const Color(0xFFFF523B).withValues(alpha: _isDarkMode ? 0.25 : 0.12))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? const Color(0xFFFF6A55)
              : (_isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStageCarouselNavigator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCarouselDotIndicator('NEW', const Color(0xFFFF523B), 0),
            _buildCarouselDotIndicator('CONTACTED', const Color(0xFF4F46E5), 1),
            _buildCarouselDotIndicator('DEMO / SYNC', const Color(0xFF8B5CF6), 2),
            _buildCarouselDotIndicator('PROPOSAL', const Color(0xFFF59E0B), 3),
            _buildCarouselDotIndicator('NEGOTIATION', const Color(0xFF06B6D4), 4),
            _buildCarouselDotIndicator('CONFIRMED', const Color(0xFF10B981), 5),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselDotIndicator(String label, Color color, int idx) {
    return GestureDetector(
      onTap: () {
        playTukTukSound();
        _pipelineScrollController.animateTo(
          idx * 280.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: _isDarkMode ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: _isDarkMode ? 0.35 : 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w900, letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniKPICard(String label, String val, String growth, IconData icon, Color color) {
    final isNegative = growth.startsWith('-');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      val,
                      style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      growth,
                      style: TextStyle(
                        color: isNegative ? Colors.orange : const Color(0xFF10B981),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn({
    required String title,
    required String status,
    required Color color,
  }) {
    final List<Map<String, String>> items = _pipelineLeads.where((lead) => lead['status'] == status).toList();
    final int count = items.length;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      playTukTukSound();
                      setState(() {
                        _selectedLeadStatusField = status;
                        _currentTab = 'add-lead';
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.add, size: 12, color: color),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, idx) {
              final item = items[idx];
              final String temp = item['temp'] ?? 'Hot';
              final tempColor = temp == 'Hot'
                  ? const Color(0xFFFF523B)
                  : (temp == 'Warm' ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5));
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HoverableLeadCard(
                  lead: item,
                  stageColor: color,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : color.withValues(alpha: 0.10), width: 1.0), // Very light minimalist border!
                    boxShadow: [
                      // 1. Top light highlight reflection to create high-end 3D bevel look
                      BoxShadow(
                        color: _isDarkMode ? Colors.transparent : Colors.white.withValues(alpha: 0.95),
                        blurRadius: 0,
                        offset: const Offset(0, -2),
                      ),
                      // 2. Focused 3D shadow for elevated card depth (very subtle)
                      BoxShadow(
                        color: color.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                      // 3. Broad soft ambient shadow matching pipeline stage color
                      BoxShadow(
                        color: color.withValues(alpha: 0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                      // 4. Ground depth shadow for maximum 3D popping feel
                      BoxShadow(
                        color: color.withValues(alpha: 0.01),
                        blurRadius: 30,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Top Section Stack (Banner, Avatar, Scope Pill)
                        SizedBox(
                          height: 75,
                          child: Stack(
                            children: [
                              // Colorful Fluid Gradient Banner Container with margins
                              Positioned(
                                top: 8,
                                left: 8,
                                right: 8,
                                height: 48,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        color,
                                        color.withValues(alpha: 0.7),
                                        const Color(0xFFFF523B).withValues(alpha: 0.7), // Vibrant accent
                                        const Color(0xFFF59E0B).withValues(alpha: 0.8), // Amber gold accent
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withValues(alpha: 0.15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Overlapping Circle Avatar with white border at bottom-left
                              Positioned(
                                bottom: 0,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                    border: Border.all(
                                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: color.withValues(alpha: 0.08),
                                    foregroundImage: NetworkImage(
                                      item['avatar'] ?? 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(item['name'] ?? 'Guest')}',
                                    ),
                                    child: Text(
                                      (item['name'] ?? 'U').isEmpty ? 'U' : (item['name'] ?? 'U').substring(0, 1).toUpperCase(),
                                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 9),
                                    ),
                                  ),
                                ),
                              ),

                              // Scope / Technology Pill at bottom-right of the banner
                              Positioned(
                                bottom: 4,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.category_outlined, size: 8, color: color),
                                      const SizedBox(width: 3),
                                      Text(
                                        item['req'] ?? 'UI Design',
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 2. Name & Title Row (with Stage Swap button on the right)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      item['company'] ?? 'Enterprise Inc.',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Swap/Convert Stage Button
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F9FC),
                                  border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                ),
                                child: PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.swap_horiz_rounded, size: 11, color: Color(0xFF64748B)),
                                  tooltip: 'Convert Stage',
                                  constraints: const BoxConstraints(minWidth: 150),
                                  color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                  onSelected: (String newStatus) {
                                    playTukTukSound();
                                    setState(() {
                                      final idx = _pipelineLeads.indexWhere((l) => l['id'] == item['id']);
                                      if (idx != -1) {
                                        _pipelineLeads[idx]['status'] = newStatus;
                                      }
                                    });
                                    _showToast("${item['name']} converted to $newStatus! 🚀");
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      {'label': 'New Intake 📥', 'value': 'NEW'},
                                      {'label': 'Contacted 📞', 'value': 'CONTACTED'},
                                      {'label': 'Demo / Sync 💻', 'value': 'DEMO / SYNC'},
                                      {'label': 'Proposal Sent 📄', 'value': 'PROPOSAL'},
                                      {'label': 'Negotiation 🤝', 'value': 'NEGOTIATION'},
                                      {'label': 'Confirmed / Won 🎉', 'value': 'CONFIRMED'},
                                    ].map((choice) {
                                      return PopupMenuItem<String>(
                                        value: choice['value'] as String,
                                        child: Text(
                                          choice['label'] as String,
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : const Color(0xFF0F172A)),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Notes text
                        if (item['notes'] != null && item['notes']!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                            child: Text(
                              item['notes']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 10,
                                height: 1.3,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),

                        // 3. Three Columns of details (Value, Priority, Location)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Row(
                            children: [
                              // Column 1: Value
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.monetization_on_outlined, size: 9.5, color: Color(0xFF10B981)),
                                        const SizedBox(width: 3),
                                        Text(
                                          item['val'] ?? '₹0',
                                          style: TextStyle(
                                            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Value',
                                      style: TextStyle(color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(width: 1, height: 14, color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)), // Divider
                              // Column 2: Priority
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bolt_rounded, size: 9.5, color: tempColor),
                                        const SizedBox(width: 3),
                                        Text(
                                          temp,
                                          style: TextStyle(
                                            color: tempColor,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Priority',
                                      style: TextStyle(color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(width: 1, height: 14, color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)), // Divider
                              // Column 3: Location
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 9.5, color: Color(0xFF3B82F6)),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          child: Text(
                                            item['location'] ?? 'Remote',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Location',
                                      style: TextStyle(color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),
              ),
            );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSourceIndicator(String name, String pct, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$name ($pct)',
          style: TextStyle(color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTimelineLog(String time, String msg, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Container(
              width: 1,
              height: 24,
              color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                msg,
                style: TextStyle(color: _isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddLeadView() {
    // Quality check evaluations
    final bool isNameOk = _leadNameController.text.trim().isNotEmpty;
    final bool isCompanyOk = _leadCompanyController.text.trim().isNotEmpty;
    final String emailTrimmed = _leadEmailController.text.trim();
    final bool isEmailOk = emailTrimmed.contains('@') && emailTrimmed.contains('.');
    final String phoneDigits = _leadPhoneController.text.replaceAll(RegExp(r'\D'), '');
    final bool isPhoneOk = phoneDigits.length >= 10;
    final bool isNotesOk = _leadNotesController.text.trim().length >= 6;

    int completedChecksCount = 0;
    if (isNameOk) completedChecksCount++;
    if (isCompanyOk) completedChecksCount++;
    if (isEmailOk) completedChecksCount++;
    if (isPhoneOk) completedChecksCount++;
    if (isNotesOk) completedChecksCount++;

    final double completionPercent = completedChecksCount / 5.0;

    return SingleChildScrollView(
      key: const PageStorageKey('add_lead_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderBar(),
          const SizedBox(height: 32),
          
          // HEADER TITLE & BACK BUTTON Row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF4F46E5)),
                onPressed: () {
                  playTukTukSound();
                  setState(() {
                    _currentTab = 'pipeline';
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Lead Intake Hub ⚡',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter client details, configure deals, and verify quality standards dynamically.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // TWO COLUMN LAYOUT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLUMN 1: CLIENT DETAILS (Flex: 3)
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.badge_outlined, color: Color(0xFF4F46E5), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Client Identity Profile',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Full Name',
                              placeholder: 'e.g. Mudhu Naz',
                              controller: _leadNameController,
                              icon: Icons.person_outline_rounded,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildInputField(
                              label: 'Company Name',
                              placeholder: 'e.g. CreativeHQ',
                              controller: _leadCompanyController,
                              icon: Icons.business_outlined,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Email Address',
                              placeholder: 'e.g. mudhu@creativehq.com',
                              controller: _leadEmailController,
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildInputField(
                              label: 'Phone Contact',
                              placeholder: 'e.g. +91 98765 43210',
                              controller: _leadPhoneController,
                              icon: Icons.phone_android_rounded,
                              keyboardType: TextInputType.phone,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Geo Location',
                              placeholder: 'e.g. Mumbai, IN or San Francisco, US',
                              controller: _leadLocationController,
                              icon: Icons.location_on_outlined,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildInputField(
                              label: 'LinkedIn Profile URL',
                              placeholder: 'linkedin.com/in/username',
                              controller: _leadLinkedinController,
                              icon: Icons.link_rounded,
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 28),

              // COLUMN 2: DEAL CONFIG & QUALITY METER (Flex: 2)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Configuration Sheet
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.tune_rounded, color: Color(0xFFFF523B), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Deal parameters',
                                style: TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildInputField(
                            label: 'Estimated Deal Value (INR)',
                            placeholder: 'e.g. ₹2,50,000',
                            controller: _leadValController,
                            icon: Icons.monetization_on_outlined,
                            onChanged: (val) => setState(() {}),
                          ),
                          const SizedBox(height: 20),
                          
                          // Dropdowns Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Lead Temp',
                                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _newLeadTemp,
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          items: ['Hot', 'Warm', 'Cold'].map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            if (newVal != null) {
                                              playTukTukSound();
                                              setState(() {
                                                _newLeadTemp = newVal;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Launch Stage',
                                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedLeadStatusField,
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          items: ['NEW', 'CONTACTED', 'DEMO / SYNC', 'PROPOSAL', 'NEGOTIATION', 'CONFIRMED'].map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            if (newVal != null) {
                                              playTukTukSound();
                                              setState(() {
                                                _selectedLeadStatusField = newVal;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Required Scope',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _newLeadReq,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    items: ['UI Design', 'Custom Software', 'Web Platform', 'App Dev', 'Graphic Design', 'CRM Setup', 'AI Autopilot Custom'].map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      if (newVal != null) {
                                        playTukTukSound();
                                        setState(() {
                                          _newLeadReq = newVal;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Notes/Requirements Field
                          const Text(
                            'Client Requirements Summary',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _leadNotesController,
                            maxLines: 3,
                            onChanged: (val) => setState(() {}),
                            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: 'Describe details, scope details, specific dark UI requirements...',
                              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
                              filled: true,
                              fillColor: const Color(0xFFF8F9FC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quality Checklist & Progress Meter
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Lead Quality Checkpoints',
                                style: TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Meter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Feasibility Rating: ${(completionPercent * 100).toInt()}%',
                                style: TextStyle(
                                  color: completionPercent == 1.0 ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (completionPercent == 1.0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '100% Ready!',
                                    style: TextStyle(color: Color(0xFF065F46), fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: completionPercent,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFE2E8F0),
                              color: completionPercent == 1.0 ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildCheckpointRow('Full Name is specified', isNameOk),
                          const SizedBox(height: 10),
                          _buildCheckpointRow('Company profile is specified', isCompanyOk),
                          const SizedBox(height: 10),
                          _buildCheckpointRow('Valid email format (contains @ and .)', isEmailOk),
                          const SizedBox(height: 10),
                          _buildCheckpointRow('Valid contact number (10+ digits)', isPhoneOk),
                          const SizedBox(height: 10),
                          _buildCheckpointRow('Detailed client requirements (> 5 chars)', isNotesOk),
                          
                          const SizedBox(height: 28),

                          // Launch Deal Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isNameOk) {
                                  _showToast("Lead Name is required!");
                                  return;
                                }
                                playTukTukSound();
                                
                                final Map<String, String> newLead = {
                                  'id': 'lead_${DateTime.now().millisecondsSinceEpoch}',
                                  'name': _leadNameController.text.trim(),
                                  'company': _leadCompanyController.text.trim().isEmpty ? 'Indie Client' : _leadCompanyController.text.trim(),
                                  'val': _leadValController.text.trim().isEmpty ? '₹0' : _leadValController.text.trim(),
                                  'req': _newLeadReq,
                                  'temp': _newLeadTemp,
                                  'phone': _leadPhoneController.text.trim(),
                                  'email': _leadEmailController.text.trim(),
                                  'location': _leadLocationController.text.trim().isEmpty ? 'Remote' : _leadLocationController.text.trim(),
                                  'notes': _leadNotesController.text.trim(),
                                  'linkedin': _leadLinkedinController.text.trim(),
                                  'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(_leadNameController.text.trim())}',
                                  'status': _selectedLeadStatusField,
                                };

                                setState(() {
                                  _pipelineLeads.add(newLead);
                                  _currentTab = 'pipeline';
                                  
                                  // Reset
                                  _leadNameController.clear();
                                  _leadCompanyController.clear();
                                  _leadValController.clear();
                                  _leadPhoneController.clear();
                                  _leadEmailController.clear();
                                  _leadLocationController.clear();
                                  _leadLinkedinController.clear();
                                  _leadNotesController.clear();
                                });

                                _showToast("Lead '${newLead['name']}' successfully launched to ${newLead['status']}! 🚀");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: completionPercent == 1.0 ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(completionPercent == 1.0 ? Icons.rocket_launch_rounded : Icons.add_circle_outline_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Launch Lead to Pipeline',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 16),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckpointRow(String label, bool isOk) {
    return Row(
      children: [
        Icon(
          isOk ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: isOk ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
          size: 16,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: isOk ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: isOk ? FontWeight.w600 : FontWeight.normal,
            decoration: isOk ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStageLeadsView(String stage) {
    final List<Map<String, String>> stageLeads = _pipelineLeads.where((lead) => lead['status'] == stage).toList();
    
    // Custom header descriptions based on stage
    String title = "Pipeline Stage";
    String subtitle = "View and interact with leads in this stage of the intake flow.";
    String emoji = "📋";
    Color stageColor = const Color(0xFF4F46E5);

    if (stage == 'NEW') {
      title = "Intake / New Leads";
      subtitle = "Newly incoming leads awaiting verification, feasibility check, and initial contact.";
      emoji = "📥";
      stageColor = const Color(0xFFFF523B);
    } else if (stage == 'CONTACTED') {
      title = "Contacted & Strategy";
      subtitle = "Leads that have received outreach. Active conversations regarding design scope and goals.";
      emoji = "📞";
      stageColor = const Color(0xFF4F46E5);
    } else if (stage == 'DEMO / SYNC') {
      title = "Live Demo & Sync Queue";
      subtitle = "Interactive demo sessions scheduled or completed. Syncing platforms and technical specifications.";
      emoji = "💻";
      stageColor = const Color(0xFF8B5CF6);
    } else if (stage == 'PROPOSAL') {
      title = "Proposal & Commercial Drafts";
      subtitle = "Active enterprise contracts, discount bidding, and pricing layouts awaiting reviews.";
      emoji = "📄";
      stageColor = const Color(0xFFF59E0B);
    } else if (stage == 'NEGOTIATION') {
      title = "Negotiation & Reviews";
      subtitle = "Final terms verification. Fine-tuning SLAs, pricing packages, and launch dates.";
      emoji = "🤝";
      stageColor = const Color(0xFF06B6D4);
    } else if (stage == 'CONFIRMED') {
      title = "Confirmed & Won Deals";
      subtitle = "Closed-won accounts successfully verified and launched into active service queues!";
      emoji = "🎉";
      stageColor = const Color(0xFF10B981);
    }

    return SingleChildScrollView(
      key: PageStorageKey('stage_${stage}_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderBar(),
          const SizedBox(height: 32),

          // BACK BUTTON & HEADER INFO ROW
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                onPressed: () {
                  playTukTukSound();
                  setState(() {
                    _currentTab = 'pipeline';
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title $emoji',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  playTukTukSound();
                  setState(() {
                    _selectedLeadStatusField = stage;
                    _currentTab = 'add-lead';
                  });
                },
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: const Text('Add Lead Here', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stageColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // EMPTY STATE OR GRID OF CARDS
          if (stageLeads.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: stageColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.folder_open_rounded, color: stageColor, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Active Leads in $title',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click the button above to intake a new lead directly into this stage.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 0.76, // Elegant compact aspect ratio with details and shadow!
              ),
              itemCount: stageLeads.length,
              itemBuilder: (context, index) {
                final lead = stageLeads[index];
                final String temp = lead['temp'] ?? 'Hot';
                final tempColor = temp == 'Hot'
                    ? const Color(0xFFFF523B)
                    : (temp == 'Warm' ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5));

                return HoverableLeadCard(
                  lead: lead,
                  stageColor: stageColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : stageColor.withValues(alpha: 0.10), width: 1.0), // Very light minimalist border!
                      boxShadow: [
                        // 1. Sleek highlight reflection
                        BoxShadow(
                          color: _isDarkMode ? Colors.transparent : Colors.white.withValues(alpha: 0.90),
                          blurRadius: 0,
                          offset: const Offset(0, -1),
                        ),
                        // 2. Premium soft drop shadow
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        // 3. Ambient colored depth shadow matching stage color
                        BoxShadow(
                          color: stageColor.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Top Section Stack (Banner, Avatar, Scope Pill)
                          SizedBox(
                            height: 95,
                            child: Stack(
                              children: [
                                // Colorful Fluid Gradient Banner Container with margins
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                  height: 65,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          stageColor,
                                          stageColor.withValues(alpha: 0.7),
                                          const Color(0xFFFF523B).withValues(alpha: 0.7), // Vibrant orange/pink accent
                                          const Color(0xFFF59E0B).withValues(alpha: 0.9), // Amber gold accent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: -15,
                                            right: -15,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withValues(alpha: 0.15),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -20,
                                            left: 40,
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withValues(alpha: 0.08),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Overlapping Circle Avatar with white border at bottom-left
                                Positioned(
                                  bottom: 0,
                                  left: 24,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                      border: Border.all(
                                        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: stageColor.withValues(alpha: 0.08),
                                      foregroundImage: NetworkImage(
                                        lead['avatar'] ?? 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(lead['name'] ?? 'Guest')}',
                                      ),
                                      child: Text(
                                        (lead['name'] ?? 'U').isEmpty ? 'U' : (lead['name'] ?? 'U').substring(0, 1).toUpperCase(),
                                        style: TextStyle(color: stageColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          // 2. Name & Title Row (with Stage Swap button on the right)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lead['name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        lead['company'] ?? 'Enterprise Inc.',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Swap/Convert Stage Button
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F9FC),
                                    border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                    child: PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.swap_horiz_rounded, size: 13, color: Color(0xFF64748B)),
                                      tooltip: 'Convert Stage',
                                      constraints: const BoxConstraints(minWidth: 160),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                      onSelected: (newStage) {
                                        playTukTukSound();
                                        setState(() {
                                          final idx = _pipelineLeads.indexWhere((l) => l['id'] == lead['id']);
                                          if (idx != -1) {
                                            _pipelineLeads[idx]['status'] = newStage;
                                          }
                                        });
                                        _showToast("Moved ${lead['name']} to $newStage! 🚀");
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(value: 'NEW', child: Text('Intake / New 📥', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                        PopupMenuItem(value: 'CONTACTED', child: Text('Contacted 📞', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                        PopupMenuItem(value: 'DEMO / SYNC', child: Text('Demo / Sync 💻', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                        PopupMenuItem(value: 'PROPOSAL', child: Text('Proposal Sent 📄', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                        PopupMenuItem(value: 'NEGOTIATION', child: Text('Negotiation 🤝', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                        PopupMenuItem(value: 'CONFIRMED', child: Text('Confirmed / Won 🎉', style: TextStyle(color: _isDarkMode ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 2.5 Requirements / Client Notes (2 lines with ellipsis)
                          if (lead['notes'] != null && lead['notes']!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              child: Text(
                                lead['notes']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  fontSize: 10.5,
                                  height: 1.3,
                                ),
                              ),
                            ),

                          // 3. Details list view with elegant gaps
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: Column(
                              children: [
                                _buildCardDetailRow(
                                  icon: Icons.monetization_on_outlined,
                                  iconColor: const Color(0xFF10B981),
                                  label: 'Value',
                                  value: lead['val'] ?? '₹0',
                                  valueColor: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                ),
                                const SizedBox(height: 6),
                                _buildCardDetailRow(
                                  icon: Icons.grid_view_rounded,
                                  iconColor: stageColor,
                                  label: 'Scope',
                                  value: lead['req'] ?? 'UI Design',
                                  valueColor: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                ),
                                const SizedBox(height: 6),
                                _buildCardDetailRow(
                                  icon: Icons.bolt_rounded,
                                  iconColor: tempColor,
                                  label: 'Priority',
                                  value: temp,
                                  valueColor: tempColor,
                                ),
                                const SizedBox(height: 6),
                                _buildCardDetailRow(
                                  icon: Icons.location_on_outlined,
                                  iconColor: const Color(0xFF3B82F6),
                                  label: 'Location',
                                  value: lead['location'] ?? 'Remote',
                                  valueColor: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),

                          // 4. Bottom Horizontal Pill Actions bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F9FC),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStageCardActionButton(
                                    tooltip: 'WhatsApp Thread',
                                    icon: Icons.message_rounded,
                                    color: const Color(0xFF10B981),
                                    onTap: () {
                                      playTukTukSound();
                                      _showToast("Initiating secure WhatsApp thread with ${lead['name']}... 💬");
                                    },
                                  ),
                                  _buildStageCardActionButton(
                                    tooltip: 'VoIP Call',
                                    icon: Icons.phone_rounded,
                                    color: const Color(0xFF3B82F6),
                                    onTap: () {
                                      playTukTukSound();
                                      _showToast("Connecting VoIP call to ${lead['phone']}... 📞");
                                    },
                                  ),
                                  _buildStageCardActionButton(
                                    tooltip: 'SMS Dispatch',
                                    icon: Icons.sms_outlined,
                                    color: const Color(0xFFF97316),
                                    onTap: () {
                                      playTukTukSound();
                                      _showToast("Drafting SMS dispatch for ${lead['name']}... ✉️");
                                    },
                                  ),
                                  _buildStageCardActionButton(
                                    tooltip: 'AI Follow-up',
                                    icon: Icons.bolt_rounded,
                                    color: const Color(0xFF8B5CF6),
                                    onTap: () {
                                      playTukTukSound();
                                      setState(() {
                                        _selectedCopyLead = lead['name'] ?? 'Mudhu Naz';
                                        _currentTab = 'ai-playground';
                                      });
                                      _showToast("AI Copilot loaded for ${lead['name']}! Opening templates... ⚡");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStageCardActionButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          hoverColor: color.withValues(alpha: 0.08),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 12,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


// ==================== SIDEBAR WIDGET ====================
class _SidebarWidget extends StatefulWidget {
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final List<Map<String, String>> pipelineLeads;

  const _SidebarWidget({
    required this.activeTab,
    required this.onTabChanged,
    required this.pipelineLeads,
  });

  @override
  State<_SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<_SidebarWidget> {
  bool _isPipelineExpanded = true; // Kept open by default for rich layout

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          right: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Brand Logo Area with Version
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF3377), Color(0xFFFF523B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF3377).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.flash_on, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sociafy',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'v2.4 Enterprise',
                      style: TextStyle(
                        color: Color(0xFFFF3377),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),
          ),

          // 2. Premium Workspace Selector Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7000FF)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google Workspace',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Active Agency',
                          style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.unfold_more_rounded, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      'MAIN MENU',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
          _SidebarItemWidget(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            isActive: widget.activeTab == 'dashboard',
            onTap: () => widget.onTabChanged('dashboard'),
          ),
          _SidebarItemWidget(
            icon: Icons.view_kanban_outlined,
            label: 'Pipeline',
            isActive: widget.activeTab == 'pipeline' || widget.activeTab.startsWith('stage-'),
            trailing: Icon(
              _isPipelineExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_left_rounded,
              size: 16,
              color: widget.activeTab == 'pipeline' || widget.activeTab.startsWith('stage-')
                  ? const Color(0xFFFF3377)
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            onTap: () {
              playTukTukSound();
              setState(() {
                _isPipelineExpanded = !_isPipelineExpanded;
              });
              widget.onTabChanged('pipeline');
            },
          ),
          
          if (_isPipelineExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  _buildSubTabItem(
                    label: 'Intake / New',
                    stageTab: 'stage-NEW',
                    stageName: 'NEW',
                    color: const Color(0xFFFF523B),
                    icon: Icons.fiber_new_rounded,
                    isDark: isDark,
                  ),
                  _buildSubTabItem(
                    label: 'Contacted',
                    stageTab: 'stage-CONTACTED',
                    stageName: 'CONTACTED',
                    color: const Color(0xFF4F46E5),
                    icon: Icons.forum_outlined,
                    isDark: isDark,
                  ),
                  _buildSubTabItem(
                    label: 'Demo / Sync',
                    stageTab: 'stage-DEMO',
                    stageName: 'DEMO / SYNC',
                    color: const Color(0xFF8B5CF6),
                    icon: Icons.sync_rounded,
                    isDark: isDark,
                  ),
                  _buildSubTabItem(
                    label: 'Proposal Sent',
                    stageTab: 'stage-PROPOSAL',
                    stageName: 'PROPOSAL',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.description_outlined,
                    isDark: isDark,
                  ),
                  _buildSubTabItem(
                    label: 'Negotiation',
                    stageTab: 'stage-NEGOTIATION',
                    stageName: 'NEGOTIATION',
                    color: const Color(0xFF06B6D4),
                    icon: Icons.handshake_outlined,
                    isDark: isDark,
                  ),
                  _buildSubTabItem(
                    label: 'Confirmed / Won',
                    stageTab: 'stage-CONFIRMED',
                    stageName: 'CONFIRMED',
                    color: const Color(0xFF10B981),
                    icon: Icons.emoji_events_outlined,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            
          _SidebarItemWidget(
            icon: Icons.toys_outlined,
            label: 'AI Playground',
            isActive: widget.activeTab == 'ai-playground',
            badge: _buildBadgePill('NEW', const Color(0xFFFFECE7), const Color(0xFFFF3377)),
            onTap: () => widget.onTabChanged('ai-playground'),
          ),
          _SidebarItemWidget(
            icon: Icons.folder_open_rounded,
            label: 'My Assets',
            isActive: widget.activeTab == 'leads',
            badge: _buildBadgePill('3', const Color(0xFFFFECE7), const Color(0xFFFF523B)),
            onTap: () => widget.onTabChanged('leads'),
          ),
          _SidebarItemWidget(
            icon: Icons.assignment_outlined,
            label: 'Tasks',
            isActive: widget.activeTab == 'tasks',
            badge: _buildBadgePill('4 NEW', const Color(0xFFFFECE7), const Color(0xFFFF3377)),
            onTap: () => widget.onTabChanged('tasks'),
          ),
          _SidebarItemWidget(
            icon: Icons.people_outline_rounded,
            label: 'Members',
            isActive: widget.activeTab == 'team',
            badge: _buildBadgePill('3', const Color(0xFFEFF6FF), const Color(0xFF3B82F6)),
            onTap: () => widget.onTabChanged('team'),
          ),
          _SidebarItemWidget(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            isActive: widget.activeTab == 'chat',
            badge: _buildBadgePill('NEW', const Color(0xFFFFECE7), const Color(0xFFFF3377)),
            onTap: () {
              playTukTukSound();
              final state = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
              if (state != null) {
                state.setState(() {
                  state._chatInitialMemberName = null;
                });
              }
              widget.onTabChanged('chat');
            },
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'GENERAL',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _SidebarItemWidget(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isActive: widget.activeTab == 'settings',
            onTap: () => widget.onTabChanged('settings'),
          ),
          _SidebarItemWidget(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            isActive: widget.activeTab == 'help',
            onTap: () => widget.onTabChanged('help'),
          ),
                ],
              ),
            ),
          ),

          // 4. Premium Upgrade Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF7000FF).withValues(alpha: 0.15),
                          const Color(0xFFFF3377).withValues(alpha: 0.08),
                        ]
                      : [
                          const Color(0xFF7000FF).withValues(alpha: 0.08),
                          const Color(0xFFFF3377).withValues(alpha: 0.04),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFFF3377).withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF3377), Color(0xFFFF523B)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3377).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.emoji_events_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upgrade to Pro!',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unlock Special Autopilot & Save 40%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3377),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    child: const Text(
                      'Upgrade premium',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Account Profile Section Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFEEF2FF),
                  foregroundImage: const NetworkImage('https://i.pravatar.cc/150?u=dwayne'),
                  child: const Text('DT', style: TextStyle(fontSize: 10, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dwayne Tatum',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'CEO Assistant',
                        style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 10),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout_rounded, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgePill(String label, Color bg, Color text, {bool isPulsing = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPulsing) ...[
            const _PulseDot(color: Color(0xFF10B981)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem({
    required String label,
    required String stageTab,
    required String stageName,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    final bool isActive = widget.activeTab == stageTab;
    final int count = widget.pipelineLeads.where((l) => l['status'] == stageName).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            playTukTukSound();
            widget.onTabChanged(stageTab);
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: color.withOpacity(0.2))
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(icon, color: isActive ? color : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)), size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? (isDark ? Colors.white : const Color(0xFF0F172A)) : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? color.withOpacity(0.12) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isActive ? color : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItemWidget extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Widget? badge;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SidebarItemWidget({
    required this.icon,
    required this.label,
    required this.isActive,
    this.badge,
    this.trailing,
    required this.onTap,
  });

  @override
  State<_SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends State<_SidebarItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered && !widget.isActive ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: widget.isActive
                      ? (isDark
                          ? const LinearGradient(
                              colors: [Color(0xFF334155), Color(0xFF1E293B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFFFECE7), Color(0xFFFFF2EF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ))
                      : null,
                  color: widget.isActive
                      ? null
                      : (_isHovered
                          ? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(14),
                  border: widget.isActive
                      ? Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFFF3377).withValues(alpha: 0.15))
                      : Border.all(color: Colors.transparent),
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: isDark ? Colors.black26 : const Color(0xFFFF3377).withValues(alpha: 0.05),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.isActive
                          ? const Color(0xFFFF3377)
                          : (_isHovered ? (isDark ? Colors.white : const Color(0xFF0F172A)) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          if (widget.isActive) ...[
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF3377),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            widget.label,
                            style: TextStyle(
                              color: widget.isActive
                                  ? const Color(0xFFFF3377)
                                  : (_isHovered ? (isDark ? Colors.white : const Color(0xFF0F172A)) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                              fontSize: 13,
                              fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.badge != null) widget.badge!,
                    if (widget.trailing != null) ...[
                      const SizedBox(width: 8),
                      widget.trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Micro-pulsing active indicator dot
class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ==================== HEADER BAR ====================
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Row(
      children: [
        // Spotlight Search Bar (Clickable container triggering blur search overlay)
        InkWell(
          onTap: () {
            if (dashboardState != null) {
              dashboardState._triggerGlobalSearch();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 320,
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search leads or tasks...',
                    style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '⌘ F',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        const _HoverIconBtn(icon: Icons.chat_bubble_outline_rounded),
        const SizedBox(width: 16),
        const _HoverIconBtn(icon: Icons.notifications_none_rounded, hasBadge: true),
        const SizedBox(width: 20),
        const _HoverLanguageBtn(),
        const SizedBox(width: 16),
        _HoverIconBtn(
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          onTap: () {
            if (dashboardState != null) {
              dashboardState.setState(() {
                dashboardState._isDarkMode = !dashboardState._isDarkMode;
              });
            }
          },
        ),
        const SizedBox(width: 24),
        const _HoverProfileCard(),
      ],
    );
  }
}

// Stateful hover-reactive chat/notifications action buttons
class _HoverIconBtn extends StatefulWidget {
  final IconData icon;
  final bool hasBadge;
  final VoidCallback? onTap;

  const _HoverIconBtn({
    required this.icon,
    this.hasBadge = false,
    this.onTap,
  });

  @override
  State<_HoverIconBtn> createState() => _HoverIconBtnState();
}

class _HoverIconBtnState extends State<_HoverIconBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          playTukTukSound();
          if (widget.onTap != null) widget.onTap!();
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isHovered ? const Color(0xFFFF523B).withValues(alpha: 0.3) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: 1,
                  ),
                  boxShadow: [
                    if (_isHovered)
                      BoxShadow(
                        color: const Color(0xFFFF523B).withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? const Color(0xFFFF523B) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  size: 20,
                ),
              ),
              if (widget.hasBadge)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF523B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateful hover-reactive language switcher button
class _HoverLanguageBtn extends StatefulWidget {
  const _HoverLanguageBtn();

  @override
  State<_HoverLanguageBtn> createState() => _HoverLanguageBtnState();
}

class _HoverLanguageBtnState extends State<_HoverLanguageBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? const Color(0xFF4F46E5).withValues(alpha: 0.3) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  width: 18,
                  height: 18,
                  color: const Color(0xFF0F172A),
                  child: Row(
                    children: [
                      Container(width: 9, color: Colors.blue.shade900),
                      Container(width: 9, color: Colors.red),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'EN',
                style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white54 : const Color(0xFF64748B), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateful hover-reactive profile card component
class _HoverProfileCard extends StatefulWidget {
  const _HoverProfileCard();

  @override
  State<_HoverProfileCard> createState() => _HoverProfileCardState();
}

class _HoverProfileCardState extends State<_HoverProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9).withOpacity(0.8))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isHovered ? const Color(0xFF4F46E5) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  width: 1.5,
                ),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=dwayne'),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dwayne Tatum',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: _isHovered ? FontWeight.w800 : FontWeight.bold,
                  ),
                ),
                Text(
                  'CEO Assistant',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful fuzzy Spotlight Search dialog card
class _SearchOverlayDialog extends StatefulWidget {
  final List<Map<String, String>> pipelineLeads;
  final List<Map<String, dynamic>> tasksList;
  final ValueChanged<Map<String, String>> onLeadSelected;
  final ValueChanged<Map<String, dynamic>> onTaskSelected;

  const _SearchOverlayDialog({
    required this.pipelineLeads,
    required this.tasksList,
    required this.onLeadSelected,
    required this.onTaskSelected,
  });

  @override
  State<_SearchOverlayDialog> createState() => _SearchOverlayDialogState();
}

class _SearchOverlayDialogState extends State<_SearchOverlayDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, String>> _filteredLeads = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredLeads = [];
        _filteredTasks = [];
        _hasSearched = false;
      });
      return;
    }

    final matchedLeads = widget.pipelineLeads.where((lead) {
      final name = (lead['name'] ?? '').toLowerCase();
      final company = (lead['company'] ?? '').toLowerCase();
      final req = (lead['req'] ?? '').toLowerCase();
      final location = (lead['location'] ?? '').toLowerCase();
      return name.contains(query) || company.contains(query) || req.contains(query) || location.contains(query);
    }).toList();

    final matchedTasks = widget.tasksList.where((task) {
      final title = (task['title'] ?? '').toLowerCase();
      final tag = (task['tag'] ?? '').toLowerCase();
      return title.contains(query) || tag.contains(query);
    }).toList();

    setState(() {
      _filteredLeads = matchedLeads;
      _filteredTasks = matchedTasks;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Input Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF4F46E5), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: 'Search leads, companies, requirements, or tasks...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.normal),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
                      onPressed: () => _searchController.clear(),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            
            // Search Results area
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildResultsContent(),
              ),
            ),
            
            // Footer Guide
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FC),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  const Text(
                    'Tip: Use keyboard search. Press ESC to cancel.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'ESC',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsContent() {
    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_rounded, size: 36, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Spotlight Search Active',
                style: TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Type name, company, scope or task to begin...',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredLeads.isEmpty && _filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFFFF523B)),
              ),
              const SizedBox(height: 16),
              Text(
                'No results for "${_searchController.text}"',
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Check spelling or try searching for another term.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    int animIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_filteredLeads.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'LEADS RESULTS',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ),
          ..._filteredLeads.map((lead) {
            final idx = animIndex++;
            return _AnimatedResultItem(
              index: idx,
              child: _buildLeadResultRow(lead),
            );
          }),
          const SizedBox(height: 16),
        ],
        if (_filteredTasks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'TASKS RESULTS',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ),
          ..._filteredTasks.map((task) {
            final idx = animIndex++;
            return _AnimatedResultItem(
              index: idx,
              child: _buildTaskResultRow(task),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildLeadResultRow(Map<String, String> lead) {
    final status = lead['status'] ?? 'NEW';
    final statusColor = status == 'CONFIRMED'
        ? const Color(0xFF10B981)
        : (status == 'NEW' ? const Color(0xFFFF523B) : const Color(0xFF4F46E5));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.onLeadSelected(lead);
          },
          borderRadius: BorderRadius.circular(16),
          hoverColor: const Color(0xFFF1F5F9),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                // Circular gradient icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead['name'] ?? '',
                        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${lead['company'] ?? 'Enterprise'} • ${lead['req'] ?? 'Scope'}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lead['val'] ?? '₹0',
                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskResultRow(Map<String, dynamic> task) {
    final priority = task['priority'] ?? '3';
    final priColor = priority == '1'
        ? const Color(0xFFFF523B)
        : (priority == '2' ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.onTaskSelected(task);
          },
          borderRadius: BorderRadius.circular(16),
          hoverColor: const Color(0xFFF1F5F9),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                // Circular gradient icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF523B), Color(0xFFFF8B7B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.assignment_outlined, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'] ?? '',
                        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tag: ${task['tag'] ?? 'Sprint'}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: priColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Priority $priority',
                        style: TextStyle(color: priColor, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task['status'] ?? 'Backlog',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedResultItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedResultItem({
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 250 + (index * 40)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1.0 - value) * 12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ==================== HEADING SECTION ====================
class _AnalyticsHeading extends StatelessWidget {
  const _AnalyticsHeading();

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRM Pipeline Dashboard',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Track lead velocity, conversion trends, channel performance, and pipeline worth in real-time.',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: const Text('Export Report'),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined, size: 18),
          label: const Text('Share View'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF523B),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// ==================== METRICS GRID ====================
class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.7,
      children: const [
        _MetricCard(
          title: 'Active Leads Intake',
          value: '1,428',
          growth: '+12%',
          color: Color(0xFFEFF6FF),
          iconColor: Color(0xFF2563EB),
          icon: Icons.inbox_rounded,
        ),
        _MetricCard(
          title: 'Contacted Outbound',
          value: '892',
          growth: '+8%',
          color: Color(0xFFF5F3FF),
          iconColor: Color(0xFF7C3AED),
          icon: Icons.phone_in_talk_rounded,
        ),
        _MetricCard(
          title: 'Total Pipeline Worth',
          value: '₹48.6L',
          growth: '+15%',
          color: Color(0xFFECFDF5),
          iconColor: Color(0xFF059669),
          icon: Icons.monetization_on_outlined,
        ),
        _MetricCard(
          title: 'Average Win Rate',
          value: '24.8%',
          growth: '+4%',
          color: Color(0xFFFFF7ED),
          iconColor: Color(0xFFD97706),
          icon: Icons.handshake_rounded,
        ),
      ],
    );
  }
}


class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String growth;
  final Color color;
  final Color iconColor;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.growth,
    required this.color,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  iconColor.withValues(alpha: 0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.white,
                  iconColor.withValues(alpha: 0.14),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: isDark ? 0.04 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? iconColor.withOpacity(0.12) : color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isDark ? iconColor.withOpacity(0.9) : iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x1F10B981) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'from last month',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ==================== NEW LEADS CAROUSEL WIDGET ====================
class _LeadsCarouselWidget extends StatefulWidget {
  final VoidCallback onViewAll;
  final Function(String tab, String? leadName) onNavigate;
  const _LeadsCarouselWidget({super.key, required this.onViewAll, required this.onNavigate});

  @override
  State<_LeadsCarouselWidget> createState() => _LeadsCarouselWidgetState();
}

class _LeadsCarouselWidgetState extends State<_LeadsCarouselWidget> {
  String _selectedSection = 'new'; // 'new', 'today', 'confirm'

  final List<Map<String, String>> _newLeads = [
    {
      'id': 'lead_c1',
      'name': 'Mudhu Naz',
      'company': 'CreativeHQ',
      'val': '₹2,50,000',
      'req': 'UI Design',
      'temp': 'Hot',
      'phone': '+91 98765 43210',
      'email': 'mudhu@creativehq.com',
      'location': 'Mumbai, IN',
      'notes': 'Requires an Obsidian styled Dark mode UI Kit with scalloped elements.',
      'linkedin': 'linkedin.com/in/mudhu-naz',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Mudhu',
      'status': 'NEW',
      'time': '7:23 PM',
    },
    {
      'id': 'lead_c2',
      'name': 'Alex Rivera',
      'company': 'TechFlow Inc.',
      'val': '₹5,80,000',
      'req': 'Custom Software',
      'temp': 'Warm',
      'phone': '+1 (555) 432-1098',
      'email': 'alex@techflow.io',
      'location': 'San Francisco, US',
      'notes': 'Requested direct CRM sync using REST endpoints and high throughput queues.',
      'linkedin': 'linkedin.com/in/alexrivera',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Alex',
      'status': 'NEW',
      'time': '5:45 PM',
    },
    {
      'id': 'lead_c3',
      'name': 'Sarah Chen',
      'company': 'Global Media',
      'val': '₹3,20,000',
      'req': 'Web Platform',
      'temp': 'Cold',
      'phone': '+852 9123 4567',
      'email': 'sarah@globalmedia.co',
      'location': 'Hong Kong, HK',
      'notes': 'Goal: Scalable Content Delivery System with integrated payment portals.',
      'linkedin': 'linkedin.com/in/sarah-chen',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Sarah',
      'status': 'NEW',
      'time': '4:20 PM',
    },
    {
      'id': 'lead_c3_alt1',
      'name': 'Michael Jordan',
      'company': 'Nike Brand Co',
      'val': '₹9,80,000',
      'req': 'Store Customizer',
      'temp': 'Hot',
      'phone': '+1 (555) 234-5678',
      'email': 'jordan@nike.com',
      'location': 'Chicago, US',
      'notes': 'Needs rich interactive customization systems for shoe builder portal.',
      'linkedin': 'linkedin.com/in/michaeljordan',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Michael',
      'status': 'NEW',
      'time': '3:10 PM',
    },
    {
      'id': 'lead_c3_alt2',
      'name': 'Jessica Alba',
      'company': 'Honest Corp',
      'val': '₹4,50,000',
      'req': 'Shopify Theme',
      'temp': 'Warm',
      'phone': '+1 (555) 876-5432',
      'email': 'jessica@honest.com',
      'location': 'Los Angeles, US',
      'notes': 'Needs organic color themes and premium scalloped header elements.',
      'linkedin': 'linkedin.com/in/jessicaalba',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Jessica',
      'status': 'NEW',
      'time': '2:15 PM',
    },
  ];

  final List<Map<String, String>> _todaysLeads = [
    {
      'id': 'lead_c4',
      'name': 'Vikram Malhotra',
      'company': 'Apex Logistics',
      'val': '₹8,50,000',
      'req': 'Supply CRM',
      'temp': 'Hot',
      'phone': '+91 99887 76655',
      'email': 'vikram@apexlogistics.com',
      'location': 'Delhi, IN',
      'notes': 'Looking for an AI driven routing software for cargo logistics pipeline.',
      'linkedin': 'linkedin.com/in/vikram-malhotra',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Vikram',
      'status': 'NEW',
      'time': '2 hours ago',
    },
    {
      'id': 'lead_c5',
      'name': 'Elena Rostova',
      'company': 'Mirage Games',
      'val': '₹12,40,000',
      'req': 'Analytics SDK',
      'temp': 'Hot',
      'phone': '+358 40 1234567',
      'email': 'elena@miragegames.fi',
      'location': 'Helsinki, FI',
      'notes': 'Needs high performance gameplay metrics syncing directly into core CRM dashboard.',
      'linkedin': 'linkedin.com/in/elena-rostova',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Elena',
      'status': 'NEW',
      'time': '4 hours ago',
    },
    {
      'id': 'lead_c6',
      'name': 'David Kim',
      'company': 'K-Food Group',
      'val': '₹4,10,000',
      'req': 'Mobile Apps',
      'temp': 'Warm',
      'phone': '+82 10 9876 5432',
      'email': 'david@kfood.co.kr',
      'location': 'Seoul, KR',
      'notes': 'Ecommerce ordering apps integration with auto-lead generation from Instagram DMs.',
      'linkedin': 'linkedin.com/in/david-kim',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=David',
      'status': 'NEW',
      'time': '6 hours ago',
    },
    {
      'id': 'lead_c6_alt1',
      'name': 'Oliver Twist',
      'company': 'Victorian Pubs',
      'val': '₹2,90,000',
      'req': 'POS Redesign',
      'temp': 'Cold',
      'phone': '+44 20 7946 0958',
      'email': 'oliver@victorianpubs.co.uk',
      'location': 'London, UK',
      'notes': 'Legacy touch terminals UI enhancement with simple clear layouts.',
      'linkedin': 'linkedin.com/in/olivertwist',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Oliver',
      'status': 'NEW',
      'time': '8 hours ago',
    },
    {
      'id': 'lead_c6_alt2',
      'name': 'Aria Montgomery',
      'company': 'Rosewood Labs',
      'val': '₹6,70,000',
      'req': 'LIMS Software',
      'temp': 'Hot',
      'phone': '+1 (555) 301-4920',
      'email': 'aria@rosewoodlabs.org',
      'location': 'Rosewood, US',
      'notes': 'Custom portal to schedule laboratory pipeline audits and generate PDFs.',
      'linkedin': 'linkedin.com/in/ariamontgomery',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Aria',
      'status': 'NEW',
      'time': '9 hours ago',
    },
  ];

  final List<Map<String, String>> _aboutToConfirmLeads = [
    {
      'id': 'lead_c7',
      'name': 'Rajesh Sharma',
      'company': 'Shanti Motors',
      'val': '₹18,50,000',
      'req': 'Dealer Portal',
      'temp': 'Hot',
      'phone': '+91 91234 56789',
      'email': 'rajesh@shantimotors.com',
      'location': 'Mumbai, IN',
      'notes': 'Finalized legal contract drafts. Awaiting director signature check on final pricing list.',
      'linkedin': 'linkedin.com/in/rajesh-sharma',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Rajesh',
      'status': 'NEGOTIATION',
      'time': 'Negotiation Stage',
    },
    {
      'id': 'lead_c8',
      'name': 'Sophie Dubois',
      'company': 'Paris Atelier',
      'val': '₹6,20,000',
      'req': 'Web Rebrand',
      'temp': 'Hot',
      'phone': '+33 6 1234 5678',
      'email': 'sophie@parisatelier.fr',
      'location': 'Paris, FR',
      'notes': 'Proposal accepted. Setting up kickoff call for next Monday. Payment structures finalized.',
      'linkedin': 'linkedin.com/in/sophie-dubois',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Sophie',
      'status': 'PROPOSAL',
      'time': 'Proposal Accepted',
    },
    {
      'id': 'lead_c9',
      'name': 'Marcus Vance',
      'company': 'Vance Capital',
      'val': '₹15,00,000',
      'req': 'Investor CRM',
      'temp': 'Warm',
      'phone': '+1 (555) 789-0123',
      'email': 'marcus@vancecap.com',
      'location': 'New York, US',
      'notes': 'Security review completed. Awaiting escrow setup and enterprise agreement verification.',
      'linkedin': 'linkedin.com/in/marcus-vance',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Marcus',
      'status': 'NEGOTIATION',
      'time': 'Security Review',
    },
    {
      'id': 'lead_c9_alt1',
      'name': 'Naomi Watts',
      'company': 'Lighthouse Media',
      'val': '₹7,50,000',
      'req': 'Ad Tech Engine',
      'temp': 'Hot',
      'phone': '+61 2 9876 5432',
      'email': 'naomi@lighthouse.com.au',
      'location': 'Sydney, AU',
      'notes': 'Integration contract is drafted and ready for review. Retainer payment confirmed.',
      'linkedin': 'linkedin.com/in/naomiwatts',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Naomi',
      'status': 'PROPOSAL',
      'time': 'Awaiting Retainer',
    },
    {
      'id': 'lead_c9_alt2',
      'name': 'Bruce Wayne',
      'company': 'Wayne Enterprises',
      'val': '₹85,00,000',
      'req': 'Defense Dashboard',
      'temp': 'Hot',
      'phone': '+1 (555) 999-8888',
      'email': 'bruce@waynecorp.com',
      'location': 'Gotham, US',
      'notes': 'Encrypted secure channel dashboard finalized. Signing contract tonight.',
      'linkedin': 'linkedin.com/in/brucewayne',
      'avatar': 'https://api.dicebear.com/7.x/adventurer/png?seed=Bruce',
      'status': 'NEGOTIATION',
      'time': 'Contract Review',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    List<Map<String, String>> currentLeads = _newLeads;
    if (_selectedSection == 'today') {
      currentLeads = _todaysLeads;
    } else if (_selectedSection == 'confirm') {
      currentLeads = _aboutToConfirmLeads;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16, right: 4),
          child: Row(
            children: [
              const Icon(Icons.style_outlined, color: Color(0xFFFF523B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Lead Intake & Activity Portal',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 32),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabButton('New Intake', 'new', isDark),
                    _buildTabButton("Today's Leads", 'today', isDark),
                    _buildTabButton('About to Confirm', 'confirm', isDark),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onViewAll,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFFFF523B)),
                label: const Text(
                  'View All Leads',
                  style: TextStyle(
                    color: Color(0xFFFF523B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 350,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: currentLeads.map((lead) {
                final String temp = lead['temp'] ?? 'Hot';
                final Color stageColor = temp == 'Hot'
                    ? const Color(0xFFFF523B)
                    : (temp == 'Warm' ? const Color(0xFFF59E0B) : const Color(0xFF2563EB));
                
                return Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 16, bottom: 8),
                  child: HoverableLeadCard(
                    lead: lead,
                    stageColor: stageColor,
                    child: _buildCarouselLeadCard(context, lead, stageColor, isDark),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, String value, bool isDark) {
    final isSelected = _selectedSection == value;
    return InkWell(
      onTap: () {
        playTukTukSound();
        setState(() {
          _selectedSection = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? const Color(0xFF334155) : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselLeadCard(BuildContext context, Map<String, String> lead, Color stageColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF334155) : stageColor.withValues(alpha: 0.10), width: 1.0),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.95),
                  blurRadius: 0,
                  offset: const Offset(0, -2),
                ),
                BoxShadow(
                  color: stageColor.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: stageColor.withValues(alpha: 0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: stageColor.withValues(alpha: 0.01),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Section Stack (Banner, Avatar, Scope Pill)
            SizedBox(
              height: 75,
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            stageColor,
                            stageColor.withValues(alpha: 0.7),
                            const Color(0xFFFF523B).withValues(alpha: 0.7),
                            const Color(0xFFF59E0B).withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        backgroundImage: NetworkImage(lead['avatar'] ?? ''),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: isDark ? Border.all(color: const Color(0xFF475569)) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        lead['req'] ?? 'Project Scope',
                        style: TextStyle(
                          color: isDark ? Colors.white : stageColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 2. Info Details
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lead['company'] ?? 'Enterprise Client',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lead['val'] ?? '₹0',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 11, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(
                            lead['time'] ?? 'Just Now',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBadge(Icons.phone_outlined, lead['phone'] ?? '', isDark),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBadge(Icons.location_on_outlined, lead['location'] ?? '', isDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 3. Dark Gradient Bottom Action Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark ? [const Color(0xFF0F172A), const Color(0xFF0F172A)] : [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStageCardActionButton(
                    tooltip: 'WhatsApp Thread',
                    icon: Icons.message_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () {
                      playTukTukSound();
                      _showToast(context, "Initiating secure WhatsApp thread with ${lead['name']}... 💬");
                    },
                  ),
                  _buildStageCardActionButton(
                    tooltip: 'VoIP Call',
                    icon: Icons.phone_rounded,
                    color: const Color(0xFF60A5FA),
                    onTap: () {
                      playTukTukSound();
                      _showToast(context, "Connecting VoIP call to ${lead['phone']}... 📞");
                    },
                  ),
                  _buildStageCardActionButton(
                    tooltip: 'SMS Dispatch',
                    icon: Icons.sms_outlined,
                    color: const Color(0xFFFB923C),
                    onTap: () {
                      playTukTukSound();
                      _showToast(context, "Drafting SMS dispatch for ${lead['name']}... ✉️");
                    },
                  ),
                  _buildStageCardActionButton(
                    tooltip: 'AI Follow-up',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFA78BFA),
                    onTap: () {
                      widget.onNavigate('ai-playground', lead['name']);
                      _showToast(context, "AI Copilot loaded for ${lead['name']}! Opening templates... ⚡");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFFFF6A47)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCardActionButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          hoverColor: color.withValues(alpha: 0.08),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF523B),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message),
      ),
    );
  }

  void _showConsultationDialog(BuildContext context, Map<String, String> lead) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CyberLim Consultation',
                    style: TextStyle(color: Color(0xFFFF6A47), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE2E8F0), height: 24),
              Text(
                'Consulting Client: ${lead['name']}',
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Company: ${lead['company'] ?? "Self-Employed"}',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'UNIVERSAL CLIENT FLOW STATUS',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
              const SizedBox(height: 12),
              _buildFlowCheck('Step 1: Introduction Completed', true),
              _buildFlowCheck('Step 2: Goals & Requirements collection', true),
              _buildFlowCheck('Step 3: Schedule discovery session', false),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF523B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Launch Strategy Session', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowCheck(String label, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isDone ? const Color(0xFFFF6A47) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isDone ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CHARTS ROW ====================
class _ChartsRow extends StatelessWidget {
  const _ChartsRow();

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Row(
      children: [
        // 1. Lead Intake Trend
        Expanded(
          flex: 2,
          child: Container(
            height: 340,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lead Intake Trend',
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildDropdown('6 Month', isDark),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMockBar('Jan', 70, isDark),
                    _buildMockBar('Feb', 100, isDark),
                    _buildMockBarWithTooltip('Mar', 190, isDark),
                    _buildMockBar('Apr', 120, isDark),
                    _buildMockBar('May', 80, isDark),
                    _buildMockBar('Jun', 140, isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // 2. Lead Quality Insights
        Expanded(
          flex: 2,
          child: Container(
            height: 340,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lead Quality Insights',
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildDropdown('Week', isDark),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColoredBar('Enterprise', 110, const Color(0xFF7C3AED), '35%', isDark),
                    _buildColoredBar('Mid-Market', 160, const Color(0xFFFF523B), '50%', isDark),
                    _buildColoredBar('SMB', 60, const Color(0xFF059669), '18%', isDark),
                    _buildColoredBar('Self-Serve', 25, const Color(0xFF2563EB), '7%', isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // 3. Lead Temperature Donut
        Expanded(
          flex: 2,
          child: Container(
            height: 340,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lead Temperature',
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.more_horiz, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8)),
                  ],
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: CustomPaint(
                      painter: _SentimentDonutPainter(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '100%',
                              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            const Text(
                              'Total Leads',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                _buildSentimentRow('Hot Leads', '72%', const Color(0xFFFF523B), isDark),
                const SizedBox(height: 6),
                _buildSentimentRow('Warm Leads', '20%', const Color(0xFFD97706), isDark),
                const SizedBox(height: 6),
                _buildSentimentRow('Cold Leads', '8%', const Color(0xFF2563EB), isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String active, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            active,
            style: TextStyle(
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 14, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
        ],
      ),
    );
  }

  Widget _buildMockBar(String label, double height, bool isDark) {
    return Column(
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
      ],
    );
  }

  Widget _buildMockBarWithTooltip(String label, double height, bool isDark) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8E75), Color(0xFFFF523B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Positioned(
          top: -65,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isDark ? Border.all(color: const Color(0xFF475569)) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'March',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFFFF523B), size: 6),
                    const SizedBox(width: 4),
                    Text(
                      'New Leads: 154',
                      style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 9),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFFCBD5E1), size: 6),
                    const SizedBox(width: 4),
                    Text(
                      'Won Deals: 38',
                      style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColoredBar(String label, double height, Color color, String percentage, bool isDark) {
    return Column(
      children: [
        Text(percentage, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
      ],
    );
  }

  Widget _buildSentimentRow(String label, String value, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 12),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Donut Sentiment Painter
class _SentimentDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.28;

    final paintOrange = Paint()
      ..color = const Color(0xFFFF523B)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintGreen = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintBlue = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    canvas.drawArc(rect, -math.pi / 2, 2.0 * math.pi * 0.72, false, paintOrange);
    canvas.drawArc(rect, -math.pi / 2 + 2.0 * math.pi * 0.72, 2.0 * math.pi * 0.20, false, paintGreen);
    canvas.drawArc(rect, -math.pi / 2 + 2.0 * math.pi * 0.92, 2.0 * math.pi * 0.08, false, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== BOTTOM GRID ====================
class _BottomGrid extends StatelessWidget {
  const _BottomGrid();

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Acquisition Channel Performance
        Expanded(
          flex: 4,
          child: Container(
            height: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Acquisition Channel Performance',
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildDropdown('This Month', isDark),
                  ],
                ),
                const SizedBox(height: 20),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.6),
                    1: FlexColumnWidth(0.9),
                    2: FlexColumnWidth(1.0),
                    3: FlexColumnWidth(1.1),
                    4: FlexColumnWidth(0.9),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Channel', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Leads', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Conversions', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Pipeline Worth', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Growth', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    _buildTableRow('LinkedIn Outreach', '542', '128', '₹18.4L', '+12%', const Color(0xFF0A66C2), isDark),
                    _buildTableRow('Google Inbound', '380', '92', '₹15.2L', '+9%', const Color(0xFFEA4335), isDark),
                    _buildTableRow('Partner Referral', '120', '48', '₹10.5L', '+15%', const Color(0xFF059669), isDark),
                    _buildTableRow('Email Campaigns', '386', '52', '₹4.5L', '+3%', const Color(0xFFFF9F43), isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // 2. Lead Interaction Heatmap
        Expanded(
          flex: 3,
          child: Container(
            height: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lead Interaction Heatmap',
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildDropdown('Today', isDark),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 32),
                        _buildTimeLabel('12am'),
                        _buildTimeLabel('3am'),
                        _buildTimeLabel('6am'),
                        _buildTimeLabel('9am'),
                        _buildTimeLabel('12pm'),
                        _buildTimeLabel('3pm'),
                        _buildTimeLabel('6pm'),
                        _buildTimeLabel('9pm'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _buildHeatmapRow('Sun', [1, 2, 2, 4, 3, 2, 1, 1], isDark),
                    _buildHeatmapRow('Mon', [2, 1, 2, 3, 4, 5, 3, 2], isDark),
                    _buildHeatmapRow('Tue', [1, 1, 4, 3, 2, 5, 4, 2], isDark),
                    _buildHeatmapRow('Wed', [3, 2, 2, 4, 5, 4, 2, 1], isDark),
                    _buildHeatmapRow('Thu', [2, 1, 3, 4, 3, 2, 5, 2], isDark),
                    _buildHeatmapRow('Fri', [2, 2, 4, 5, 4, 3, 2, 1], isDark),
                    _buildHeatmapRow('Sat', [1, 1, 2, 2, 3, 4, 2, 1], isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String active, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            active,
            style: TextStyle(
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 14, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String platform, String followers, String engagement, String reach, String growth, Color color, bool isDark) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(
                    platform[0],
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                platform,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            followers,
            style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            engagement,
            style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            reach,
            style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.arrow_upward, color: Color(0xFF059669), size: 12),
              const SizedBox(width: 4),
              Text(
                growth,
                style: const TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLabel(String time) {
    return Text(time, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10));
  }

  Widget _buildHeatmapRow(String day, List<int> values, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              day,
              style: TextStyle(
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...values.map((v) => _buildHeatmapBlock(v, isDark)),
        ],
      ),
    );
  }

  Widget _buildHeatmapBlock(int intensity, bool isDark) {
    Color blockColor;
    if (isDark) {
      switch (intensity) {
        case 1:
          blockColor = const Color(0xFF334155);
        case 2:
          blockColor = const Color(0xFFFF523B).withValues(alpha: 0.2);
        case 3:
          blockColor = const Color(0xFFFF523B).withValues(alpha: 0.45);
        case 4:
          blockColor = const Color(0xFFFF523B).withValues(alpha: 0.7);
        case 5:
          blockColor = const Color(0xFFFF523B);
        default:
          blockColor = const Color(0xFF334155);
      }
    } else {
      switch (intensity) {
        case 1:
          blockColor = const Color(0xFFFFECE7);
        case 2:
          blockColor = const Color(0xFFFFD1C3);
        case 3:
          blockColor = const Color(0xFFFFAB95);
        case 4:
          blockColor = const Color(0xFFFF8E75);
        case 5:
          blockColor = const Color(0xFFFF523B);
        default:
          blockColor = const Color(0xFFFFECE7);
      }
    }
    return Expanded(
      child: Container(
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          color: blockColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ==================== PREMIUM RIGHT SIDEBAR UTILITY PANEL ====================
class _RightSidebarWidget extends StatelessWidget {
  const _RightSidebarWidget();

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          left: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 0. Autoplaying story video reel at the top with bottom white/dark fade
          const _SidebarVideoWidget(),

          // 1. Live Premium Scalloped Analog Clock & Calendar Widget
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: _ScallopedAnalogCalendarWidget(),
          ),
          Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),

          // 2. Custom Interactive CRM Panels
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _NotificationStackWidget(),
                  const SizedBox(height: 28),
                  const _TodaysLeadsSidebarCarouselWidget(),
                  const SizedBox(height: 28),
                  _FloatingNotesActionsWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// isolately stateful real-time clock widget

// Custom Premium Scalloped Analog Clock + Micro Calendar Widget (inspired by Widgeet - Dark Theme)
class _ScallopedAnalogCalendarWidget extends StatefulWidget {
  const _ScallopedAnalogCalendarWidget();

  @override
  State<_ScallopedAnalogCalendarWidget> createState() => _ScallopedAnalogCalendarWidgetState();
}

class _ScallopedAnalogCalendarWidgetState extends State<_ScallopedAnalogCalendarWidget> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    // 50ms interval drives a highly realistic, super-premium automatic sweep second hand (like a mechanical luxury watch!)
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;
    final today = _currentTime.day;
    final year = _currentTime.year;
    final monthName = _getMonthName(_currentTime.month);

    // Dynamic grid calculation for current month
    final firstDayOfMonth = DateTime(_currentTime.year, _currentTime.month, 1);
    final totalDays = DateTime(_currentTime.year, _currentTime.month + 1, 0).day;
    
    // Shift index so 1 is Monday, 7 is Sunday
    final startWeekday = firstDayOfMonth.weekday; // 1 = Monday, ..., 7 = Sunday
    
    final List<String> daysList = [];
    // Add empty placeholders before day 1 to align with correct weekday columns
    for (int i = 1; i < startWeekday; i++) {
      daysList.add('');
    }
    for (int i = 1; i <= totalDays; i++) {
      daysList.add(i.toString());
    }

    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF180A1A), Color(0xFF0C030E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFFFF3377).withValues(alpha: 0.16) : const Color(0xFFFF3377).withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3377).withValues(alpha: isDark ? 0.08 : 0.12),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Micro high-density Calendar showing Month/Year and current date highlighted with pulsing neon pink gradient
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    '${monthName.toLowerCase()}/$year',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'serif', // Serif styling for gorgeous editorial look matching the image!
                      shadows: isDark
                          ? const [
                              Shadow(color: Color(0xFFFF3377), blurRadius: 4),
                            ]
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Weekdays headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((d) => SizedBox(
                    width: 14,
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569), // Sleek slate gray
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 4),
                // Grid of dates
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 1,
                  ),
                  itemCount: daysList.length,
                  itemBuilder: (context, idx) {
                    final dayVal = daysList[idx];
                    if (dayVal == '') return const SizedBox.shrink();
                    final isToday = int.tryParse(dayVal) == today;

                    return Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isToday
                              ? const LinearGradient(
                                  colors: [Color(0xFFFF3377), Color(0xFFFF523B)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          boxShadow: isToday
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFFF3377).withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            dayVal,
                            style: TextStyle(
                              color: isToday ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                              fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right: Premium mechanical-sweep scalloped analog clock (Dark theme contoured)
          SizedBox(
            width: 124,
            height: 124,
            child: CustomPaint(
              painter: _ScallopedAnalogClockPainter(
                time: _currentTime,
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month - 1];
  }
}

// Scalloped Dial Painter for Automatic Mechanical Analog Clock face
class _ScallopedAnalogClockPainter extends CustomPainter {
  final DateTime time;
  final bool isDark;
  _ScallopedAnalogClockPainter({required this.time, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 6;
    final amplitude = 3.5;
    final numScallops = 12; // 12 perfect scallops align mathematically with the 12 hour positions!

    // 1. Draw mathematical wavy scallop contour path
    final path = Path();
    final numPoints = 360;
    for (int i = 0; i < numPoints; i++) {
      final theta = (i * 2 * math.pi) / numPoints;
      final r = baseRadius + amplitude * math.cos(numScallops * theta);
      final x = center.dx + r * math.cos(theta);
      final y = center.dy + r * math.sin(theta);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Fill face and draw deep soft drop shadow underneath
    final facePaint = Paint()
      ..color = isDark ? const Color(0xFF0A050E) : Colors.white // Matte deep velvet-black luxury watch face
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()
        ..color = isDark ? const Color(0xFF0F172A).withValues(alpha: 0.22) : const Color(0xFF64748B).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(path, facePaint);

    // Glowing neon outer contour border line on scalloped edge
    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFFFF3377).withValues(alpha: 0.28) : const Color(0xFFFF3377).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, borderPaint);

    // 2. Draw hours and outer minute ticks placed perfectly
    final outerRadius = baseRadius - 6;
    final innerRadius = baseRadius - 16;
    
    for (int h = 1; h <= 12; h++) {
      final angle = (h * math.pi / 6) - math.pi / 2;
      
      // Draw outer minor ticks (5, 10, 15, ..., 60)
      final minuteText = (h * 5).toString();
      _drawTextAt(
        canvas,
        minuteText,
        center,
        outerRadius,
        angle,
        5.5,
        const Color(0xFFFF523B).withValues(alpha: 0.6), // Soft glowing coral minute ticks
      );

      // Draw major Hour numbers (1, 2, 3, ..., 12)
      final hourText = h.toString();
      _drawTextAt(
        canvas,
        hourText,
        center,
        innerRadius,
        angle,
        10.5,
        Colors.white,
        isBold: true,
      );
    }

    // 3. Smooth ticking mechanical angle math
    final secVal = time.second + time.millisecond / 1000.0;
    final minVal = time.minute + secVal / 60.0;
    final hrVal = (time.hour % 12) + minVal / 60.0;

    final secAngle = (secVal * 2 * math.pi / 60.0) - math.pi / 2;
    final minAngle = (minVal * 2 * math.pi / 60.0) - math.pi / 2;
    final hrAngle = (hrVal * 2 * math.pi / 12.0) - math.pi / 2;

    // 4. Draw Hour Hand (Bold, with dark border and rounded caps)
    final hrLength = baseRadius * 0.44;
    final hrEnd = Offset(
      center.dx + hrLength * math.cos(hrAngle),
      center.dy + hrLength * math.sin(hrAngle),
    );
    // Outer border stroke
    canvas.drawLine(
      center,
      hrEnd,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );
    // Inner fill stroke
    canvas.drawLine(
      center,
      hrEnd,
      Paint()
        ..color = const Color(0xFFF0F9FF)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // 5. Draw Minute Hand (Bold, longer, with dark border)
    final minLength = baseRadius * 0.68;
    final minEnd = Offset(
      center.dx + minLength * math.cos(minAngle),
      center.dy + minLength * math.sin(minAngle),
    );
    // Outer border stroke
    canvas.drawLine(
      center,
      minEnd,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
    // Inner fill stroke
    canvas.drawLine(
      center,
      minEnd,
      Paint()
        ..color = const Color(0xFFF0F9FF)
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    // 6. Draw Sweep Second Hand (Elegant luxury mechanical sweep, hot pink/magenta)
    final secLength = baseRadius * 0.80;
    final secEnd = Offset(
      center.dx + secLength * math.cos(secAngle),
      center.dy + secLength * math.sin(secAngle),
    );
    // Tail extension past center for classic design look
    final tailLength = baseRadius * 0.16;
    final tailEnd = Offset(
      center.dx - tailLength * math.cos(secAngle),
      center.dy - tailLength * math.sin(secAngle),
    );
    
    canvas.drawLine(
      tailEnd,
      secEnd,
      Paint()
        ..color = const Color(0xFFFF3377)
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // Center luxury pins (hub assembly)
    canvas.drawCircle(center, 3.5, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(center, 2.0, Paint()..color = const Color(0xFFFF3377));
    canvas.drawCircle(center, 0.8, Paint()..color = Colors.white);
  }

  void _drawTextAt(Canvas canvas, String text, Offset center, double radius, double angle, double fontSize, Color color, {bool isBold = false}) {
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ScallopedAnalogClockPainter oldDelegate) => oldDelegate.time != time;
}

// Glowing notes shortcut utility button panel
class _FloatingNotesActionsWidget extends StatefulWidget {
  const _FloatingNotesActionsWidget();

  @override
  State<_FloatingNotesActionsWidget> createState() => _FloatingNotesActionsWidgetState();
}

class _FloatingNotesActionsWidgetState extends State<_FloatingNotesActionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK SHORTCUTS',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Glowing Note Button (Pulsing neon)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Tooltip(
                  message: 'Quick Notes & Tasks',
                  child: InkWell(
                    onTap: () => _showNotesDialog(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF523B),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF523B).withValues(alpha: 0.15 + _pulseController.value * 0.15),
                            blurRadius: 10 + _pulseController.value * 8,
                            spreadRadius: _pulseController.value * 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.note_alt_outlined, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                );
              },
            ),

            // 2. Create Event Button
            Tooltip(
              message: 'Create CRM Event',
              child: _buildSquareShortcut(
                Icons.add_task_rounded,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFFFF523B),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text('Creating a new CRM Event calendar schedule...'),
                    ),
                  );
                },
                isDark,
              ),
            ),

            // 3. Launch Campaign Button
            Tooltip(
              message: 'Launch Campaign',
              child: _buildSquareShortcut(
                Icons.rocket_launch_rounded,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFFFF523B),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text('Launching autopilot pipeline campaign launcher...'),
                    ),
                  );
                },
                isDark,
              ),
            ),

            // 4. Settings Button
            Tooltip(
              message: 'Quick Settings',
              child: _buildSquareShortcut(
                Icons.settings_outlined,
                () {
                  context.go('/settings');
                },
                isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSquareShortcut(IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), size: 22),
        ),
      ),
    );
  }

  void _showNotesDialog(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note, color: Color(0xFFFF523B), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Notes & Tasks',
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 20),
              Text(
                'Add Note for Today:',
                style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF8F9FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  maxLines: 4,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Type your strategic note here...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFFFF523B),
                          content: Text('CRM Note added successfully!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF523B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save Note', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Overlapping notification stack widget
class _NotificationStackWidget extends StatefulWidget {
  const _NotificationStackWidget();

  @override
  State<_NotificationStackWidget> createState() => _NotificationStackWidgetState();
}

class _NotificationStackWidgetState extends State<_NotificationStackWidget>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  double _currentPageValue = 1.0;
  int _focusedIndex = 1;
  late AnimationController _angleController;

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Lead Registered',
      'desc': 'Mudhu Naz entered via LinkedIn strategy pipeline.',
      'time': '5 min ago',
      'icon': Icons.person_add_alt_1_rounded,
      'color': const Color(0xFFFFECE7),
      'iconColor': const Color(0xFFFF523B),
    },
    {
      'title': 'Autopilot Active',
      'desc': 'System auto-sent follow-up to Alex Rivera.',
      'time': '1 hr ago',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFEEF2FF),
      'iconColor': const Color(0xFF4F46E5),
    },
    {
      'title': 'Proposal Approved',
      'desc': 'Sarah Chen accepted the web layout quote.',
      'time': '3 hr ago',
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFFECFDF5),
      'iconColor': const Color(0xFF10B981),
    },
    {
      'title': 'Meeting Scheduled',
      'desc': 'Strategic call with David Kim at 6:30 PM.',
      'time': '5 hr ago',
      'icon': Icons.calendar_today_rounded,
      'color': const Color(0xFFFFF7ED),
      'iconColor': const Color(0xFFF97316),
    },
    {
      'title': 'Campaign Launched',
      'desc': 'Summer Promo SMS Blast was successfully sent.',
      'time': '1 day ago',
      'icon': Icons.campaign_rounded,
      'color': const Color(0xFFFDF2F8),
      'iconColor': const Color(0xFFDB2777),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.35,
      initialPage: _focusedIndex,
    );
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPageValue = _pageController.page ?? 0.0;
        });
      }
    });
    _angleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined, color: Color(0xFFFF523B), size: 18),
                const SizedBox(width: 8),
                Text(
                  'NOTIFICATIONS',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _showAllNotificationsDialog(context, _notifications),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFFFF523B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260.0,
          child: _buildExpandedCarousel(isDark),
        ),
        const SizedBox(height: 36),
      ],
    );
  }

  Widget _buildExpandedCarousel(bool isDark) {
    return Stack(
      key: const ValueKey('expanded'),
      children: [
        // 1. The custom-perspective vertical PageView carousel
        Positioned.fill(
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final double delta = pointerSignal.scrollDelta.dy;
                if (delta > 0) {
                  if (_pageController.hasClients) {
                    final target = (_currentPageValue + 1).round().clamp(0, _notifications.length - 1);
                    _pageController.animateToPage(
                      target,
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutCubic,
                    );
                  }
                } else if (delta < 0) {
                  if (_pageController.hasClients) {
                    final target = (_currentPageValue - 1).round().clamp(0, _notifications.length - 1);
                    _pageController.animateToPage(
                      target,
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutCubic,
                    );
                  }
                }
              }
            },
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: _notifications.length,
              onPageChanged: (index) {
                if (index != _focusedIndex) {
                  setState(() {
                    _focusedIndex = index;
                  });
                  playTukTukSound();
                }
              },
              itemBuilder: (context, idx) {
                final n = _notifications[idx];
                final diff = idx - _currentPageValue;
                final isFocused = idx == _focusedIndex;
                
                final double scale = (1.0 - (diff.abs() * 0.22)).clamp(0.68, 1.0);
                final double opacity = (1.0 - (diff.abs() * 0.45)).clamp(0.35, 1.0);
                
                // Tight mathematical visual alignment: pull adjacent cards in to reduce gap spacing
                final double translation = -diff * 14.0;

                return Transform.translate(
                  offset: Offset(0, translation),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: isFocused
                              ? _buildSelectedGlossyCard(n)
                              : _buildUnselectedCard(n, isDark),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // 2. Positioned Up Arrow Chevron for smooth manual navigation
        Positioned(
          top: 8,
          right: 8,
          child: _buildScrollButton(
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: () {
              if (_pageController.hasClients && _focusedIndex > 0) {
                _pageController.animateToPage(
                  _focusedIndex - 1,
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            enabled: _focusedIndex > 0,
          ),
        ),

        // 3. Positioned Down Arrow Chevron for smooth manual navigation
        Positioned(
          bottom: 8,
          right: 8,
          child: _buildScrollButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () {
              if (_pageController.hasClients && _focusedIndex < _notifications.length - 1) {
                _pageController.animateToPage(
                  _focusedIndex + 1,
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            enabled: _focusedIndex < _notifications.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 0.8 : 0.25,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0F172A).withOpacity(0.55),
              border: Border.all(
                color: const Color(0xFFFF3377).withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedGlossyCard(Map<String, dynamic> n) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3377).withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: RotationTransition(
                turns: _angleController,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: SweepGradient(
                      colors: [
                        Color(0xFFFF3377),
                        Color(0xFF7000FF),
                        Color(0xFF00F0FF),
                        Color(0xFFFF3377),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1.8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C030E).withOpacity(0.88),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.02),
                      Colors.white.withOpacity(0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFF3377).withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (n['iconColor'] as Color).withOpacity(0.2),
                        border: Border.all(
                          color: (n['iconColor'] as Color).withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (n['iconColor'] as Color).withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        n['icon'] as IconData,
                        color: n['iconColor'] as Color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                n['title'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white54,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                n['time'] as String,
                                style: const TextStyle(
                                  color: Color(0xFFFFECE7),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            n['desc'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnselectedCard(Map<String, dynamic> n, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155).withValues(alpha: 0.25) : const Color(0xFF1E293B).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF334155) : (n['color'] as Color).withValues(alpha: 0.8),
            ),
            child: Icon(
              n['icon'] as IconData,
              color: isDark ? Colors.white70 : (n['iconColor'] as Color).withValues(alpha: 0.8),
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      n['title'] as String,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF334155),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      n['time'] as String,
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  n['desc'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _showAllNotificationsDialog(BuildContext context, List<Map<String, dynamic>> items) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: Color(0xFFFF523B), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'All Notifications',
                        style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE2E8F0), height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((n) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: n['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  n['icon'] as IconData,
                                  color: n['iconColor'] as Color,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          n['title'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFF0F172A),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          n['time'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      n['desc'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF523B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Mark All As Read', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateful 1-card Today's Leads Carousel widget for the Right Sidebar
class _TodaysLeadsSidebarCarouselWidget extends StatefulWidget {
  const _TodaysLeadsSidebarCarouselWidget();

  @override
  State<_TodaysLeadsSidebarCarouselWidget> createState() => _TodaysLeadsSidebarCarouselWidgetState();
}

class _TodaysLeadsSidebarCarouselWidgetState extends State<_TodaysLeadsSidebarCarouselWidget> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _todaysLeads = [
    {
      'name': 'Mila Kunis',
      'company': 'Orchard LLC',
      'requirement': 'Design System',
      'time': '10:12 AM',
      'temperature': 'Hot',
      'urgency': 'Immediate',
      'phone': '+1 (555) 019-2834',
      'whatsapp': '+1 (555) 019-2834',
      'dealValue': '₹4,50,000',
      'image': 'https://robohash.org/mila.png?set=set1',
    },
    {
      'name': 'Jordan Peele',
      'company': 'Monkeypaw Prod',
      'requirement': 'Mobile CRM',
      'time': '11:30 AM',
      'temperature': 'Warm',
      'urgency': 'Normal',
      'phone': '+1 (555) 923-8124',
      'whatsapp': '+1 (555) 923-8124',
      'dealValue': '₹3,80,000',
      'image': 'https://robohash.org/jordan.png?set=set1',
    },
    {
      'name': 'Robert Downey',
      'company': 'Team Downey',
      'requirement': 'Autopilot Suite',
      'time': '1:15 PM',
      'temperature': 'Hot',
      'urgency': 'Immediate',
      'phone': '+1 (555) 777-3000',
      'whatsapp': '+1 (555) 777-3000',
      'dealValue': '₹9,00,000',
      'image': 'https://robohash.org/robert.png?set=set1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;
    final lead = _todaysLeads[_currentIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.today_rounded, color: Color(0xFFFF523B), size: 18),
                const SizedBox(width: 8),
                Text(
                  "TODAY'S LEADS",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = (_currentIndex - 1 + _todaysLeads.length) % _todaysLeads.length;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.chevron_left, size: 14, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_currentIndex + 1}/${_todaysLeads.length}',
                  style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _todaysLeads.length;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.chevron_right, size: 14, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155).withValues(alpha: 0.2) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFF1F5F9),
                    backgroundImage: NetworkImage(lead['image']),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${lead['company']} • ${lead['time']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFFFECE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lead['temperature'],
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFFFF523B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REQUIREMENT',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lead['requirement'],
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEAL VALUE',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lead['dealValue'],
                        style: const TextStyle(color: Color(0xFFFF523B), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: lead['phone']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFFFF523B),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            content: Text('Copied contact for ${lead['name']}!'),
                          ),
                        );
                      },
                      icon: Icon(Icons.copy, size: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                      label: Text(
                        'Copy Phone',
                        style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF475569) : const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          content: Text('Opening WhatsApp chat with ${lead['name']}...'),
                        ),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.message, size: 14, color: Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Sidebar Story Reel Video player with bottom white fade
class _SidebarVideoWidget extends StatefulWidget {
  const _SidebarVideoWidget();

  @override
  State<_SidebarVideoWidget> createState() => _SidebarVideoWidgetState();
}

class _SidebarVideoWidgetState extends State<_SidebarVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.asset(
        'assets/pinsnap-1127588825489340676-story1.mp4',
      );
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _hasError = false;
          });
          _controller.setVolume(0.0); // Muted
          _controller.setLooping(true); // Loop
          _controller.play(); // Auto Play
        }
      }).catchError((error) {
        debugPrint('Video Player initialize catchError: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
    } catch (e) {
      debugPrint('Video Player controller creation error: $e');
      _hasError = true;
    }
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      debugPrint('Error disposing video player: $e');
    }
    super.dispose();
  }

  Widget _buildFallbackBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6A47), Color(0xFFFF3377)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'AUTOPILOT PIPELINE',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sociafy Autopilot Live',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<_DesktopDashboardScreenState>();
    final isDark = dashboardState?._isDarkMode ?? false;

    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player or Fallback Banner
          Positioned.fill(
            child: _isInitialized && !_hasError
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : _buildFallbackBanner(),
          ),
          // Bottom White/Dark Fade Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.transparent,
                          const Color(0xFF1E293B).withValues(alpha: 0.1),
                          const Color(0xFF1E293B).withValues(alpha: 0.6),
                          const Color(0xFF1E293B),
                        ]
                      : [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.6),
                          Colors.white,
                        ],
                  stops: const [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
          ),
          // Subtle overlay icon/badge to show it is an active preview
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.video_library_rounded, color: Colors.white, size: 10),
                  SizedBox(width: 4),
                  Text(
                    'CRM REEL STORY',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Hoverable Lead Card Popover Component (3D pop-up + Staggered entrance animations)
// ==========================================

class HoverableLeadCard extends StatefulWidget {
  final Map<String, String> lead;
  final Widget child;
  final Color stageColor;

  const HoverableLeadCard({
    super.key,
    required this.lead,
    required this.child,
    required this.stageColor,
  });

  @override
  State<HoverableLeadCard> createState() => _HoverableLeadCardState();
}

class _HoverableLeadCardState extends State<HoverableLeadCard> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isHovered = false;
  bool _isClosing = false;

  void _showOverlay() {
    if (_overlayEntry != null) {
      if (_isClosing) {
        setState(() {
          _isClosing = false;
        });
        _overlayEntry?.markNeedsBuild();
      }
      return;
    }
    _isClosing = false;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 320,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(16, -10),
          child: MouseRegion(
            onEnter: (_) => _keepOverlay(),
            onExit: (_) => _hideOverlay(),
            child: _HoverPopoverContent(
              lead: widget.lead,
              stageColor: widget.stageColor,
              isClosing: _isClosing,
              onExitCompleted: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _keepOverlay() {
    setState(() {
      _isHovered = true;
      _isClosing = false;
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _hideOverlay() {
    setState(() {
      _isHovered = false;
    });
    // Add a slight delay to allow smooth transit between card and popover
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_isHovered) {
        setState(() {
          _isClosing = true;
        });
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          _keepOverlay();
          _showOverlay();
        },
        onExit: (_) {
          _hideOverlay();
        },
        child: widget.child,
      ),
    );
  }
}

class _HoverPopoverContent extends StatefulWidget {
  final Map<String, String> lead;
  final Color stageColor;
  final bool isClosing;
  final VoidCallback onExitCompleted;

  const _HoverPopoverContent({
    required this.lead,
    required this.stageColor,
    required this.isClosing,
    required this.onExitCompleted,
  });

  @override
  State<_HoverPopoverContent> createState() => _HoverPopoverContentState();
}

class _HoverPopoverContentState extends State<_HoverPopoverContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Overall card transitions
  late Animation<double> _cardOpacity;
  late Animation<double> _cardScale;
  late Animation<Offset> _cardSlide;

  // Staggered children transitions
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Overall card pop animations
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _cardScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack)),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0.05, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)));

    // Stagger intervals for 4 different elements
    _fadeAnimations = List.generate(4, (index) {
      double start = index * 0.12;
      double end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnimations = List.generate(4, (index) {
      double start = index * 0.12;
      double end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0.0, 0.12),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _HoverPopoverContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isClosing && !oldWidget.isClosing) {
      _controller.duration = const Duration(milliseconds: 200);
      _controller.reverse().then((_) {
        widget.onExitCompleted();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final temp = widget.lead['temp'] ?? 'Hot';
    final tempColor = temp == 'Hot'
        ? const Color(0xFFFF523B)
        : (temp == 'Warm' ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5));

    return FadeTransition(
      opacity: _cardOpacity,
      child: ScaleTransition(
        scale: _cardScale,
        child: SlideTransition(
          position: _cardSlide,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.stageColor.withValues(alpha: 0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: widget.stageColor.withValues(alpha: 0.04),
                  blurRadius: 48,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 0. Header (Staggered)
                FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: SlideTransition(
                    position: _slideAnimations[0],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: widget.stageColor.withValues(alpha: 0.08),
                          foregroundImage: NetworkImage(
                            widget.lead['avatar'] ?? '',
                          ),
                          child: Text(
                            (widget.lead['name'] ?? 'U').isEmpty ? 'U' : (widget.lead['name'] ?? 'U').substring(0, 1).toUpperCase(),
                            style: TextStyle(color: widget.stageColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lead['name'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.lead['company'] ?? 'Enterprise Client',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tempColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            temp,
                            style: TextStyle(color: tempColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Divider
                FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                const SizedBox(height: 14),

                // 1. Requirement Notes (Staggered)
                FadeTransition(
                  opacity: _fadeAnimations[1],
                  child: SlideTransition(
                    position: _slideAnimations[1],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CLIENT REQUIREMENTS & NOTES",
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.lead['notes'] ?? 'No notes available.',
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. AI Autopilot Strategy Suggestion (Staggered)
                FadeTransition(
                  opacity: _fadeAnimations[2],
                  child: SlideTransition(
                    position: _slideAnimations[2],
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.psychology_outlined, size: 14, color: Color(0xFF8B5CF6)),
                              const SizedBox(width: 6),
                              const Text(
                                "AI COPILOT RECOMMENDATION",
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "92% Match",
                                  style: TextStyle(color: Colors.green, fontSize: 8.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Automated follow-up strategy: Schedule Strategy consultation regarding ${widget.lead['req'] ?? 'Project Scope'}. Recommend commercial budget package at ${widget.lead['val'] ?? '₹0'}.",
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Quick Metrics (Staggered)
                FadeTransition(
                  opacity: _fadeAnimations[3],
                  child: SlideTransition(
                    position: _slideAnimations[3],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPopoverMetric("Location", widget.lead['location'] ?? "Remote", Icons.location_on_outlined, Colors.blue),
                        _buildPopoverMetric("Deal Value", widget.lead['val'] ?? "₹0", Icons.monetization_on_outlined, Colors.green),
                        _buildPopoverMetric("Stage Status", widget.lead['status'] ?? "NEW", Icons.segment_outlined, widget.stageColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopoverMetric(String title, String val, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          val,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
