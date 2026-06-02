import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/settings'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, isMobile),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 20 : 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Manage your account, preferences, and data integrations.', style: TextStyle(color: Colors.white38, fontSize: 13)),
                        const SizedBox(height: 40),
                        if (isMobile) ...[
                          _buildProfileCard(isMobile),
                          const SizedBox(height: 24),
                          _buildSettingsSection('APPEARANCE', [
                            _buildToggle('Dark Mode', true),
                            _buildToggle('Desktop Notifications', true),
                          ]),
                          const SizedBox(height: 24),
                          _buildSettingsSection('INTEGRATIONS', [
                            _buildIntegrationItem('Slack', 'Connected', true, Colors.green),
                            _buildIntegrationItem('Gmail', 'Connected', true, Colors.orange),
                          ]),
                          const SizedBox(height: 100),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildProfileCard(isMobile)),
                              const SizedBox(width: 32),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    _buildSettingsSection('APPEARANCE', [
                                      _buildToggle('Dark Mode', true),
                                      _buildToggle('Push Alerts', true),
                                    ]),
                                    const SizedBox(height: 24),
                                    _buildSettingsSection('SECURITY', [
                                      _buildToggle('Two-Factor Auth', false),
                                      _buildToggle('Face ID', true),
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 4) : null,
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(color: const Color(0xFF131313), border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => context.go('/dashboard'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex')),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Alex Morgan', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Senior Account Manager', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          _buildInput('Full Name', 'Alex Morgan'),
          const SizedBox(height: 20),
          _buildInput('Email', 'alex@neon-crm.com'),
        ],
      ),
    );
  }

  Widget _buildInput(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))), child: Text(value, style: const TextStyle(color: Colors.white70, fontSize: 14))),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Switch(value: val, onChanged: (v) {}, activeColor: const Color(0xFFCCFF00)),
        ],
      ),
    );
  }

  Widget _buildIntegrationItem(String name, String status, bool isConnected, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const Spacer(),
          Text(status, style: const TextStyle(color: Colors.white24, fontSize: 11)),
        ],
      ),
    );
  }
}
