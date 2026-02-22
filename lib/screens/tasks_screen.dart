import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/tasks'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1634152962476-4b8a00e1915c?q=80&w=2000&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
              child: Column(
                children: [
                  _buildTopNav(),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildMainContent()),
                        Container(
                          width: 380,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF130E1B,
                            ).withValues(alpha: 0.5),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1B).withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 320,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks, deals...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
          const Spacer(),
          _buildTopNavItem('Dashboard', false),
          _buildTopNavItem('Contacts', false),
          _buildTopNavItem('Tasks', true),
          _buildTopNavItem('Reports', false),
          const SizedBox(width: 32),
          _buildActionIcon(Icons.notifications_none, hasBadge: true),
          const SizedBox(width: 16),
          _buildActionIcon(Icons.settings_outlined),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAj8vxMriPfF0PveNQBVa8GeOA88pH6v6-BKoeXdkuogOm6PeBl7US6j8lfk4qwlb8uzxJBbeumcf-ekGMcWwKc_ZhKEl-bRC_6mErIvi8L_3YsVpX2fc5xFRyiA9I8NvV8p1Q1nL-E6hmL4zLLjrBhVoQed8GHjVNeRZ1AaXF2LYgpGwQHu7t8f1VcrzNzBQOWK6wVXKvx5ZPPqEcoAXmT-qE74AQo6Jao9YEDdegMJRKAp1-fS9TypRa4n5pu-kZszaN2JQGsYk4',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavItem(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 28,
            height: 2,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        if (hasBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF130E1B), width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(48),
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
                    'Tasks & Follow-ups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your daily activities and client follow-ups.',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(
                    'New Task',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              _buildTab('Today', 5, true),
              _buildTab('Upcoming', null, false),
              _buildTab('Missed', 2, false),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              _buildFilterChip(Icons.priority_high, 'Priority'),
              const SizedBox(width: 8),
              _buildFilterChip(Icons.person_outline, 'Assignee'),
              const SizedBox(width: 8),
              _buildFilterChip(Icons.category_outlined, 'Type'),
            ],
          ),
          const SizedBox(height: 32),
          _buildTaskCard(
            'Contract Review with Acme Corp',
            'Due in 2 hours',
            'Sarah J.',
            'HIGH',
            Colors.orange,
            isChecked: false,
          ),
          _buildTaskCard(
            'Prepare Q4 Sales Deck',
            'Today, 4:00 PM',
            'You',
            'NORMAL',
            Colors.blue,
            isChecked: false,
            showPriorityBadge: true,
          ),
          _buildTaskCard(
            'Update CRM contact details',
            'Completed 10:30 AM',
            null,
            'LOW',
            Colors.green,
            isChecked: true,
            isCompleted: true,
          ),
          _buildTaskCard(
            'Email Campaign Draft Review',
            'Tomorrow, 9:00 AM',
            'Marketing Team',
            'NORMAL',
            Colors.blue,
            isChecked: false,
            showPriorityBadge: true,
          ),
          _buildTaskCard(
            'Vendor Negotiation Call',
            'Tomorrow, 2:00 PM',
            'Procurement',
            'URGENT',
            Colors.red,
            isChecked: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int? count, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 32),
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isActive ? AppColors.primary : Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white30, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    String title,
    String due,
    String? assignee,
    String priority,
    Color priorityColor, {
    required bool isChecked,
    bool isCompleted = false,
    bool showPriorityBadge = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: isChecked,
              onChanged: (v) {},
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isCompleted ? Colors.white30 : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (showPriorityBadge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: priorityColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.white30,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      due,
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 12,
                      ),
                    ),
                    if (assignee != null) ...[
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: Colors.white30,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        assignee,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.white12),
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
          _buildStatCard('Pending Tasks', '12', AppColors.primary, 0.6),
          const SizedBox(height: 16),
          _buildStatCard('Completed', '8', Colors.greenAccent, 0.4),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'October 2023',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildCalendarNavIcon(Icons.chevron_left),
                  const SizedBox(width: 8),
                  _buildCalendarNavIcon(Icons.chevron_right),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildCalendar(),
          const SizedBox(height: 64),
          const Text(
            'SCHEDULE FOR TODAY',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildScheduleItem('09:00', 'Team Standup', 'Zoom • 15m', null),
          _buildScheduleItem(
            '11:30',
            'Client Demo: TechFlow',
            'Google Meet • 45m',
            const [
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop',
            ],
            isActive: true,
          ),
          _buildScheduleItem(
            '14:00',
            'Product Review',
            'Conference Room B',
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarNavIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 5,
                width: 280 * progress,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 10,
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

  Widget _buildCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map(
                (d) => SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        _buildCalendarRow(
          ['29', '30', '1', '2', '3', '4', '5'],
          const [false, false, true, true, true, true, true],
          hasDot: const [false, false, false, false, true, false, false],
        ),
        const SizedBox(height: 16),
        _buildCalendarRow(
          ['6', '7', '8', '9', '10', '11', '12'],
          const [true, true, true, true, true, true, true],
          hasDot: const [false, true, false, false, false, false, false],
        ),
      ],
    );
  }

  Widget _buildCalendarRow(
    List<String> days,
    List<bool> isCurrentMonth, {
    List<bool>? hasDot,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (i) {
        final isSelected = days[i] == '4' && isCurrentMonth[i];
        final isToday = days[i] == '7' && isCurrentMonth[i];
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 15,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                days[i],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isCurrentMonth[i]
                            ? (isToday ? AppColors.primary : Colors.white70)
                            : Colors.white12),
                  fontSize: 13,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
              if (hasDot != null && hasDot[i])
                Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScheduleItem(
    String time,
    String title,
    String detail,
    List<String>? avatarUrls, {
    bool isActive = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white24,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : Colors.white24,
                    width: 2,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detail,
                    style: const TextStyle(color: Colors.white30, fontSize: 12),
                  ),
                  if (avatarUrls != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: avatarUrls
                          .map(
                            (url) => Container(
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(url),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
