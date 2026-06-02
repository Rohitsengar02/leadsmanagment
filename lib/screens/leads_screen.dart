import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/glass_card.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:go_router/go_router.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/leads'),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -200,
                  right: -100,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      _buildFilters(),
                      const SizedBox(height: 24),
                      Expanded(child: _buildLeadsTable(context)),
                    ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 14, color: Colors.white38),
                SizedBox(width: 8),
                Text(
                  'Leads Management',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Leads',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Add Lead',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search leads by name, email...',
                prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterChip('Status: All'),
        const SizedBox(width: 8),
        _buildFilterChip('Source: All'),
        const SizedBox(width: 8),
        _buildFilterChip('Date: This Month', icon: Icons.calendar_today),
        const SizedBox(width: 16),
        _buildIconButton(Icons.filter_list),
        const SizedBox(width: 8),
        _buildIconButton(Icons.view_column_outlined),
      ],
    );
  }

  Widget _buildFilterChip(
    String label, {
    IconData icon = Icons.keyboard_arrow_down,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white38, size: 16),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _buildLeadsTable(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    Colors.white.withValues(alpha: 0.02),
                  ),
                  dataRowMaxHeight: 80,
                  horizontalMargin: 24,
                  checkboxHorizontalMargin: 12,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'NAME',
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
                        'SOURCE',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ASSIGNED TO',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ACTIONS',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    _buildDataRow(
                      context,
                      'Sarah Connor',
                      'sarah@cyberdyne.com',
                      'Cyberdyne Systems',
                      'Negotiation',
                      'Referral',
                      ['AM', 'JD'],
                      Colors.orange,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDCAzOfaieGpYBF-_8iGYi3FAQb0cQdxy4iP-NC538dOWIWzQAVdnYPLYpL6p6ogBa_-xELm1FMRRC3LJqFn6UMDL3h4g0gxTG_5i4garCpvwoqviFzBGSaBnCkF0uVKKqE6PkhTsT6_rFVz0btEmdiT8QS0mVtDQXryFi5qZ97qEltFF5olLsBNqqQ6-QNX6NT-0PZ24rp4380mFxJ0kYUv0J9v53jLKxTIYUKyXwpQ37MXe2EP7iyKuKkqLgWARHhytA__x73v04',
                    ),
                    _buildDataRow(
                      context,
                      'John Wick',
                      'john@continental.com',
                      'Continental Hotel',
                      'New Lead',
                      'Direct',
                      ['AM'],
                      Colors.blue,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA8JPB1a9TKAio2HIhCtRZsNGNj5U8rfAlBuNsQN4yzwtj1jRhslEBwEOKOvFIZXxq-nw3rD4oASgzKwtNz_pMvtXaPuUCMMzuZKYsS0H1cWJV7Qc0RT3NGnqf32Wv3tKZfAwfKCtvdEfLEd-t0y50qQLYwb2prxh0vZ4s5e4Yz16pnallvz6mPRxky-2TySnhBxIs6m_gpVUEqxzEHEJOURxIEHDC4CYMYUHh1n1p1QJQ6j-0O38x63fYoaOB8CjZVfFKH1OhMOoo',
                    ),
                    _buildDataRow(
                      context,
                      'Ellen Ripley',
                      'ripley@weyland.com',
                      'Weyland-Yutani',
                      'Qualified',
                      'LinkedIn',
                      ['JD'],
                      Colors.green,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDkVzvvjsi1wjmaF0SwZW5tvMq179Jaobn3r_l1pNpIlSy3VVaz1VMhxtCKD6nIwj5pH-zI60Y8pB1aT7-dVLIgGfzq8nfxSsq25UKJ8yxmbNQH13gx_5ls7Hklas890VAOVLDc2r__aG13OpHDpaVu6qViKD9BE9oXWafh8frfgsPu0K7x_5fv9IWLWhU7uETl1A42K2hwJaPFP8TnGdosyX6DJah7rDPSNqVngURzJIDrlByr-LEQhGx1-BTmV8ROVDdQ5r0Tvyc',
                    ),
                    _buildDataRow(
                      context,
                      'Marcus Wright',
                      'marcus@skynet.net',
                      'Skynet Corp',
                      'Lost',
                      'Ad Campaign',
                      ['AM'],
                      Colors.red,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDIfakMLkHzx3TT-QtgYwsyAMUk8K77C9K5cXJxI2Z9y7xhmZm9OkPP-EHpAngnoEnzoI91pRCD_-MoL1O_gyBBwWXr5t7b9LqUfXFFm4yB1UZwKCI10-HHikIsIA1hGgBG6hxwa8TaV8zBCDWgyzoZd2lFu4F9VknafUeJ3tZuwxH4bDEfItC1rmdGP1VdJl_QPq_ayvXp9aHTxTsUDyAlG33fkYR5gG8XJnXSX_tcnY5jw_omh2AAD3P0r0rrf8sC5cyyVuKZGtY',
                    ),
                    _buildDataRow(
                      context,
                      'Lena Oxton',
                      'tracer@overwatch.com',
                      'Overwatch',
                      'Proposal',
                      'Website',
                      ['JD', 'AM'],
                      Colors.purple,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCcyTmYSUH8lgsyzbLMykRHbc8CybLSeuyBwFrGbKprgfDCthecsdujmQRHBhtmGC2KM5chqRq0K8Bty69Z0KN5oVIgeedGpkm9j7VPRBTpyK14Fi3uU4kncDABz6vodPwAR4l2SUk1YPHuvawRmE1mXuv8v-a6bPK3ol-MvYdIkejKZ3tYrZMiibpcVg_nfe5bnhY1orjgCtUvzRswGebOdP5HwToZDocfEbN0rWqgKg2vNQ-oIEeumHsEai5ZeRp2ogP_Rn7CO24',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Rows per page:',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(width: 8),
                const Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white38),
                const Spacer(),
                const Text(
                  '1-5 of 45',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(width: 24),
                _buildPageIcon(Icons.chevron_left, enabled: false),
                const SizedBox(width: 8),
                _buildPageIcon(Icons.chevron_right, enabled: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    String name,
    String email,
    String company,
    String status,
    String source,
    List<String> assigned,
    Color color,
    String avatarUrl,
  ) {
    return DataRow(
      onSelectChanged: (v) => context.go('/leads/details'),
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    email,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    company[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                company,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              const Icon(Icons.link, size: 16, color: Colors.white38),
              const SizedBox(width: 8),
              Text(
                source,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        DataCell(
          Stack(
            children: List.generate(assigned.length, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i * 20.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    assigned[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(Icons.call_outlined),
              const SizedBox(width: 8),
              _buildActionBtn(Icons.mail_outlined),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert, color: Colors.white38, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white70, size: 16),
    );
  }

  Widget _buildPageIcon(IconData icon, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Icon(
        icon,
        color: enabled ? Colors.white70 : Colors.white.withValues(alpha: 0.1),
        size: 20,
      ),
    );
  }
}
