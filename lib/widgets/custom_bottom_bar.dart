import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final navIcons = [
      Icons.dashboard_outlined,
      Icons.list_alt_outlined,
      Icons.add, // Center
      Icons.view_kanban_outlined,
      Icons.bar_chart_outlined,
    ];

    final routes = [
      '/dashboard',
      '/all-leads',
      '', // Center
      '/pipeline',
      '/analytics',
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF13111C),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          // Water Drop Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            alignment: Alignment(
              -1.0 + (selectedIndex * (2.0 / (navIcons.length - 1))),
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / navIcons.length,
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFF00).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navIcons.length, (index) {
              if (index == 2) {
                return _buildCenteredAddButton(context);
              }
              return _buildWaterDropNavItem(context, navIcons[index], index, routes[index]);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterDropNavItem(BuildContext context, IconData icon, int index, String route) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (route.isNotEmpty) {
          context.go(route);
        }
      },
      child: Container(
        width: 50,
        height: 70,
        color: Colors.transparent,
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFCCFF00) : Colors.white38,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCenteredAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCategoryBottomSheet(context),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFCCFF00),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCCFF00).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final remainingOptions = [
      {'icon': Icons.today_outlined, 'label': "Today's Leads", 'route': '/today-leads'},
      {'icon': Icons.description_outlined, 'label': 'Proposals', 'route': '/proposals'},
      {'icon': Icons.notifications_none_outlined, 'label': 'Alerts', 'route': '/notifications'},
      {'icon': Icons.smart_toy_outlined, 'label': 'Neon AI', 'route': '/ai-assistant'},
      {'icon': Icons.dynamic_form_outlined, 'label': 'Forms', 'route': '/forms'},
      {'icon': Icons.settings_outlined, 'label': 'Settings', 'route': '/settings'},
      {'icon': Icons.group_outlined, 'label': 'Team', 'route': '/team'},
      {'icon': Icons.analytics_outlined, 'label': 'Stats', 'route': '/analytics'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Color(0xFF0F1012),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Quick Access',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: remainingOptions.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                context.go(remainingOptions[index]['route'] as String);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCFF00).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFFCCFF00).withValues(alpha: 0.2)),
                                    ),
                                    child: Icon(remainingOptions[index]['icon'] as IconData, color: const Color(0xFFCCFF00), size: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    remainingOptions[index]['label'] as String,
                                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
