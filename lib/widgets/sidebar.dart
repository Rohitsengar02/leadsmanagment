import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:go_router/go_router.dart';

class SideBar extends StatelessWidget {
  final String activeRoute;
  const SideBar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF5821C4)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.diamond,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CRM Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ENTERPRISE',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _NavTile(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isActive: activeRoute == '/dashboard',
                  onTap: () => context.go('/dashboard'),
                ),
                _NavTile(
                  icon: Icons.group_outlined,
                  label: 'Contacts',
                  isActive: activeRoute == '/leads',
                  onTap: () => context.go('/leads'),
                ),
                _NavTile(
                  icon: Icons.view_kanban_outlined,
                  label: 'Sales Pipeline',
                  isActive: activeRoute == '/pipeline',
                  onTap: () => context.go('/pipeline'),
                ),
                _NavTile(
                  icon: Icons.notifications_none_outlined,
                  label: 'Notifications',
                  isActive: activeRoute == '/notifications',
                  badge: '12',
                  onTap: () => context.go('/notifications'),
                ),
                _NavTile(
                  icon: Icons.dynamic_form_outlined,
                  label: 'Form Builder',
                  isActive: activeRoute == '/forms',
                  onTap: () => context.go('/forms'),
                ),
                _NavTile(
                  icon: Icons.description_outlined,
                  label: 'Proposals',
                  isActive: activeRoute == '/proposals',
                  onTap: () => context.go('/proposals'),
                ),
                _NavTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'Inbox',
                  isActive: activeRoute == '/inbox',
                  onTap: () {},
                ),
                _NavTile(
                  icon: Icons.bar_chart_outlined,
                  label: 'Reports',
                  isActive: activeRoute == '/analytics',
                  onTap: () => context.go('/analytics'),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'SYSTEM',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _NavTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isActive: activeRoute == '/settings',
                  onTap: () => context.go('/settings'),
                ),
                _NavTile(
                  icon: Icons.help_outline,
                  label: 'Support',
                  isActive: activeRoute == '/help',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=alex',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Morgan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sales Lead',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.expand_more,
                      color: Colors.white38,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _NavTile(
            icon: Icons.logout,
            label: 'Sign Out',
            isActive: false,
            onTap: () => context.go('/'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final String? badge;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (badge != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white24
                        : AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
