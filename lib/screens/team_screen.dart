import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/team'),
          Expanded(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildMainContent()),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        child: _buildPermissionsEditor(),
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

  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          _buildBreadcrumbs(),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Invite Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        const Text(
          'Settings',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: Colors.white38, size: 16),
        const SizedBox(width: 8),
        const Text(
          'Team Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
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
          const Text(
            'Team Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage access, assign roles, and configure granular permissions for your organization members.',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 48),
          _buildTableFilters(),
          const SizedBox(height: 24),
          _buildMembersTable(),
        ],
      ),
    );
  }

  Widget _buildTableFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search members by name, email...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterBtn(Icons.filter_list, 'Filter'),
        const SizedBox(width: 12),
        _buildFilterBtn(Icons.file_upload_outlined, 'Export'),
      ],
    );
  }

  Widget _buildFilterBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'MEMBER',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'ROLE',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'LAST ACTIVE',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          _buildMemberRow(
            'Alex Rivera',
            'alex@company.com',
            'Super Admin',
            Colors.purple,
            'Active',
            true,
            '2 mins ago',
            isActive: true,
          ),
          _buildMemberRow(
            'Sarah Chen',
            'sarah@company.com',
            'Editor',
            Colors.blue,
            'Active',
            true,
            '1 hour ago',
          ),
          _buildMemberRow(
            'Mike Ross',
            'mike@company.com',
            'Viewer',
            Colors.grey,
            'Inactive',
            false,
            '2 days ago',
          ),
          _buildMemberRow(
            'Jessica Pearson',
            'jessica@company.com',
            'Billing',
            Colors.orange,
            'Active',
            true,
            '5 mins ago',
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMemberRow(
    String name,
    String email,
    String role,
    Color roleColor,
    String status,
    bool isOnline,
    String lastActive, {
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.transparent,
        border: isActive
            ? Border(left: BorderSide(color: AppColors.primary, width: 3))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white10,
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: roleColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                role,
                style: TextStyle(
                  color: roleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: isOnline ? Colors.white70 : Colors.white24,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              lastActive,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Text(
            'Showing 1-4 of 24 members',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const Spacer(),
          _buildPageBtn(Icons.chevron_left, false),
          const SizedBox(width: 12),
          _buildPageBtn(Icons.chevron_right, true),
        ],
      ),
    );
  }

  Widget _buildPageBtn(IconData icon, bool enabled) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Icon(
        icon,
        color: enabled ? Colors.white70 : Colors.white12,
        size: 20,
      ),
    );
  }

  Widget _buildPermissionsEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permissions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Super Admin • Alex Rivera',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Icon(Icons.close, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Super Admins have full access to all resources. Be careful when assigning this role.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildPermissionSection('CRM ACCESS', [
            _PermissionToggle(
              'View Pipelines',
              'Read access to all deal pipelines',
              true,
            ),
            _PermissionToggle(
              'Edit Deals',
              'Create and modify deal records',
              true,
            ),
            _PermissionToggle(
              'Delete Deals',
              'Permanently remove deal data',
              false,
            ),
          ]),
          const SizedBox(height: 40),
          _buildPermissionSection('DATA MANAGEMENT', [
            _PermissionToggle(
              'Export Contacts',
              'Download CSV/Excel reports',
              true,
            ),
            _PermissionToggle(
              'Bulk Import',
              'Upload data from external sources',
              true,
            ),
          ]),
          const SizedBox(height: 40),
          _buildPermissionSection('ADMINISTRATIVE', [
            _PermissionToggle(
              'Manage Users',
              'Invite and remove team members',
              true,
            ),
            _PermissionToggle(
              'Billing Access',
              'View invoices and manage subscription',
              false,
            ),
          ]),
          const SizedBox(height: 64),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white12),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ...items,
      ],
    );
  }
}

class _PermissionToggle extends StatelessWidget {
  final String title;
  final String desc;
  final bool value;

  const _PermissionToggle(this.title, this.desc, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
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
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
