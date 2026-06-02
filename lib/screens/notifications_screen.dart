import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': null},
    {'label': 'Mentions', 'icon': Icons.alternate_email},
    {'label': 'Alerts', 'icon': Icons.error_outline},
    {'label': 'System', 'icon': Icons.settings_input_component},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/notifications'),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(isMobile),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildMainContent(isMobile)),
                      if (!isMobile)
                        Container(
                          width: 380,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                          ),
                          child: _buildRightSidebar(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 3) : null, // Assuming notifications is index 3
    );
  }

  Widget _buildTopHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => context.go('/dashboard'),
            ),
          if (isMobile) const SizedBox(width: 12),
          const Text(
            'Alerts',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFCCFF00).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '12',
              style: TextStyle(color: Color(0xFFCCFF00), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          if (!isMobile)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.white24, size: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          if (isMobile)
            IconButton(
              onPressed: () => _showSettingsDrawer(context),
              icon: const Icon(Icons.tune, color: Colors.white70, size: 20),
            ),
        ],
      ),
    );
  }

  void _showSettingsDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1012),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(32),
        child: _buildRightSidebar(),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterTabs(isMobile),
          const SizedBox(height: 32),
          _buildDateHeader('TODAY'),
          const SizedBox(height: 20),
          _buildUrgentNotification(isMobile),
          const SizedBox(height: 16),
          _buildSocialNotification(isMobile),
          const SizedBox(height: 16),
          _buildMentionNotification(isMobile),
          const SizedBox(height: 48),
          _buildDateHeader('YESTERDAY'),
          const SizedBox(height: 20),
          _buildSimpleNotification('Mark Wilson', 'assigned you a new task', '4:30 PM', Icons.task_alt, isMobile),
          if (isMobile) const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          bool isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFCCFF00) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  if (_filters[index]['icon'] != null)
                    Icon(_filters[index]['icon'], color: isSelected ? Colors.black : Colors.white38, size: 16),
                  if (_filters[index]['icon'] != null) const SizedBox(width: 8),
                  Text(
                    _filters[index]['label'],
                    style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDateHeader(String day) {
    return Text(
      day,
      style: const TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
    );
  }

  Widget _buildUrgentNotification(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF26121D),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Urgent Action Required', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Acme Corp contract expires in 24 hours.', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
              const Text('24m', style: TextStyle(color: Colors.white10, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Review Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.white38),
                  child: const Text('Dismiss'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialNotification(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah')),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(text: 'Sarah Jenkins ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'commented on ', style: TextStyle(color: Colors.white38)),
                      TextSpan(text: 'Q3 Strategy', style: TextStyle(color: Color(0xFFCCFF00), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const Text('1h', style: TextStyle(color: Colors.white10, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
            child: const Text(
              '"Great insights on the enterprise funnel..."',
              style: TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentionNotification(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFCCFF00).withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.alternate_email, color: Color(0xFFCCFF00), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(text: 'David Chen ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'mentioned you', style: TextStyle(color: Colors.white38)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Approvals needed for #Lead-2049', style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
          const Text('2h', style: TextStyle(color: Colors.white10, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSimpleNotification(String user, String action, String time, IconData icon, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white.withValues(alpha: 0.05), child: Icon(icon, color: Colors.white38, size: 16)),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white38, fontSize: 13),
                children: [
                  TextSpan(text: '$user ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  TextSpan(text: action),
                ],
              ),
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white10, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildRuleToggle('Email Digest', true),
          const SizedBox(height: 16),
          _buildRuleToggle('Desktop Alerts', true),
          const SizedBox(height: 16),
          _buildRuleToggle('Lead Mentions', true),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCFF00),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Save Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleToggle(String title, bool val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Switch(value: val, onChanged: (v) {}, activeColor: const Color(0xFFCCFF00)),
      ],
    );
  }
}
