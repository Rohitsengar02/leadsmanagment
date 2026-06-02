import 'package:flutter/material.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class ProposalListScreen extends StatelessWidget {
  const ProposalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/proposals'),
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
                        Text(
                          'Proposals',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Generate professional sales proposals and track signature status in real-time.',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                        const SizedBox(height: 32),
                        _buildProposalGrid(context, isMobile),
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
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 2) : null,
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => context.go('/dashboard'),
            ),
          if (!isMobile) _buildBreadcrumbs(),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => context.go('/proposals/builder'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(isMobile ? 'New' : 'Create New Proposal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCFF00),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 12 : 20),
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
    return const Row(
      children: [
        Text('Sales', style: TextStyle(color: Colors.white38, fontSize: 13)),
        SizedBox(width: 8),
        Icon(Icons.chevron_right, color: Colors.white38, size: 16),
        SizedBox(width: 8),
        Text('Proposals', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProposalGrid(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildProposalCard(context, 'Q3 Marketing Strategy', 'Acme Corp', '\$1,700', 'Sent', Colors.blue, isMobile),
          const SizedBox(height: 16),
          _buildProposalCard(context, 'CRM Implementation', 'TechFlow Inc', '\$12,500', 'Signed', Colors.green, isMobile),
          const SizedBox(height: 16),
          _buildProposalCard(context, 'Annual SEO Audit', 'NexGen Digital', '\$3,200', 'Draft', Colors.grey, isMobile),
          const SizedBox(height: 16),
          _buildProposalCard(context, 'Content Plan 2024', 'BlueSky Retail', '\$5,000', 'Expired', Colors.red, isMobile),
        ],
      );
    }
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildProposalCard(context, 'Q3 Marketing Strategy', 'Acme Corp', '\$1,700', 'Sent', Colors.blue, isMobile),
        _buildProposalCard(context, 'CRM Implementation', 'TechFlow Inc', '\$12,500', 'Signed', Colors.green, isMobile),
        _buildProposalCard(context, 'Annual SEO Audit', 'NexGen Digital', '\$3,200', 'Draft', Colors.grey, isMobile),
        _buildProposalCard(context, 'Content Plan 2024', 'BlueSky Retail', '\$5,000', 'Expired', Colors.red, isMobile),
      ],
    );
  }

  Widget _buildProposalCard(
    BuildContext context,
    String title,
    String client,
    String value,
    String status,
    Color statusColor,
    bool isMobile,
  ) {
    return InkWell(
      onTap: () => context.go('/proposals/builder'),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: isMobile ? double.infinity : 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.white24, size: 20),
              ],
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(client, style: const TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('VALUE', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle),
                  child: const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
