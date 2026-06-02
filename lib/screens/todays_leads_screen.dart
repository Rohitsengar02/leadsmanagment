import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/core/theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/glass_card.dart';

class TodaysLeadsScreen extends StatefulWidget {
  const TodaysLeadsScreen({super.key});

  @override
  State<TodaysLeadsScreen> createState() => _TodaysLeadsScreenState();
}

class _TodaysLeadsScreenState extends State<TodaysLeadsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Hot', 'Warm', 'Urgent'

  // Master list of leads stored in state memory
  late List<Map<String, dynamic>> _leads;

  @override
  void initState() {
    super.initState();
    _leads = [
      {
        'name': 'Mudhu Naz',
        'company': 'CreativeHQ',
        'requirement': 'UI Design',
        'time': '7:23 PM',
        'status': 'Available for work',
        'phone': '+91 98765 43210',
        'whatsapp': '+91 98765 43210',
        'temperature': 'Hot',
        'urgency': 'Immediate',
        'image': 'https://robohash.org/mudhu.png?set=set1',
        'bannerText': 'Goal: Brand Refinement & Landing Page Design',
        'bannerColor': const Color(0xFFCCFF00),
        'bannerIcon': Icons.brush_outlined,
        'dealValue': '₹2,50,000',
        'source': 'LinkedIn',
      },
      {
        'name': 'Alex Rivera',
        'company': 'TechFlow Inc.',
        'requirement': 'Custom Software',
        'time': '5:45 PM',
        'status': 'Open to new projects',
        'phone': '+1 (555) 432-1098',
        'whatsapp': '+1 (555) 432-1098',
        'temperature': 'Warm',
        'urgency': 'Urgent',
        'image': 'https://robohash.org/alex.png?set=set1',
        'bannerText': 'Goal: Enterprise CRM Integration Gateway',
        'bannerColor': Colors.blueAccent,
        'bannerIcon': Icons.code,
        'dealValue': '₹5,80,000',
        'source': 'Referral',
      },
      {
        'name': 'Sarah Chen',
        'company': 'Global Media Group',
        'requirement': 'Web Platform',
        'time': '4:20 PM',
        'status': 'Ready to consult',
        'phone': '+852 9123 4567',
        'whatsapp': '+852 9123 4567',
        'temperature': 'Cold',
        'urgency': 'Normal',
        'image': 'https://robohash.org/sarah.png?set=set1',
        'bannerText': 'Goal: Scalable Content Delivery System',
        'bannerColor': Colors.orangeAccent,
        'bannerIcon': Icons.web,
        'dealValue': '₹3,20,000',
        'source': 'Website',
      },
    ];

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLeads {
    return _leads.where((lead) {
      // 1. Filter by Search Query (Name or Company)
      final nameMatches = lead['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final companyMatches = lead['company'] != null &&
          lead['company'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final queryMatch = nameMatches || companyMatches;

      if (!queryMatch) return false;

      // 2. Filter by Chip selection
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Hot') {
        return lead['temperature'] == 'Hot';
      }
      if (_selectedFilter == 'Warm') {
        return lead['temperature'] == 'Warm';
      }
      if (_selectedFilter == 'Urgent') {
        return lead['urgency'] == 'Urgent' || lead['urgency'] == 'Immediate';
      }

      return true;
    }).toList();
  }

  void _openLeadIntakeForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => CyberLimLeadForm(
        onAddLead: (newLead) {
          setState(() {
            _leads.insert(0, newLead);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFCCFF00),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.black),
                  const SizedBox(width: 12),
                  Text(
                    'Lead "${newLead['name']}" qualified in CyberLim CRM!',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final filtered = _filteredLeads;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/leads'),
          Expanded(
            child: Stack(
              children: [
                // Neon glow background elements
                Positioned(
                  top: -250,
                  right: -100,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -100,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFCCFF00).withValues(alpha: 0.02),
                    ),
                  ),
                ),

                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 140,
                      floating: true,
                      pinned: true,
                      backgroundColor: const Color(0xFF0A0B09).withValues(alpha: 0.8),
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFCCFF00), Color(0xFF763AEE)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFCCFF00).withValues(alpha: 0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 22,
                              child: IconButton(
                                icon: const Icon(Icons.add, color: Colors.black, size: 22),
                                onPressed: () => _openLeadIntakeForm(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: const FlexibleSpaceBar(
                        title: Text(
                          "Today's Leads",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => context.go('/dashboard'),
                      ),
                    ),

                    // Search & Filter Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Search Bar
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF161616),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search by client name or company...',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: const Color(0xFFCCFF00).withValues(alpha: 0.7),
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, color: Colors.white54),
                                          onPressed: () => _searchController.clear(),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFCCFF00),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2. Filter Chips
                            SizedBox(
                              height: 42,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildFilterChip('All', Icons.all_inbox),
                                  _buildFilterChip('Hot', Icons.local_fire_department, color: Colors.orangeAccent),
                                  _buildFilterChip('Warm', Icons.wb_sunny_outlined, color: Colors.blueAccent),
                                  _buildFilterChip('Urgent', Icons.warning_amber_rounded, color: Colors.redAccent),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // List of filtered leads
                    filtered.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF121212),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person_search,
                                        size: 64,
                                        color: Colors.white24,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No CRM Leads Found',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _searchQuery.isNotEmpty
                                            ? 'No matching leads found for "$_searchQuery".'
                                            : 'Add a new client by clicking the + button above.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.4),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 32,
                              vertical: 12,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final lead = filtered[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: _buildTodaysLeadCard(lead),
                                  );
                                },
                                childCount: filtered.length,
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
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 3) : null,
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {Color? color}) {
    final isSelected = _selectedFilter == label;
    final themeColor = color ?? const Color(0xFFCCFF00);

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? themeColor.withValues(alpha: 0.12)
                : const Color(0xFF161616),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? themeColor : Colors.white.withValues(alpha: 0.05),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? themeColor : Colors.white54,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysLeadCard(Map<String, dynamic> lead) {
    final name = lead['name'] as String;
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        lead['requirement'] ?? 'CRM Lead',
                        style: const TextStyle(
                          color: Color(0xFFCCFF00),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white38, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          lead['time'] ?? 'Just Now',
                          style: const TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Core Lead Contact Info Row
                Row(
                  children: [
                    // Avatar (Glow Circle containing cartoon avatar)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (lead['bannerColor'] as Color? ?? const Color(0xFFCCFF00)).withValues(alpha: 0.15),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF1E1E1E),
                        child: ClipOval(
                          child: lead['image'] != null && lead['image'].toString().startsWith('http')
                              ? Image.network(
                                  lead['image'],
                                  fit: BoxFit.cover,
                                  width: 56,
                                  height: 56,
                                  errorBuilder: (context, error, stackTrace) => Text(
                                    initials,
                                    style: TextStyle(
                                      color: lead['bannerColor'] ?? const Color(0xFFCCFF00),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        lead['bannerColor'] ?? const Color(0xFFCCFF00),
                                        (lead['bannerColor'] ?? const Color(0xFFCCFF00)).withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name, Company, Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  lead['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (lead['company'] != null) ...[
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '(${lead['company']})',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: lead['temperature'] == 'Hot'
                                      ? Colors.orangeAccent
                                      : lead['temperature'] == 'Warm'
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${lead['status'] ?? "New Lead"} • ${lead['temperature'] ?? "Hot"} Temperature',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Contact Detail Badges (Phone, WhatsApp, Deal Value if present)
                if (lead['phone'] != null || lead['whatsapp'] != null || lead['dealValue'] != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
                    ),
                    child: Column(
                      children: [
                        if (lead['phone'] != null && lead['phone'].toString().isNotEmpty)
                          _buildDetailRow(Icons.phone_outlined, lead['phone']),
                        if (lead['whatsapp'] != null && lead['whatsapp'].toString().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.chat_bubble_outline_rounded, 'WhatsApp: ${lead['whatsapp']}'),
                        ],
                        if (lead['dealValue'] != null) ...[
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.monetization_on_outlined, 'Deal Value: ${lead['dealValue']}'),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionBtn(
                        Icons.add_circle_outline,
                        'Consult',
                        gradientColors: [const Color(0xFFCCFF00), const Color(0xFF88FF00)],
                        textColor: Colors.black,
                        onPressed: () {
                          _showConsultationDialog(lead);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionBtn(
                        Icons.copy,
                        'Copy Contact',
                        gradientColors: [const Color(0xFF1E1E1E), const Color(0xFF2A2A2A)],
                        textColor: Colors.white70,
                        onPressed: () {
                          final phone = lead['phone'] ?? '';
                          Clipboard.setData(ClipboardData(text: phone));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF763AEE),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              content: Text('Copied contact: $phone to clipboard!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom dynamic banner showing the lead's goal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: lead['bannerColor'] ?? const Color(0xFFCCFF00),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(lead['bannerIcon'] ?? Icons.business, color: Colors.black, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lead['bannerText'] ?? 'General Consultation Lead',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFCCFF00).withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    IconData icon,
    String label, {
    required List<Color> gradientColors,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(18),
          boxShadow: gradientColors.first != const Color(0xFF1E1E1E)
              ? [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showConsultationDialog(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CyberLim Consultation',
                    style: TextStyle(color: Color(0xFFCCFF00), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 24),
              Text(
                'Consulting Client: ${lead['name']}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Company: ${lead['company'] ?? "Self-Employed"}',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'UNIVERSAL CLIENT FLOW STATUS',
                style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
              const SizedBox(height: 12),
              _buildFlowCheck('Step 1: Introduction Completed', true),
              _buildFlowCheck('Step 2: Goals & Requirements collection', true),
              _buildFlowCheck('Step 3: Schedule discovery session', false),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Launch Strategy Session', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowCheck(String label, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isDone ? const Color(0xFFCCFF00) : Colors.white24,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isDone ? Colors.white : Colors.white30,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Single-Screen Streamlined CyberLim Lead Consultation Intake Form
class CyberLimLeadForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddLead;

  const CyberLimLeadForm({super.key, required this.onAddLead});

  @override
  State<CyberLimLeadForm> createState() => _CyberLimLeadFormState();
}

class _CyberLimLeadFormState extends State<CyberLimLeadForm> {
  final _formKey = GlobalKey<FormState>();

  // FORM FIELDS CONTROLLERS
  final _nameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _whatsAppCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _projectGoalCtrl = TextEditingController();

  String _projectType = 'Mobile App'; // Mobile App, Web Platform, UI/UX Strategy, Custom Software, IoT Core Systems

  @override
  void initState() {
    super.initState();
    // Pre-populate premium mock defaults for seamless rapid demoing
    _nameCtrl.text = 'Kabir Malhotra';
    _companyCtrl.text = 'CyberLim Systems';
    _phoneCtrl.text = '+91 91111 22222';
    _whatsAppCtrl.text = '+91 91111 22222';
    _addressCtrl.text = 'Neo Plaza, Sector 62';
    _websiteCtrl.text = 'https://cyberlimsystems.io';
    _projectGoalCtrl.text = 'Onboard client leads cleanly into dynamic dashboards';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _companyCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsAppCtrl.dispose();
    _addressCtrl.dispose();
    _websiteCtrl.dispose();
    _projectGoalCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    // Automatically assign a cartoon avatar robot based on the lead's name using Robohash
    final cartoonAvatarUrl = 'https://robohash.org/${Uri.encodeComponent(name)}.png?set=set1';

    final newLead = {
      'name': name,
      'company': _companyCtrl.text.trim().isEmpty ? null : _companyCtrl.text.trim(),
      'requirement': _projectType,
      'time': 'Just Now',
      'status': 'New Lead',
      'phone': _phoneCtrl.text.trim(),
      'whatsapp': _whatsAppCtrl.text.trim(),
      'temperature': 'Hot', // Default temperature
      'urgency': 'Immediate', // Default urgency
      'image': cartoonAvatarUrl, // Dynamically added cartoon profile picture!
      'bannerText': 'Goal: ${_projectGoalCtrl.text.trim().isEmpty ? "General Consultation Strategy" : _projectGoalCtrl.text.trim()}',
      'bannerColor': const Color(0xFFCCFF00),
      'bannerIcon': _projectType == 'Mobile App'
          ? Icons.phone_android
          : _projectType == 'Web Platform'
              ? Icons.web
              : _projectType == 'UI/UX Strategy'
                  ? Icons.brush_outlined
                  : _projectType == 'Custom Software'
                      ? Icons.code
                      : Icons.developer_board,
      'dealValue': '₹2,50,000',
      'source': 'Website',
    };

    widget.onAddLead(newLead);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0E13),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          // Header Drag Handle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.terminal, color: Color(0xFFCCFF00), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'CyberLim CRM Client Intake',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white38),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Scrollable Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('CONTACT DETAILS', 'Universal credentials captured for this lead.'),
                    const SizedBox(height: 12),
                    _buildTextField(_nameCtrl, 'Lead Full Name *', 'e.g. Kabir Malhotra', icon: Icons.person_outline, required: true),
                    const SizedBox(height: 16),
                    _buildTextField(_companyCtrl, 'Company Name', 'e.g. CyberLim Systems', icon: Icons.business_outlined),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_phoneCtrl, 'Phone Number', 'e.g. +91 91111 22222', icon: Icons.phone_outlined, type: TextInputType.phone)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(_whatsAppCtrl, 'WhatsApp Number', 'e.g. +91 91111 22222', icon: Icons.chat_bubble_outline_rounded, type: TextInputType.phone)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_addressCtrl, 'Business Address', 'e.g. Neo Plaza, Sector 62', icon: Icons.location_on_outlined),
                    const SizedBox(height: 16),
                    _buildTextField(_websiteCtrl, 'Website or Social Link', 'e.g. https://cyberlimsystems.io', icon: Icons.link_outlined),
                    
                    const SizedBox(height: 32),
                    _buildSectionHeader('PROJECT SCOPE', 'Define category constraints and primary goal directions.'),
                    const SizedBox(height: 12),
                    _buildDropdownSelector('Project Category Type', ['Mobile App', 'Web Platform', 'UI/UX Strategy', 'Custom Software', 'IoT Core Systems'], _projectType, (val) {
                      setState(() => _projectType = val!);
                    }),
                    const SizedBox(height: 16),
                    _buildTextField(_projectGoalCtrl, 'Project Goal Purpose', 'What is the purpose of this project?', icon: Icons.flag_outlined, maxLines: 3),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Footer Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF131218),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.04))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  shadowColor: const Color(0xFFCCFF00).withValues(alpha: 0.2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Qualify & Save Lead',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.offline_bolt, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
        const Divider(color: Colors.white12, height: 16),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    IconData? icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        validator: required
            ? (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 13),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFFCCFF00), size: 18) : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFCCFF00), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownSelector(
    String label,
    List<String> options,
    String currentValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              dropdownColor: const Color(0xFF161616),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFCCFF00)),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
