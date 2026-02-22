import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';

class PipelineScreen extends StatelessWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(activeRoute: '/pipeline'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1634152962476-4b8a00e1915c?q=80&w=2000&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildKanbanColumn(
                            'NEW',
                            5,
                            '62k',
                            Colors.blueAccent,
                            [
                              _KanbanCardData(
                                'Enterprise License',
                                'TechFlow Inc.',
                                'New Lead',
                                '\$24,000',
                                'Today',
                                Colors.blueAccent,
                              ),
                              _KanbanCardData(
                                'Q3 Marketing Audit',
                                'Global Media',
                                'High Priority',
                                '\$12,500',
                                '2d ago',
                                Colors.amber,
                              ),
                              _KanbanCardData(
                                'SaaS Platform Migration',
                                'Nexus Systems',
                                'Inbound',
                                '\$8,200',
                                '4h ago',
                                Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          _buildKanbanColumn(
                            'CONTACTED',
                            3,
                            '45k',
                            Colors.purpleAccent,
                            [
                              _KanbanCardData(
                                'Acme Corp Expansion',
                                'Acme Corp',
                                'High',
                                '\$15,000',
                                'Follow up',
                                Colors.amber,
                                isWarning: true,
                              ),
                              _KanbanCardData(
                                'Annual Subscription',
                                'Starlight Ventures',
                                'Follow-up',
                                '\$30,000',
                                '1d ago',
                                Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          _buildKanbanColumn(
                            'QUALIFIED',
                            2,
                            '120k',
                            AppColors.primary,
                            [
                              _KanbanCardData(
                                'Enterprise Implementation',
                                'Cyberdyne Systems',
                                'Hot Deal',
                                '\$85,000',
                                'Yesterday',
                                Colors.pinkAccent,
                              ),
                              _KanbanCardData(
                                'Custom Module Dev',
                                'Innovate LLC',
                                'Negotiation',
                                '\$35,000',
                                '3d ago',
                                Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          _buildKanbanColumn(
                            'PROPOSAL',
                            1,
                            '42k',
                            Colors.indigoAccent,
                            [
                              _KanbanCardData(
                                'Cloud Infrastructure',
                                'Skynet Corp',
                                'Review',
                                '\$42,000',
                                'Today',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF171122).withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Pipeline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your deal flow and track progress across all stages.',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatPill(
                    'TOTAL VALUE',
                    '\$1.2M',
                    '+12%',
                    Colors.greenAccent,
                  ),
                  const SizedBox(width: 16),
                  _buildStatPill(
                    'ACTIVE DEALS',
                    '45',
                    '+5%',
                    Colors.greenAccent,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 320,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search deals, companies...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white38,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterPill(Icons.person, 'Owners'),
              const SizedBox(width: 8),
              _buildFilterPill(Icons.calendar_today, 'This Month'),
              const SizedBox(width: 8),
              _buildFilterPill(
                Icons.priority_high,
                'High Priority',
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    String label,
    String value,
    String trend,
    Color trendColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.white38, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white38,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(
    String title,
    int count,
    String value,
    Color color,
    List<_KanbanCardData> cards,
  ) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '\$$value',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.5), Colors.transparent],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return _KanbanCard(data: card);
              },
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Lead'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white38,
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                style: BorderStyle.solid,
              ),
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

class _KanbanCardData {
  final String title;
  final String company;
  final String tag;
  final String value;
  final String time;
  final Color tagColor;
  final bool isWarning;

  _KanbanCardData(
    this.title,
    this.company,
    this.tag,
    this.value,
    this.time,
    this.tagColor, {
    this.isWarning = false,
  });
}

class _KanbanCard extends StatelessWidget {
  final _KanbanCardData data;
  const _KanbanCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: data.tagColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: data.tagColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  data.tag,
                  style: TextStyle(
                    color: data.tagColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.white24, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data.company,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBUGoFyLjyw1_yYRuIAR5HzxgO_LWUqbwZYIreVwJj_kZPNW_EdGgo3LyAz313-4qQmfuyWBDzXEMiPNYWxNhLjGH6Hh_zzgMIZp47ChD7DXlvMM6x4Ks9LIhFO4SVkfHsKlLz00ICh4DM36vosQRl1AHVVHzI3jkR0GoXSFsdvoYDKtLGhXLmoWLSOoDEKl65LuDPRmjIF8IU0MPy51MVBe8Z1ahN_vmbHEB-CW_XVmbgTEcS-nMBjtlo64Rlqw5z3_EhHjU5NPGI',
                ),
              ),
              const SizedBox(width: 8),
              if (data.isWarning)
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 14,
                ),
              Text(
                data.time,
                style: TextStyle(
                  color: data.isWarning ? Colors.amber : Colors.white38,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                data.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
