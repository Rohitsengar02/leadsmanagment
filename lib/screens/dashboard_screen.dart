import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/glass_card.dart';
import 'package:leads_management/widgets/sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/dashboard'),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -300,
                  left: -100,
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildKPIs(),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildRevenueChart(),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 1,
                                    child: _buildPipelineChart(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 2, child: _buildRecentLeads()),
                                  const SizedBox(width: 24),
                                  Expanded(flex: 1, child: _buildAIWidget()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: Colors.white38,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Welcome back, Alex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 300,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search leads, data...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
          const SizedBox(width: 24),
          _buildActionIcon(Icons.notifications_none, hasBadge: true),
          const SizedBox(width: 12),
          _buildActionIcon(Icons.chat_bubble_outline),
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
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildKPIs() {
    return Row(
      children: [
        Expanded(
          child: _buildKPICloud(
            'Total Leads',
            '1,248',
            '+12%',
            Icons.group,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildKPICloud(
            'Hot Leads',
            '86',
            '+5%',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildKPICloud(
            'Conversion Rate',
            '24.8%',
            '-2%',
            Icons.percent,
            Colors.pink,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildKPICloud(
            'Pending Follow-ups',
            '14',
            '0%',
            Icons.schedule_send,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICloud(
    String label,
    String value,
    String trend,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trend.startsWith('+')
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: trend.startsWith('+')
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return GlassCard(
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
                    'Revenue Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Year to Date Growth',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildChartTab('12M', isActive: true),
                  _buildChartTab('6M'),
                  _buildChartTab('30D'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Center(
              child: Text(
                '[ Revenue Chart Placeholder ]',
                style: TextStyle(color: Colors.white10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPipelineChart() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pipeline Stages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 32),
          _buildStageRow('Leads', 1248, 1.0, Colors.indigo),
          const SizedBox(height: 12),
          _buildStageRow(
            'Contacted',
            936,
            0.75,
            Colors.indigo.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          _buildStageRow('Qualified', 452, 0.45, AppColors.primary),
          const SizedBox(height: 12),
          _buildStageRow(
            'Proposal',
            128,
            0.20,
            AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          _buildStageRow('Closed', 86, 0.12, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStageRow(String label, int value, double percent, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentLeads() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Leads',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.white.withValues(alpha: 0.02),
              ),
              dataRowMaxHeight: 64,
              columns: const [
                DataColumn(
                  label: Text(
                    'LEAD NAME',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'COMPANY',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'DEAL VALUE',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: [
                _buildLeadRow(
                  'Sarah Jenkins',
                  'TechFlow Inc.',
                  'Qualified',
                  '\$12,500',
                  Colors.green,
                ),
                _buildLeadRow(
                  'Michael Ross',
                  'Apex Solutions',
                  'Contacted',
                  '\$8,200',
                  Colors.blue,
                ),
                _buildLeadRow(
                  'David Lee',
                  'Quantum Corp',
                  'New',
                  '\$24,000',
                  Colors.grey,
                ),
                _buildLeadRow(
                  'Emma Lewis',
                  'BrightPath',
                  'Negotiation',
                  '\$18,750',
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildLeadRow(
    String name,
    String company,
    String status,
    String value,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: statusColor.withValues(alpha: 0.2),
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            company,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Color(0xFF5821C4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1), // Border effect
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF13111C).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Insight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: 'Based on recent engagement patterns, '),
                  TextSpan(
                    text: 'Acme Corp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' shows a '),
                  TextSpan(
                    text: '85% probability',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' of closing this week.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ACTION ITEM',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'High Priority',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Send final contract review to Acme Corp CEO.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Take Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
