import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:go_router/go_router.dart';

class FormBuilderScreen extends StatelessWidget {
  const FormBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A16),
      body: Column(
        children: [
          _buildTopNav(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLeftSidebar(),
                Expanded(child: _buildMainConfigArea()),
                _buildRightSidebar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1B),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/forms'),
            icon: const Icon(Icons.apps, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          const Text(
            'CRM Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            ' / Field Builder',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save Draft',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Publish Changes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=editor'),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STRUCTURE',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '+ Add Section',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Filter fields...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white24,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSectionHeader('CONTACT INFO'),
                _buildFieldItem(
                  'First Name',
                  'System Field • Required',
                  Icons.text_fields,
                  isActive: true,
                ),
                _buildFieldItem(
                  'Last Name',
                  'System Field • Required',
                  Icons.text_fields,
                ),
                _buildFieldItem(
                  'Email Address',
                  'Unique • Required',
                  Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('BUSINESS DETAILS'),
                _buildFieldItem(
                  'Annual Revenue',
                  'Currency (USD)',
                  Icons.attach_money,
                ),
                _buildFieldItem('Industry', 'Single Select', Icons.list),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white38, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Create New Field',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.white24, size: 16),
        ],
      ),
    );
  }

  Widget _buildFieldItem(
    String title,
    String subtitle,
    IconData icon, {
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.white12, size: 16),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.white24,
            size: 18,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white24, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainConfigArea() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Settings',
                style: TextStyle(color: Colors.white24, fontSize: 13),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white24, size: 16),
              SizedBox(width: 8),
              Text(
                'Objects',
                style: TextStyle(color: Colors.white24, fontSize: 13),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white24, size: 16),
              SizedBox(width: 8),
              Text(
                'Contacts',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.circle, color: Colors.green, size: 8),
              SizedBox(width: 8),
              Text(
                'Last saved 2 mins ago',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Text(
            'Configure "First Name"',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Modify field properties, validation rules, and conditional logic.',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 40),
          _buildConfigCard('General Properties', Icons.settings_outlined, [
            Row(
              children: [
                Expanded(child: _buildInput('Field Label', 'First Name')),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildInput('API Name', 'first_name', isLocked: true),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInput(
              'Placeholder Text',
              'e.g. Enter the customer\'s first name',
            ),
            const SizedBox(height: 24),
            _buildDropdown('Field Type', 'Single Line Text'),
          ]),
          const SizedBox(height: 32),
          _buildConfigCard('Validation & Visibility', Icons.rule_outlined, [
            _buildToggleItem(
              'Required Field',
              'User must fill this value to save the record.',
              true,
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            _buildToggleItem(
              'Read Only',
              'Users can see but cannot edit this value.',
              false,
            ),
          ]),
          const SizedBox(height: 32),
          _buildConditionalLogicCard(),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Update Field',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(String label, String value, {bool isLocked = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: isLocked,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: isLocked
                  ? const Icon(
                      Icons.lock_outline,
                      color: Colors.white12,
                      size: 16,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white24,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(String title, String desc, bool value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primary),
      ],
    );
  }

  Widget _buildConditionalLogicCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'CONDITIONAL LOGIC',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.03),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.call_split, color: Colors.white10, size: 32),
                const SizedBox(height: 16),
                const Text(
                  'No logic rules applied',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Control visibility based on other field values',
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '+ Add Rule',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildRightSidebar() {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Live Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.laptop, color: AppColors.primary, size: 18),
                const SizedBox(width: 16),
                const Icon(Icons.smartphone, color: Colors.white24, size: 18),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMiniPreviewForm(),
                  const SizedBox(height: 32),
                  _buildPreviewModeInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPreviewForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1428),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white10,
                child: Text(
                  'JS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enter details for the new lead',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          _buildPreviewField('First Name *', 'John', isActive: true),
          const SizedBox(height: 16),
          _buildPreviewField('Last Name *', 'Smith'),
          const SizedBox(height: 16),
          _buildPreviewField(
            'Email Address *',
            'john@company.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPreviewField('Annual Revenue', '₹ 0.00')),
              const SizedBox(width: 16),
              Expanded(child: _buildPreviewDropdown('Industry', 'Select...')),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Create Contact',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewField(
    String label,
    String value, {
    bool isActive = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white24, size: 14),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white24,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewModeInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'This preview reflects the standard layout. Custom conditional logic might hide some fields initially based on default values.',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
