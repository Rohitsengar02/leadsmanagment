import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:go_router/go_router.dart';

class FormsListScreen extends StatelessWidget {
  const FormsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/forms'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Form Builder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create and manage custom forms for lead capture and data collection.',
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                        const SizedBox(height: 48),
                        _buildFormGrid(context),
                      ],
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

  Widget _buildHeader(BuildContext context) {
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
            onPressed: () => context.go('/forms/builder'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create New Form'),
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
          'Dashboard',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: Colors.white38, size: 16),
        const SizedBox(width: 8),
        const Text(
          'Forms',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFormGrid(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildFormCard(
          context,
          'Contact Lead Form',
          'Capture basic contact information from new leads.',
          12,
          '2h ago',
        ),
        _buildFormCard(
          context,
          'Enterprise Survey',
          'Detailed questionnaire for enterprise-level clients.',
          24,
          '1d ago',
        ),
        _buildFormCard(
          context,
          'Quick Support Ticket',
          'Simplified form for reporting technical issues.',
          5,
          '3d ago',
        ),
        _buildFormCard(
          context,
          'Product Webinar RSVP',
          'Registration form for upcoming product demonstrations.',
          84,
          'Just now',
        ),
      ],
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    String title,
    String desc,
    int submissions,
    String lastSubmit,
  ) {
    return InkWell(
      onTap: () => context.go('/forms/builder'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUBMISSIONS',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$submissions',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'LAST SUBMIT',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastSubmit,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
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
