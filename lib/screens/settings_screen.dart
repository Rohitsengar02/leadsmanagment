import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/settings'),
          Expanded(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(
                  child: Row(
                    children: [
                      _buildSettingsSubSidebar(),
                      Expanded(child: _buildMainContent()),
                    ],
                  ),
                ),
                _buildFooter(),
              ],
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
          const Text(
            'CRM Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 48),
          Container(
            width: 320,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search leads, deals...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const Spacer(),
          _buildNavTextItem('Dashboard'),
          _buildNavTextItem('Leads'),
          _buildNavTextItem('Deals'),
          _buildNavTextItem('Reports'),
          const SizedBox(width: 24),
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: Colors.white70),
              Positioned(
                right: 0,
                top: 0,
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
          ),
          const SizedBox(width: 24),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTextItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingsSubSidebar() {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                'Home',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 12,
                ),
              ),
              Text(
                'Account',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSubNavItem(Icons.person_outline, 'Profile', true),
          _buildSubNavItem(Icons.settings_outlined, 'Preferences', false),
          _buildSubNavItem(Icons.extension_outlined, 'Integrations', false),
          _buildSubNavItem(Icons.security_outlined, 'Security', false),
          _buildSubNavItem(Icons.payment_outlined, 'Billing', false),
          const Spacer(),
          _buildUpgradeCard(),
        ],
      ),
    );
  }

  Widget _buildSubNavItem(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : Colors.white24,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUpgradeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: Colors.purpleAccent,
            size: 24,
          ),
          const SizedBox(height: 12),
          const Text(
            'Upgrade Plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Unlock advanced features and more integrations.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Plans',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeaderCard(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAppearanceCard()),
              const SizedBox(width: 32),
              Expanded(child: _buildIntegrationsCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/300?u=alex_morgan',
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alex Morgan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Senior Sales Executive • New York, USA',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
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
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Upload New Photo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'FULL NAME',
                  'Alex Morgan',
                  Icons.person_outline,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildTextField(
                  'JOB TITLE',
                  'Senior Sales Executive',
                  Icons.work_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'EMAIL ADDRESS',
            'alex.morgan@crmpro.com',
            Icons.email_outlined,
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: const Text(
                'Verified',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value,
    IconData icon, {
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.white24, size: 20),
              border: InputBorder.none,
              suffixIcon: suffix != null
                  ? Padding(padding: const EdgeInsets.all(12), child: suffix)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Appearance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize your interface theme.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.dark_mode_outlined, color: Colors.white24),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildThemeOption(Icons.light_mode_outlined, 'Light', false),
                _buildThemeOption(Icons.dark_mode, 'Dark', true),
                _buildThemeOption(Icons.computer, 'System', false),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildToggleItem(
            'Desktop Notifications',
            'Receive push alerts for new leads.',
            true,
          ),
          const SizedBox(height: 24),
          _buildToggleItem(
            'Email Digests',
            'Weekly summary of your performance.',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D263A) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border.all(color: Colors.white.withValues(alpha: 0.1))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white38,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white38,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String desc, bool value) {
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
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primary),
      ],
    );
  }

  Widget _buildIntegrationsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Integrations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your connected tools.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildIntegrationItem(
            'Slack',
            'Connected to #sales-alerts',
            true,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildIntegrationItem(
            'Gmail',
            'Syncing contacts...',
            true,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildIntegrationItem('Zoom', 'Not connected', false, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildIntegrationItem(
    String name,
    String status,
    bool isConnected,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIntegrationIcon(name),
              color: Colors.white70,
              size: 24,
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
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          isConnected
              ? Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: Colors.green,
                )
              : OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }

  IconData _getIntegrationIcon(String name) {
    switch (name) {
      case 'Slack':
        return Icons.chat_bubble_outline;
      case 'Gmail':
        return Icons.email_outlined;
      case 'Zoom':
        return Icons.videocam_outlined;
      default:
        return Icons.extension_outlined;
    }
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Discard Changes',
              style: TextStyle(
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save Changes'),
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
}
