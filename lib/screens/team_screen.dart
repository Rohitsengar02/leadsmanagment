import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/team'),
          Expanded(
            child: Column(
              children: [
                _buildTopNav(context, isMobile),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildMainContent(context, isMobile)),
                      if (!isMobile)
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                          ),
                          child: _buildPermissionsEditor(isMobile),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 6) : null, // Team index or similar
    );
  }

  Widget _buildTopNav(BuildContext context, bool isMobile) {
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
          if (!isMobile) const Text('Team Management', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: Text(isMobile ? 'Invite' : 'Invite Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCFF00),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 12 : 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Team', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Manage access, roles, and permissions for your organization.', style: TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 32),
          _buildSearchAndFilters(isMobile),
          const SizedBox(height: 24),
          if (isMobile) _buildMobileMemberList(context) else _buildMembersTable(),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white24, size: 20),
                SizedBox(width: 12),
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search...', hintStyle: TextStyle(color: Colors.white24, fontSize: 13), border: InputBorder.none))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
          child: const Icon(Icons.filter_list, color: Colors.white70, size: 20),
        ),
      ],
    );
  }

  Widget _buildMobileMemberList(BuildContext context) {
    return Column(
      children: [
        _buildMemberCard(context, 'Alex Rivera', 'Super Admin', Colors.purple, 'Active', true),
        _buildMemberCard(context, 'Sarah Chen', 'Editor', Colors.blue, 'Active', true),
        _buildMemberCard(context, 'Mike Ross', 'Viewer', Colors.grey, 'Inactive', false),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, String name, String role, Color roleColor, String status, bool isOnline) {
    return GestureDetector(
      onTap: () => _showPermissionsSheet(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.white10, child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: isOnline ? const Color(0xFFCCFF00) : Colors.white24, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(status, style: TextStyle(color: isOnline ? Colors.white70 : Colors.white24, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: roleColor.withValues(alpha: 0.2))),
                  child: Text(role, style: TextStyle(color: roleColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Color(0xFF131313), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: _buildPermissionsEditor(true),
      ),
    );
  }

  Widget _buildMembersTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Members Table Content...', style: TextStyle(color: Colors.white24)))),
    );
  }

  Widget _buildPermissionsEditor(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Permissions', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildPermissionToggle('CRM Access', 'Full read/write access to leads', true),
          _buildPermissionToggle('Data Export', 'Ability to download team data', true),
          _buildPermissionToggle('Admin Panel', 'Access to sensitive system settings', false),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: const Text('Save Permissions', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggle(String title, String desc, bool val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Switch(value: val, onChanged: (v) {}, activeColor: const Color(0xFFCCFF00)),
        ],
      ),
    );
  }
}
