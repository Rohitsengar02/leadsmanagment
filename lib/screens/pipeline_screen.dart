import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  int _selectedStageIndex = 0;
  final List<String> _stages = ['NEW', 'CONTACTED', 'QUALIFIED', 'PROPOSAL'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/pipeline'),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    const Color(0xFFCCFF00).withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(isMobile),
                  if (isMobile) _buildMobileStageTabs(),
                  Expanded(
                    child: isMobile ? _buildMobileKanbanContent() : _buildDesktopKanbanContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 2) : null,
    );
  }

  Widget _buildMobileStageTabs() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _stages.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedStageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedStageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFCCFF00) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? const Color(0xFFCCFF00) : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Center(
                child: Text(
                  _stages[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileKanbanContent() {
    final stageData = [
      {
        'cards': [
          _KanbanCardData('Enterprise License', 'TechFlow Inc.', 'New Lead', '\$24,000', 'Today', Colors.blueAccent),
          _KanbanCardData('Q3 Marketing Audit', 'Global Media', 'High Priority', '\$12,500', '2d ago', Colors.amber),
          _KanbanCardData('SaaS Platform Migration', 'Nexus Systems', 'Inbound', '\$8,200', '4h ago', Colors.grey),
        ]
      },
      {
        'cards': [
          _KanbanCardData('Acme Corp Expansion', 'Acme Corp', 'High', '\$15,000', 'Follow up', Colors.amber, isWarning: true),
          _KanbanCardData('Annual Subscription', 'Starlight Ventures', 'Follow-up', '\$30,000', '1d ago', Colors.grey),
        ]
      },
      {
        'cards': [
          _KanbanCardData('Enterprise Implementation', 'Cyberdyne Systems', 'Hot Deal', '\$85,000', 'Yesterday', Colors.pinkAccent),
          _KanbanCardData('Custom Module Dev', 'Innovate LLC', 'Negotiation', '\$35,000', '3d ago', Colors.blue),
        ]
      },
      {
        'cards': [
          _KanbanCardData('Cloud Infrastructure', 'Skynet Corp', 'Review', '\$42,000', 'Today', Colors.orange),
        ]
      },
    ];

    final currentStage = stageData[_selectedStageIndex];
    final List<_KanbanCardData> cards = currentStage['cards'] as List<_KanbanCardData>;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return _KanbanCard(data: cards[index]);
      },
    );
  }

  Widget _buildDesktopKanbanContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKanbanColumn('NEW', 5, '62k', Colors.blueAccent, [
            _KanbanCardData('Enterprise License', 'TechFlow Inc.', 'New Lead', '\$24,000', 'Today', Colors.blueAccent),
            _KanbanCardData('Q3 Marketing Audit', 'Global Media', 'High Priority', '\$12,500', '2d ago', Colors.amber),
            _KanbanCardData('SaaS Platform Migration', 'Nexus Systems', 'Inbound', '\$8,200', '4h ago', Colors.grey),
          ]),
          const SizedBox(width: 24),
          _buildKanbanColumn('CONTACTED', 3, '45k', Colors.purpleAccent, [
            _KanbanCardData('Acme Corp Expansion', 'Acme Corp', 'High', '\$15,000', 'Follow up', Colors.amber, isWarning: true),
            _KanbanCardData('Annual Subscription', 'Starlight Ventures', 'Follow-up', '\$30,000', '1d ago', Colors.grey),
          ]),
          const SizedBox(width: 24),
          _buildKanbanColumn('QUALIFIED', 2, '120k', const Color(0xFFCCFF00), [
            _KanbanCardData('Enterprise Implementation', 'Cyberdyne Systems', 'Hot Deal', '\$85,000', 'Yesterday', Colors.pinkAccent),
            _KanbanCardData('Custom Module Dev', 'Innovate LLC', 'Negotiation', '\$35,000', '3d ago', Colors.blue),
          ]),
          const SizedBox(width: 24),
          _buildKanbanColumn('PROPOSAL', 1, '42k', Colors.indigoAccent, [
            _KanbanCardData('Cloud Infrastructure', 'Skynet Corp', 'Review', '\$42,000', 'Today', Colors.orange),
          ]),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isMobile)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                          onPressed: () => context.go('/dashboard'),
                        ),
                      if (isMobile) const SizedBox(width: 12),
                      const Text(
                        'Pipeline',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Track your deals', style: TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
              if (!isMobile)
                Row(
                  children: [
                    _buildStatPill('TOTAL VALUE', '\$1.2M', '+12%', Colors.greenAccent),
                    const SizedBox(width: 16),
                    _buildStatPill('ACTIVE DEALS', '45', '+5%', Colors.greenAccent),
                  ],
                ),
              if (isMobile)
                GestureDetector(
                  onTap: () => _showFilterDrawer(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFCCFF00).withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.tune, color: Color(0xFFCCFF00), size: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search deals...',
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Colors.white24, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 16),
                _buildFilterPill(Icons.person, 'Owners'),
                const SizedBox(width: 8),
                _buildFilterPill(Icons.calendar_today, 'This Month'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1012),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildFilterPill(Icons.person, 'Owners'),
            const SizedBox(height: 12),
            _buildFilterPill(Icons.calendar_today, 'Date Range'),
            const SizedBox(height: 12),
            _buildFilterPill(Icons.priority_high, 'Priority'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCFF00),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Apply Filters', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, String trend, Color trendColor) {
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
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(trend, style: TextStyle(color: trendColor, fontSize: 11, fontWeight: FontWeight.bold)),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color ?? Colors.white38, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 16),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(String title, int count, String value, Color color, List<_KanbanCardData> cards) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
                    child: Text('$count', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text('\$$value', style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.5), Colors.transparent])),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) => _KanbanCard(data: cards[index]),
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
              side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanbanCardData {
  final String title, company, tag, value, time;
  final Color tagColor;
  final bool isWarning;
  _KanbanCardData(this.title, this.company, this.tag, this.value, this.time, this.tagColor, {this.isWarning = false});
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
                  border: Border.all(color: data.tagColor.withValues(alpha: 0.2)),
                ),
                child: Text(data.tag, style: TextStyle(color: data.tagColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
              const Icon(Icons.more_horiz, color: Colors.white24, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(data.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          Text(data.company, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=user')),
              const SizedBox(width: 8),
              if (data.isWarning) const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 14),
              Text(data.time, style: TextStyle(color: data.isWarning ? Colors.amber : Colors.white38, fontSize: 11)),
              const Spacer(),
              Text(data.value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
