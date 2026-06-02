import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class FormsListScreen extends StatelessWidget {
  const FormsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/forms'),
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
                        const Text('Forms', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Manage custom data collection forms and capture leads.', style: TextStyle(color: Colors.white38, fontSize: 13)),
                        const SizedBox(height: 32),
                        _buildFormGrid(context, isMobile),
                        if (isMobile) const SizedBox(height: 100),
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
          ElevatedButton.icon(
            onPressed: () => context.go('/forms/builder'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(isMobile ? 'New' : 'Create Form'),
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

  Widget _buildFormGrid(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildFormCard(context, 'Lead Capture 2024', 'General inquiry form', 124, '2h ago', isMobile),
          const SizedBox(height: 16),
          _buildFormCard(context, 'Enterprise Audit', 'High-value client survey', 45, '1d ago', isMobile),
          const SizedBox(height: 16),
          _buildFormCard(context, 'Event RSVP', 'Webinar registration', 890, 'Just now', isMobile),
        ],
      );
    }
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildFormCard(context, 'Lead Capture 2024', 'General inquiry form', 124, '2h ago', isMobile),
        _buildFormCard(context, 'Enterprise Audit', 'High-value client survey', 45, '1d ago', isMobile),
        _buildFormCard(context, 'Event RSVP', 'Webinar registration', 890, 'Just now', isMobile),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context, String title, String desc, int submissions, String lastSubmit, bool isMobile) {
    return InkWell(
      onTap: () => context.go('/forms/builder'),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: isMobile ? double.infinity : 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFCCFF00).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.assignment_outlined, color: Color(0xFFCCFF00), size: 24)),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SUBMISSIONS', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('$submissions', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('LATEST', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(lastSubmit, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
