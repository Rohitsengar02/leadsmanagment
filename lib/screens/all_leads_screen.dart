import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/sidebar.dart';
import '../widgets/custom_bottom_bar.dart';

class AllLeadsScreen extends StatelessWidget {
  const AllLeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    final leads = [
      {'name': 'Satya', 'requirement': 'E-commerce App', 'value': '₹45,000', 'rating': '5 (35)', 'seed': 'Satya'},
      {'name': 'Arjun', 'requirement': 'Fintech Platform', 'value': '₹1.2L', 'rating': '4.8 (12)', 'seed': 'Arjun'},
      {'name': 'Saanvi', 'requirement': 'Service Booking App', 'value': '₹89,000', 'rating': '5 (42)', 'seed': 'Saanvi'},
      {'name': 'Ishaan', 'requirement': 'Delivery Fleet Tech', 'value': '₹65,000', 'rating': '4.9 (28)', 'seed': 'Ishaan'},
      {'name': 'Zoya', 'requirement': 'EdTech Dashboard', 'value': '₹34,500', 'rating': '5 (15)', 'seed': 'Zoya'},
      {'name': 'Kabir', 'requirement': 'AI CRM Integration', 'value': '₹92,000', 'rating': '4.7 (54)', 'seed': 'Kabir'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/leads'),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'All Confirmed Leads',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final lead = leads[index];
                        return GestureDetector(
                          onTap: () => _showLeadDetails(context, lead),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPremiumLeadCard(lead),
                          ),
                        );
                      },
                      childCount: leads.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 1) : null,
    );
  }

  Widget _buildPremiumLeadCard(Map<String, String> lead) {
    final avatarUrl = 'https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECD2),
                  borderRadius: BorderRadius.circular(22),
                  image: DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lead['name']!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.verified, color: Color(0xFFEA4C89), size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead['requirement']!,
                      style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
                        const SizedBox(width: 4),
                        Text(
                          lead['rating']!,
                          style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border, color: Colors.white38, size: 22),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLeadActionIcon(Icons.videocam, isHighlighted: true),
              _buildLeadActionIcon(Icons.phone),
              _buildLeadActionIcon(Icons.chat_bubble),
              _buildLeadActionIcon(Icons.message),
              _buildLeadActionIcon(Icons.paid_outlined, value: lead['value']),
            ],
          ),
        ],
      ),
    );
  }

  void _showLeadDetails(BuildContext context, Map<String, String> lead) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LeadDetails',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Section (Profile)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECD2),
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage('https://api.dicebear.com/7.x/adventurer/png?seed=${lead['seed']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lead['name']!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              Text(lead['requirement']!, style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10),
                  // History/Timeline
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Activity Timeline', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _buildTimelineItem('Proposal Sent', '₹45,000 package shared', 'Today, 11:30 AM', Icons.description, Colors.blue),
                        _buildTimelineItem('Meeting Completed', 'Technical scope discussed', 'Yesterday, 04:00 PM', Icons.videocam, Colors.green),
                        _buildTimelineItem('Inquiry Received', 'Via LinkedIn Ads', 'Jan 18, 2025', Icons.campaign, Colors.orange),
                      ],
                    ),
                  ),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(child: _buildBigActionButton('WhatsApp', Icons.chat, const Color(0xFF25D366))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildBigActionButton('Call', Icons.phone, const Color(0xFFCCFF00).withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _buildTimelineItem(String title, String desc, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLeadActionIcon(IconData icon, {bool isHighlighted = false, String? value}) {
    return Container(
      width: 55,
      height: 50,
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFEA4C89) : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: value != null 
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white54, size: 16),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            )
          : Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
