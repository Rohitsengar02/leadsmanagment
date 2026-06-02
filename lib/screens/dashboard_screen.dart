import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/glass_card.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'all_leads_screen.dart';
import 'todays_leads_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads_management/desktop/desktop_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // Hero expansion state
  bool _isHeroExpanded = false;

  // Stats Carousel Controller
  late PageController _statsPageController;
  late Timer _statsTimer;
  int _currentStatsPage = 0;

  String _activeChartTab = '12M';

  @override
  void initState() {
    super.initState();
    _statsPageController = PageController(viewportFraction: 0.85);
    _statsTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_statsPageController.hasClients && !_isHeroExpanded) {
        _currentStatsPage = (_currentStatsPage + 1) % 4;
        _statsPageController.animateToPage(
          _currentStatsPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutSine,
        );
      }
    });
  }

  @override
  void dispose() {
    _statsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    if (!isMobile) {
      return const DesktopDashboardScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/dashboard'),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -300,
                  left: -100,
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreenHero(context, isMobile),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 20 : 32,
                          20,
                          isMobile ? 20 : 32,
                          isMobile ? 120 : 32,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAnimatedCategoryCarousel(),
                              const SizedBox(height: 32),
                              _buildToBeConfirmedLeads(),
                              const SizedBox(height: 32),
                              _buildTodaysLeads(
                                isMobile,
                                title: "Today's Leads",
                              ),
                              const SizedBox(height: 32),
                              if (isMobile) ...[
                                _buildRevenueChart(),
                                const SizedBox(height: 24),
                                _buildPieChartSection(),
                                const SizedBox(height: 24),
                                _buildAIWidget(),
                              ] else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildRevenueChart(),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _buildPieChartSection(),
                                          const SizedBox(height: 24),
                                          _buildAIWidget(),
                                        ],
                                      ),
                                    ),
                                  ],
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
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 0) : null,
    );
  }

  Widget _buildAnimatedCategoryCarousel() {
    final categories = [
      {'label': 'Dashboard', 'icon': Icons.dashboard_outlined},
      {'label': 'Leads', 'icon': Icons.people_outline},
      {'label': 'Proposals', 'icon': Icons.description_outlined},
      {'label': 'Team', 'icon': Icons.group_outlined},
      {'label': 'Campaigns', 'icon': Icons.campaign_outlined},
      {'label': 'OCR Scan', 'icon': Icons.qr_code_scanner},
      {'label': 'Settings', 'icon': Icons.settings_outlined},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _CategoryButton(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
          );
        },
      ),
    );
  }

  Widget _buildPieChartSection() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lead Sources',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: AppColors.primary,
                    radius: 25,
                    title: '40%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: Colors.blue,
                    radius: 25,
                    title: '30%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: Colors.purple,
                    radius: 25,
                    title: '15%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: Colors.orange,
                    radius: 25,
                    title: '15%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSourceIndicator('Direct Ads', AppColors.primary),
          _buildSourceIndicator('Referrals', Colors.blue),
          _buildSourceIndicator('Organic', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSourceIndicator(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGreenHero(BuildContext context, bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack, // Smooth bouncing animation
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFCCFF00), Color(0xFFA6E600)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, isMobile ? 50 : 30, 20, 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=janvis',
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Janvis David',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@janvisd',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                _buildHeroActionIcon(Icons.emoji_events_outlined),
                const SizedBox(width: 12),
                _buildHeroActionIcon(Icons.notifications_none, hasBadge: true),
              ],
            ),
          ),

          AnimatedCrossFade(
            firstChild: _buildMinimizedStatsCarousel(),
            secondChild: _buildMaximizedHeroContent(),
            crossFadeState: _isHeroExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 600),
            firstCurve: Curves.easeOutBack,
            secondCurve: Curves.easeOutBack,
            sizeCurve: Curves.easeOutBack,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHeroExpanded = !_isHeroExpanded;
              });
            },
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: _isHeroExpanded ? 0.5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black.withValues(alpha: 0.5),
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildMinimizedStatsCarousel() {
    final stats = [
      {
        'label': 'Ads Budget',
        'value': '₹3.5L',
        'subtitle': 'Efficiency: 94%',
        'icon': Icons.ads_click,
      },
      {
        'label': 'Confirmed',
        'value': '124',
        'subtitle': 'Conv Rate: 18.5%',
        'icon': Icons.handshake,
      },
      {
        'label': 'New Leads',
        'value': '28',
        'subtitle': 'Top: LinkedIn',
        'icon': Icons.person_add_outlined,
      },
      {
        'label': 'Proposals',
        'value': '45',
        'subtitle': 'Pending: 12',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Team',
        'value': '12',
        'subtitle': 'Active now: 8',
        'icon': Icons.group_outlined,
      },
      {
        'label': 'Scan',
        'value': '89',
        'subtitle': 'OCR Success: 98%',
        'icon': Icons.qr_code_scanner,
      },
      {
        'label': 'Campaigns',
        'value': '6',
        'subtitle': 'Live: 2',
        'icon': Icons.campaign_outlined,
      },
    ];

    const limeColor = Color(0xFFCCFF00);

    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _statsPageController,
        onPageChanged: (index) {
          _currentStatsPage = index;
        },
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black, // Black background
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: limeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: limeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        color: limeColor.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stat['value'] as String,
                      style: const TextStyle(
                        color: limeColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stat['subtitle'] as String,
                      style: TextStyle(
                        color: limeColor.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.trending_up, color: limeColor, size: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMaximizedHeroContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '₹18,23,590',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '.73',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.visibility_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '24%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Last week',
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildMaximizedStatsCarousel(),
        ],
      ),
    );
  }

  Widget _buildMaximizedStatsCarousel() {
    final stats = [
      {
        'label': 'Ads Budget',
        'value': '₹3,50,000',
        'subtitle': 'Spend efficiency: 94%',
        'detail': 'Remaining: ₹72,000',
        'trend': '+12%',
        'icon': Icons.ads_click,
      },
      {
        'label': 'Confirmed Deals',
        'value': '124 Deals',
        'subtitle': 'Conversion rate: 18.5%',
        'detail': 'Avg. Value: ₹1,24,000',
        'trend': '+8%',
        'icon': Icons.handshake,
      },
      {
        'label': 'New Leads',
        'value': '28 Leads',
        'subtitle': 'Avg. Response: 12m',
        'detail': 'Top Source: LinkedIn',
        'trend': '+22%',
        'icon': Icons.person_add_outlined,
      },
      {
        'label': 'Total Proposals',
        'value': '45 Active',
        'subtitle': 'Closing rate: 42%',
        'detail': 'Pending approval: 12',
        'trend': '+15%',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Team Performance',
        'value': '8.2/10',
        'subtitle': 'Efficiency up 5%',
        'detail': 'Top performer: Alex',
        'trend': '+5%',
        'icon': Icons.group_outlined,
      },
      {
        'label': 'Scanned Items',
        'value': '89 Docs',
        'subtitle': 'Accuracy: 99.2%',
        'detail': 'Recently: Invoice #28',
        'trend': '+30%',
        'icon': Icons.qr_code_scanner,
      },
      {
        'label': 'Active Campaigns',
        'value': '6 Live',
        'subtitle': 'Reach: 1.2M',
        'detail': 'Top: Diwali Offer',
        'trend': '+40%',
        'icon': Icons.campaign_outlined,
      },
    ];

    const limeColor = Color(0xFFCCFF00);

    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black, // Black background
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: limeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        color: limeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat['label'] as String,
                          style: TextStyle(
                            color: limeColor.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            color: limeColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: limeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        stat['trend'] as String,
                        style: const TextStyle(
                          color: limeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  stat['subtitle'] as String,
                  style: const TextStyle(
                    color: limeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['detail'] as String,
                  style: TextStyle(
                    color: limeColor.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroActionIcon(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 22, color: Colors.black),
        ),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCCFF00), width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildToBeConfirmedLeads() {
    final leads = [
      {
        'name': 'Satya',
        'requirement': 'E-commerce App',
        'value': '₹45,000',
        'rating': '5 (35)',
        'seed': 'Satya',
      },
      {
        'name': 'Arjun',
        'requirement': 'Fintech Platform',
        'value': '₹1.2L',
        'rating': '4.8 (12)',
        'seed': 'Arjun',
      },
      {
        'name': 'Saanvi',
        'requirement': 'Service Booking App',
        'value': '₹89,000',
        'rating': '5 (42)',
        'seed': 'Saanvi',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'To Be Confirmed Leads',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllLeadsScreen(),
                  ),
                );
              },
              child: _buildViewAllButton(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180, // Increased height for the two-row design
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              final avatarUrl =
                  'https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}';

              return GestureDetector(
                onTap: () => _showLeadDetails(context, lead),
                child: Container(
                  width: 320, // Wider for the horizontal layout
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFDECD2,
                              ), // Squircle background
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      lead['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      color: Color(0xFFEA4C89),
                                      size: 16,
                                    ), // Pink verified badge
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lead['requirement']!,
                                  style: const TextStyle(
                                    color: Color(0xFFCCFF00),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFC107),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      lead['rating']!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.white38,
                            size: 20,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLeadActionIcon(
                            Icons.videocam,
                            isHighlighted: true,
                          ),
                          _buildLeadActionIcon(Icons.phone),
                          _buildLeadActionIcon(Icons.chat_bubble),
                          _buildLeadActionIcon(Icons.message),
                          _buildLeadActionIcon(
                            Icons.paid_outlined,
                            value: lead['value'],
                          ), // Project value icon
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLeadDetails(BuildContext context, Map<String, String> lead) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LeadDetails',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Section (Profile)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECD2),
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lead['requirement']!,
                                style: const TextStyle(
                                  color: Color(0xFFCCFF00),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10),
                  // History/Timeline
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Activity Timeline',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTimelineItem(
                          'Proposal Sent',
                          '₹45,000 package shared',
                          'Today, 11:30 AM',
                          Icons.description,
                          Colors.blue,
                        ),
                        _buildTimelineItem(
                          'Meeting Completed',
                          'Technical scope discussed',
                          'Yesterday, 04:00 PM',
                          Icons.videocam,
                          Colors.green,
                        ),
                        _buildTimelineItem(
                          'Inquiry Received',
                          'Via LinkedIn Ads',
                          'Jan 18, 2025',
                          Icons.campaign,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildBigActionButton(
                            'WhatsApp',
                            Icons.chat,
                            const Color(0xFF25D366),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildBigActionButton(
                            'Call',
                            Icons.phone,
                            const Color(0xFFCCFF00).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _buildTimelineItem(
    String title,
    String desc,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadActionIcon(
    IconData icon, {
    bool isHighlighted = false,
    String? value,
  }) {
    return Container(
      width: 50,
      height: 45,
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xFFEA4C89)
            : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: value != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white54, size: 16),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Text(
            'View all',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, color: Colors.white70, size: 14),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Converted Clients',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Monthly Performance',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildChartTab('12M'),
                  _buildChartTab('6M'),
                  _buildChartTab('30D'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'JAN';
                            break;
                          case 2:
                            text = 'MAR';
                            break;
                          case 4:
                            text = 'MAY';
                            break;
                          case 6:
                            text = 'JUL';
                            break;
                          case 8:
                            text = 'SEP';
                            break;
                          case 10:
                            text = 'NOV';
                            break;
                          default:
                            text = '';
                            break;
                        }
                        return Text(text, style: style);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: _getBarGroups(),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    // Mock data variation based on tab
    final multiplier = _activeChartTab == '12M'
        ? 1.0
        : (_activeChartTab == '6M' ? 0.7 : 0.4);

    return List.generate(12, (index) {
      final value =
          (30 + (index * 5) + (index % 2 == 0 ? 10 : -10)) * multiplier;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            gradient: LinearGradient(
              colors: [
                const Color(0xFFCCFF00),
                const Color(0xFFCCFF00).withValues(alpha: 0.3),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 14,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChartTab(String label) {
    bool isActive = _activeChartTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeChartTab = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFCCFF00) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysLeads(bool isMobile, {String title = "Today's Leads"}) {
    final leads = [
      {
        'name': 'Mudhu Naz',
        'requirement': 'UI Designer',
        'phone': '+91 98765 43210',
        'time': '7:23 PM',
        'status': 'High Intent Lead',
        'seed': 'Mudhu',
        'bannerText': 'Project: E-commerce Website',
        'bannerColor': const Color(0xFFCCFF00),
        'bannerIcon': Icons.web,
      },
      {
        'name': 'Alex Rivera',
        'requirement': 'Full Stack Dev',
        'phone': '+91 87654 32109',
        'time': '5:45 PM',
        'status': 'Awaiting Quotation',
        'seed': 'Alex',
        'bannerText': 'Project: SaaS Dashboard',
        'bannerColor': Colors.blueAccent,
        'bannerIcon': Icons.dashboard,
      },
      {
        'name': 'Sarah Chen',
        'requirement': 'Marketing',
        'phone': '+91 76543 21098',
        'time': '4:20 PM',
        'status': 'Follow-up Needed',
        'seed': 'Sarah',
        'bannerText': 'Project: SEO Optimization',
        'bannerColor': Colors.orangeAccent,
        'bannerIcon': Icons.trending_up,
      },
      {
        'name': 'James Wilson',
        'requirement': 'App Developer',
        'phone': '+91 65432 10987',
        'time': '3:15 PM',
        'status': 'Lead Qualified',
        'seed': 'James',
        'bannerText': 'Project: iOS/Android App',
        'bannerColor': Colors.purpleAccent,
        'bannerIcon': Icons.phone_android,
      },
      {
        'name': 'Priya Shah',
        'requirement': 'UX Researcher',
        'phone': '+91 54321 09876',
        'time': '2:10 PM',
        'status': 'Ready to Convert',
        'seed': 'Priya',
        'bannerText': 'Project: User Flow Audit',
        'bannerColor': Colors.pinkAccent,
        'bannerIcon': Icons.person_search,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TodaysLeadsScreen(),
                  ),
                );
              },
              child: _buildViewAllButton(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280, // Height for the carousel
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              final bannerColor = lead['bannerColor'] as Color;
              final avatarUrl =
                  'https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}';

              return Container(
                width: 300, // Carousel card width
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lead['requirement'] as String,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                lead['time'] as String,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: bannerColor.withValues(
                                    alpha: 0.2,
                                  ), // Matching category color
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lead['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Color(0xFFCCFF00),
                                          size: 6,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          lead['status'] as String,
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildTinyActionButton(
                                Icons.chat,
                                'WhatsApp',
                                const Color(0xFF25D366),
                              ),
                              const SizedBox(width: 8),
                              _buildTinyActionButton(
                                Icons.phone,
                                'Call',
                                Colors.white24,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () =>
                                    _showAILeadDetailPopUp(context, lead),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: bannerColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.insights,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: bannerColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            lead['bannerIcon'] as IconData,
                            color: Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            lead['bannerText'] as String,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTinyActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  void _showAILeadDetailPopUp(BuildContext context, Map<String, dynamic> lead) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AILeadDetail',
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1012),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: (lead['bannerColor'] as Color)
                              .withValues(alpha: 0.2),
                          backgroundImage: NetworkImage(
                            'https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${lead['requirement']} • ${lead['phone']}',
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  // AI Chat Section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFCCFF00),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI PROJECT CONSULTANT',
                                style: TextStyle(
                                  color: Color(0xFFCCFF00),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildChatMessage(
                            'AI',
                            'Hello Manager! I\'ve analyzed ${lead['name']}\'s requirement for a ${lead['requirement']}. Based on their profile, they are currently high on creativity. Should I draft a custom proposal for their ${lead['phone']} number?',
                          ),
                          const SizedBox(height: 16),
                          _buildChatMessage(
                            'Manager',
                            'Yes, what technical stack should we suggest?',
                            isMe: true,
                          ),
                          const SizedBox(height: 16),
                          _buildChatMessage(
                            'AI',
                            'For ${lead['requirement']}, I recommend a Flutter + Node.js stack. This lead has an 85% closure probability if we send the proposal within the next 2 hours.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Chat Input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Ask AI about this client...',
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFFCCFF00),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildBigActionButton(
                            'WhatsApp',
                            Icons.chat,
                            const Color(0xFF25D366),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildBigActionButton(
                            'Call Lead',
                            Icons.phone,
                            const Color(0xFFCCFF00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _buildChatMessage(String sender, String message, {bool isMe = false}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFCCFF00).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isMe
                ? Colors.white10
                : const Color(0xFFCCFF00).withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                color: isMe ? Colors.white38 : const Color(0xFFCCFF00),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildAIWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Color(0xFF5821C4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF13111C).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Insight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: 'Based on recent engagement patterns, '),
                  TextSpan(
                    text: 'Acme Corp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' shows a '),
                  TextSpan(
                    text: '85% probability',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' of closing this week.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Take Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFCCFF00); // Static neon green
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
