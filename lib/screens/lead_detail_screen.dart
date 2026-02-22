import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/glass_card.dart';
import 'package:leads_management/widgets/sidebar.dart';

class LeadDetailScreen extends StatelessWidget {
  const LeadDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/leads'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1600),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: _buildLeftColumn()),
                          const SizedBox(width: 32),
                          Expanded(flex: 2, child: _buildRightColumn()),
                        ],
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Leads',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 14, color: Colors.white38),
                  SizedBox(width: 8),
                  Text(
                    'Software',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 14, color: Colors.white38),
                  SizedBox(width: 8),
                  Text(
                    'Sarah Jennings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          _buildActionIcon(Icons.notifications_none, hasBadge: true),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 18),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Icon(icon, size: 20, color: Colors.white70),
        ),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildProfileCard(),
        const SizedBox(height: 24),
        _buildContactInfo(),
        const SizedBox(height: 24),
        _buildDealInfo(),
      ],
    );
  }

  Widget _buildProfileCard() {
    return GlassCard(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Colors.transparent],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAj8vxMriPfF0PveNQBVa8GeOA88pH6v6-BKoeXdkuogOm6PeBl7US6j8lfk4qwlb8uzxJBbeumcf-ekGMcWwKc_ZhKEl-bRC_6mErIvi8L_3YsVpX2fc5xFRyiA9I8NvV8p1Q1nL-E6hmL4zLLjrBhVoQed8GHjVNeRZ1AaXF2LYgpGwQHu7t8f1VcrzNzBQOWK6wVXKvx5ZPPqEcoAXmT-qE74AQo6Jao9YEDdegMJRKAp1-fS9TypRa4n5pu-kZszaN2JQGsYk4',
                  ),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Sarah Jennings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'VP of Marketing @ TechFlow Inc.',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: AppColors.primary, size: 14),
                SizedBox(width: 8),
                Text(
                  'HIGH INTENT • 85 SCORE',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildIconButton(Icons.call_outlined, 'Call')),
              const SizedBox(width: 12),
              Expanded(child: _buildIconButton(Icons.mail_outlined, 'Email')),
              const SizedBox(width: 12),
              Expanded(
                child: _buildIconButton(Icons.chat_bubble_outline, 'Chat'),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildIconButton(Icons.more_horiz, 'More')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT INFORMATION',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            Icons.mail_outlined,
            'Email Address',
            'sarah.j@techflow.com',
            trailing: Icons.content_copy,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.call_outlined,
            'Phone Number',
            '+1 (555) 123-4567',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.location_on_outlined,
            'Location',
            'San Francisco, CA',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.link,
            'LinkedIn',
            'linkedin.com/in/sarahj',
            trailing: Icons.open_in_new,
            iconColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    IconData? trailing,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? Colors.white30, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) Icon(trailing, size: 14, color: Colors.white30),
      ],
    );
  }

  Widget _buildDealInfo() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEAL INFO',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildSmallStat('Deal Value', 'Rs 12,000')),
              const SizedBox(width: 16),
              Expanded(child: _buildSmallStat('Exp. Close', 'Oct 24')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Stage',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discovery',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              Text(
                'Negotiation (75%)',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildNextStepsCard(),
        const SizedBox(height: 32),
        const Row(
          children: [
            _TabItem('Timeline', isActive: true),
            _TabItem('Notes'),
            _TabItem('Calls'),
            _TabItem('Emails'),
            _TabItem('Files'),
          ],
        ),
        const Divider(color: Colors.white12, height: 1),
        const SizedBox(height: 32),
        _buildTimeline(),
      ],
    );
  }

  Widget _buildNextStepsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.redAccent],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const Icon(Icons.upcoming, color: Colors.white),
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next Step: Product Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Schedule a follow-up meeting with the team.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Row(
              children: [
                Text(
                  '10/24/2023',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 12),
                Icon(Icons.calendar_today, size: 16, color: Colors.white38),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
            child: const Text(
              'Set Reminder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildActivityInput(),
        const SizedBox(height: 32),
        _buildTimelineItem(
          Icons.check_circle,
          'Task Completed',
          'Today, 10:23 AM',
          'Sent the updated contract proposal with the requested discount applied for Q4 onboarding.',
          Colors.greenAccent,
        ),
        _buildTimelineItem(
          Icons.call,
          'Call Logged',
          'Yesterday, 4:15 PM',
          'Discussed Q4 budget requirements. Sarah mentioned they are evaluating 2 other competitors but like our analytics features best.',
          AppColors.primary,
          extra: _buildAudioControl(),
        ),
        _buildTimelineItem(
          Icons.mail,
          'Email Opened',
          '2 days ago',
          'Subject: Product Overview Deck\nSarah clicked on link "Enterprise_Pricing.pdf"',
          Colors.blueAccent,
          badge: 'CLICKED',
        ),
      ],
    );
  }

  Widget _buildActivityInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCcbCNDxwudtlzBcLdACGnuogBDSzyVgAsmrYBFtFXelY-xEK4F17O1M2VJdlew7M9uhcnd47fIQfLtF7Vo11pvtNLeiJ6wS4Z27XZGkxiNLZEazeH3CPHGfnlMWpSkyVf0CVnOImNtWNxsZs4fi2m4ax2j3ogYh5G0rvLk1o825EwpwUPtLZmC-iVGHWvPP37jtKcAsoHAITaMYbdO08DtIZMYNdcitjVvZtkLLkdOXa0G8_joE02z_SMazXBD5gnGhFvcaVay7ys',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Log a call, note, or email...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.format_bold,
                        color: Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white38,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.attach_file,
                        color: Colors.white38,
                        size: 20,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          'Log Activity',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildTimelineItem(
    IconData icon,
    String title,
    String time,
    String desc,
    Color color, {
    Widget? extra,
    String? badge,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Expanded(child: Container(width: 2, color: Colors.white12)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _GlassTimelineCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                time,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'CLICKED',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      if (extra != null) extra,
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(15, (i) {
                return Container(
                  width: 3,
                  height: 10 + (i % 5 * 5).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '14:32',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  const _TabItem(this.label, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white38,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

class _GlassTimelineCard extends StatelessWidget {
  final Widget child;
  const _GlassTimelineCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}
