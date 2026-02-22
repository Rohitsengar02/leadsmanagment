import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/analytics'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSubHeader(),
                        const SizedBox(height: 32),
                        _buildKPIs(),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildRevenueChart()),
                            const SizedBox(width: 32),
                            Expanded(flex: 1, child: _buildLeadSources()),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildTopAgents()),
                            const SizedBox(width: 32),
                            Expanded(child: _buildRecentActivity()),
                          ],
                        ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back, here\'s what\'s happening today.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search analytics...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 24),
          _buildActionIcon(Icons.notifications_none, hasBadge: true),
          const SizedBox(width: 16),
          _buildActionIcon(Icons.help_outline),
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
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildTab('Overview', true),
            const SizedBox(width: 12),
            _buildTab('Performance', false),
            const SizedBox(width: 12),
            _buildTab('Demographics', false),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.white38, size: 16),
                  SizedBox(width: 12),
                  Text(
                    'Last 30 Days',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white38,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white38,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildKPIs() {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'ROI (Return on Investment)',
            '320%',
            '+12%',
            true,
            Icons.attach_money,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildKPICard(
            'CAC (Acquisition Cost)',
            '₹145',
            '-5%',
            false,
            Icons.people_outline,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildKPICard(
            'LTV (Lifetime Value)',
            '₹4,200',
            '+2%',
            true,
            Icons.local_offer_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    String trend,
    bool isPositive,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white38, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'vs last month',
                    style: TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.trending_up,
              color: Colors.white.withValues(alpha: 0.05),
              size: 64,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
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
                    'Total Revenue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Year to Date (YTD) Performance',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 250,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RevenueChartPainter(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                    ]
                    .map(
                      (m) => Text(
                        m,
                        style: TextStyle(color: Colors.white24, fontSize: 11),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadSources() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lead Sources',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Traffic Channel Breakdown',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: _DonutChartPainter(),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Leads',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                        const Text(
                          '12,402',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildSourceItem('Organic', '35%', Colors.purpleAccent),
          _buildSourceItem('LinkedIn', '25%', Colors.cyanAccent),
          _buildSourceItem('Referrals', '20%', Colors.pinkAccent),
          _buildSourceItem('Paid Ads', '20%', Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String label, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          Text(
            percent,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAgents() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
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
                    'Top Performing Agents',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Deals closed this month',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildAgentRow('Sarah Jenkins', '₹42k', 0.8, Colors.purpleAccent),
          _buildAgentRow('Mike Ross', '₹38k', 0.7, Colors.cyanAccent),
          _buildAgentRow('Jessica Pearson', '₹35k', 0.65, Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildAgentRow(
    String name,
    String value,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white10,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Latest system updates',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildActivityItem(
            'Just now',
            'Report exported by',
            'Jane Doe',
            Colors.purpleAccent,
          ),
          _buildActivityItem(
            '2 hours ago',
            'New lead acquired via',
            'LinkedIn Campaign',
            Colors.cyanAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String time,
    String action,
    String target,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.white24, fontSize: 11),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  children: [
                    TextSpan(text: '$action '),
                    TextSpan(
                      text: target,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class _RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.3),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width, size.height * 0.1),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, paint);

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (var i = 0; i < 5; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Highpoint marker
    final markerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(points[7], 4, markerPaint);

    // Label for marker
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '₹84,230',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(points[7].dx - 30, points[7].dy - 30, 60, 20),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.8),
    );
    textPainter.paint(canvas, Offset(points[7].dx - 20, points[7].dy - 26));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 25.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;

    // Organic
    paint.color = Colors.purpleAccent;
    double sweep1 = 2 * math.pi * 0.35;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep1,
      false,
      paint,
    );
    startAngle += sweep1;

    // LinkedIn
    paint.color = Colors.cyanAccent;
    double sweep2 = 2 * math.pi * 0.25;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep2,
      false,
      paint,
    );
    startAngle += sweep2;

    // Referrals
    paint.color = Colors.pinkAccent;
    double sweep3 = 2 * math.pi * 0.20;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep3,
      false,
      paint,
    );
    startAngle += sweep3;

    // Paid Ads
    paint.color = Colors.orangeAccent;
    double sweep4 = 2 * math.pi * 0.20;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep4,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
