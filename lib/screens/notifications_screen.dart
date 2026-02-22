import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/notifications'),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildMainContent()),
                      Container(
                        width: 380,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
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
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Notification Center',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '12 New',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 320,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Icon(
            Icons.settings_outlined,
            color: Colors.white.withValues(alpha: 0.38),
          ),
          const SizedBox(width: 24),
          Icon(Icons.help_outline, color: Colors.white.withValues(alpha: 0.38)),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterTabs(),
          const SizedBox(height: 48),
          _buildDateHeader('TODAY', 'Wednesday, Oct 24'),
          const SizedBox(height: 24),
          _buildUrgentNotification(),
          const SizedBox(height: 16),
          _buildSocialNotification(),
          const SizedBox(height: 16),
          _buildMentionNotification(),
          const SizedBox(height: 16),
          _buildSystemNotification(),
          const SizedBox(height: 48),
          _buildDateHeader('YESTERDAY', ''),
          const SizedBox(height: 24),
          _buildSimpleNotification(
            'Mark Wilson',
            'assigned you a new task',
            'Yesterday, 4:30 PM',
            Icons.task_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildTab('All', true, null),
        const SizedBox(width: 12),
        _buildTab('Mentions', false, Icons.alternate_email),
        const SizedBox(width: 12),
        _buildTab('Alerts', false, Icons.error_outline),
        const SizedBox(width: 12),
        _buildTab('System', false, Icons.settings_input_component),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Mark all as read',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        const Text('|', style: TextStyle(color: Colors.white12)),
        const SizedBox(width: 12),
        Row(
          children: const [
            Icon(Icons.filter_list, color: Colors.white38, size: 16),
            SizedBox(width: 8),
            Text(
              'Filter',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool isActive, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white38,
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String day, String fullDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        if (fullDate.isNotEmpty)
          Text(
            fullDate,
            style: const TextStyle(color: Colors.white12, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildUrgentNotification() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF26121D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Urgent: Contract renewal expiring soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '24m ago',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.2),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'The renewal contract for Acme Corp (Deal #4092) expires in less than 24 hours. Action required immediately.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Review Contract',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white38,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Dismiss'),
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

  Widget _buildSocialNotification() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=sarah',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sarah Jenkins ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'and ',
                                  style: TextStyle(color: Colors.white38),
                                ),
                                TextSpan(
                                  text: '4 others ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'commented on ',
                                  style: TextStyle(color: Colors.white38),
                                ),
                                TextSpan(
                                  text: 'Q3 Sales Strategy',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '1h ago',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '"Great insights on the enterprise funnel, but we need to adjust..."',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Column(
              children: [
                _buildCommentItem(
                  'Sarah Jenkins',
                  'Updated the projections based on the new leads.',
                  'https://i.pravatar.cc/150?u=sarah',
                ),
                const SizedBox(height: 12),
                _buildCommentItem(
                  'James Liu',
                  'Can we get a breakdown by region?',
                  'https://i.pravatar.cc/150?u=james',
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: Text(
                      'View all 5 comments',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String name, String comment, String avatar) {
    return Row(
      children: [
        CircleAvatar(radius: 12, backgroundImage: NetworkImage(avatar)),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white38, fontSize: 13),
            children: [
              TextSpan(
                text: '$name: ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: '"$comment"'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMentionNotification() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.alternate_email,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'David Chen ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'mentioned you in ',
                            style: TextStyle(color: Colors.white38),
                          ),
                          TextSpan(
                            text: '#Lead-2049',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '2h ago',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.1),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(text: '"Hey '),
                        TextSpan(
                          text: '@Alex',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ', can you approve the discount tier for this client before EOD?"',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildIconBtn(Icons.reply, 'Reply'),
                    const SizedBox(width: 24),
                    _buildIconBtn(Icons.visibility_outlined, 'View Lead'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemNotification() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Data Export Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '4h ago',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.1),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your monthly sales report (CSV) is ready to download.',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(
                        Icons.file_download_outlined,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Download File (2.4MB)',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSimpleNotification(
    String user,
    String action,
    String time,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            child: Icon(icon, color: Colors.white38, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white38, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$user ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: action),
                ],
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.1),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage how you receive alerts.',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 32),
          _buildQuietHoursCard(),
          const SizedBox(height: 48),
          const Text(
            'NOTIFICATION RULES',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildRuleToggle('Email Digest', 'Daily summary at 9am', false),
          const SizedBox(height: 24),
          _buildRuleToggle('Mentions', 'Push to desktop', true),
          const SizedBox(height: 24),
          _buildRuleToggle('Lead Updates', 'In-app only', true),
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Advanced Preferences'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white12),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.dark_mode, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Quiet Hours',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: true,
                onChanged: (v) {},
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTimeInput('Start', '06:00 PM')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('-', style: TextStyle(color: Colors.white24)),
              ),
              Expanded(child: _buildTimeInput('End', '08:00 AM')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Notifications will be silenced during these hours except for high priority alerts.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white12,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleToggle(String title, String desc, bool value) {
    return Row(
      children: [
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
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primary),
      ],
    );
  }
}
