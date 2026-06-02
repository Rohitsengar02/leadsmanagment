import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';

class FormBuilderScreen extends StatefulWidget {
  const FormBuilderScreen({super.key});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  int _activeTabIndex = 0; // 0: Structure, 1: Config, 2: Preview (Mobile)

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Column(
        children: [
          _buildTopNav(context, isMobile),
          if (isMobile) _buildMobileTabs(),
          Expanded(
            child: isMobile ? _buildMobileContent() : _buildDesktopContent(),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 4) : null, // Forms usually linked to index 4
    );
  }

  Widget _buildMobileTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF131313), border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem('Fields', 0),
          _buildTabItem('Setup', 1),
          _buildTabItem('Live', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: isActive ? const Color(0xFFCCFF00) : Colors.white38, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          if (isActive) Container(width: 20, height: 2, decoration: BoxDecoration(color: const Color(0xFFCCFF00), borderRadius: BorderRadius.circular(1))),
        ],
      ),
    );
  }

  Widget _buildMobileContent() {
    switch (_activeTabIndex) {
      case 0: return _buildLeftSidebar(true);
      case 1: return _buildMainConfigArea(true);
      case 2: return _buildRightSidebar(true);
      default: return const SizedBox();
    }
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLeftSidebar(false),
        Expanded(child: _buildMainConfigArea(false)),
        _buildRightSidebar(false),
      ],
    );
  }

  Widget _buildTopNav(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF131313), border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Row(
        children: [
          IconButton(onPressed: () => context.go('/forms'), icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFCCFF00), size: 18)),
          if (!isMobile) const Text('Form Builder', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Publish', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 280,
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(24), child: Text('DRAG & DROP FIELDS', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFieldItem('Full Name', Icons.person_outline),
                _buildFieldItem('Email Address', Icons.email_outlined),
                _buildFieldItem('Phone Number', Icons.phone_outlined),
                _buildFieldItem('Company', Icons.business_outlined),
                _buildFieldItem('Project Value', Icons.attach_money),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFCCFF00), size: 18),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.drag_indicator, color: Colors.white12, size: 16),
        ],
      ),
    );
  }

  Widget _buildMainConfigArea(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Field Configuration', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildInput('Field Label', 'Full Name'),
          const SizedBox(height: 20),
          _buildInput('Placeholder', 'Enter full name...'),
          const SizedBox(height: 32),
          _buildToggle('Required Field', true),
          _buildToggle('Read Only', false),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: const Text('Update Field', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: TextEditingController(text: value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(filled: true, fillColor: Colors.white.withValues(alpha: 0.03), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }

  Widget _buildToggle(String title, bool val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Switch(value: val, onChanged: (v) {}, activeColor: const Color(0xFFCCFF00)),
        ],
      ),
    );
  }

  Widget _buildRightSidebar(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 380,
      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(24), child: Text('LIVE FORM PREVIEW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: const Color(0xFF131313), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
                child: Column(
                  children: [
                    _buildPreviewField('Full Name', 'John Doe'),
                    const SizedBox(height: 16),
                    _buildPreviewField('Email', 'john@example.com'),
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)), child: const Text('Submit Form')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 8),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)), child: Text(value, style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}
