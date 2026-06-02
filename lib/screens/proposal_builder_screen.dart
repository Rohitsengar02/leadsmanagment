import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';

enum BlockType {
  heading,
  text,
  image,
  pricing,
  video,
  signature,
  cover,
  toc,
  team,
  portfolio,
  services,
  timeline,
  testimonials,
  terms,
}

class ProposalBlock {
  final String id;
  final BlockType type;
  Map<String, dynamic> data;
  Map<String, dynamic> style;

  ProposalBlock({
    required this.id,
    required this.type,
    required this.data,
    required this.style,
  });

  ProposalBlock copyWith({
    Map<String, dynamic>? data,
    Map<String, dynamic>? style,
  }) {
    return ProposalBlock(
      id: id,
      type: type,
      data: data != null ? Map<String, dynamic>.from(data) : Map<String, dynamic>.from(this.data),
      style: style != null ? Map<String, dynamic>.from(style) : Map<String, dynamic>.from(this.style),
    );
  }
}

class ProposalPage {
  final String id;
  String title;
  List<ProposalBlock> blocks;

  ProposalPage({required this.id, required this.title, required this.blocks});

  ProposalPage copyWith({String? title, List<ProposalBlock>? blocks}) {
    return ProposalPage(
      id: id,
      title: title ?? this.title,
      blocks: blocks ?? List.from(this.blocks),
    );
  }
}

class ProposalBuilderScreen extends StatefulWidget {
  const ProposalBuilderScreen({super.key});

  @override
  State<ProposalBuilderScreen> createState() => _ProposalBuilderScreenState();
}

class _ProposalBuilderScreenState extends State<ProposalBuilderScreen> {
  List<ProposalPage> pages = [];
  int currentPageIndex = 0;
  int? selectedBlockIndex;
  Color themeColor = const Color(0xFFCCFF00); // Changed to match theme
  bool isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _loadDesignStudioTemplate();
  }

  void _loadDesignStudioTemplate() {
    setState(() {
      pages = [
        ProposalPage(
          id: 'p1',
          title: 'Cover Page',
          blocks: [
            ProposalBlock(
              id: 'b1',
              type: BlockType.cover,
              data: {
                'title': "We're A\nDesign Studio\nThat Believe\nIn The Power\nOf Ideas.",
                'author': 'Inkubator .Std',
              },
              style: {'height': 800.0},
            ),
          ],
        ),
        ProposalPage(
          id: 'p2',
          title: 'Table of Contents',
          blocks: [
            ProposalBlock(
              id: 'b2',
              type: BlockType.toc,
              data: {
                'items': [
                  {'id': '01', 'title': 'About Us', 'page': '2'},
                  {'id': '02', 'title': 'Our Portfolio', 'page': '4'},
                  {'id': '03', 'title': 'Scope of Services', 'page': '5'},
                ],
              },
              style: {},
            ),
          ],
        ),
      ];
      currentPageIndex = 0;
      selectedBlockIndex = null;
    });
  }

  void _addBlock(BlockType type) {
    String newId = DateTime.now().millisecondsSinceEpoch.toString();
    ProposalBlock newBlock;

    switch (type) {
      case BlockType.heading:
        newBlock = ProposalBlock(id: newId, type: type, data: {'text': 'New Heading', 'subtitle': ''}, style: {'fontSize': 32.0});
        break;
      case BlockType.text:
        newBlock = ProposalBlock(id: newId, type: type, data: {'text': 'Enter content...'}, style: {'fontSize': 16.0});
        break;
      case BlockType.image:
        newBlock = ProposalBlock(id: newId, type: type, data: {'url': 'https://i.pravatar.cc/300', 'caption': ''}, style: {'height': 200.0});
        break;
      default:
        newBlock = ProposalBlock(id: newId, type: BlockType.text, data: {'text': 'New Block'}, style: {});
    }

    setState(() {
      pages[currentPageIndex].blocks.add(newBlock);
      selectedBlockIndex = pages[currentPageIndex].blocks.length - 1;
    });
  }

  void _updateBlock(int index, Map<String, dynamic>? data, Map<String, dynamic>? style) {
    setState(() {
      pages[currentPageIndex].blocks[index] = pages[currentPageIndex].blocks[index].copyWith(data: data, style: style);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Column(
        children: [
          _buildHeader(isMobile),
          Expanded(
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const CustomBottomBar(selectedIndex: 2) : null,
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(child: _buildCanvas()),
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: const Color(0xFF131313),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              Expanded(
                child: selectedBlockIndex == null ? _buildMobileActions() : _buildBlockEditor(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(child: _buildCanvas()),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/proposals'),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Proposal Builder', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Modern CRM Template', style: TextStyle(color: Colors.white24, fontSize: 11)),
              ],
            ),
          ],
          const Spacer(),
          _buildEditorToggle(isMobile),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 16),
            label: Text(isMobile ? 'PDF' : 'Export'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCCFF00), foregroundColor: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorToggle(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _buildToggleBtn(Icons.edit, !isPreviewMode, () => setState(() => isPreviewMode = false), isMobile),
          _buildToggleBtn(Icons.visibility, isPreviewMode, () => setState(() => isPreviewMode = true), isMobile),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(IconData icon, bool isActive, VoidCallback onTap, bool isMobile) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isActive ? themeColor : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isActive ? Colors.black : Colors.white38, size: 18),
      ),
    );
  }

  Widget _buildMobileActions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PAGE OPTIONS', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAddBlockIcon(Icons.title, BlockType.heading),
              const SizedBox(width: 12),
              _buildAddBlockIcon(Icons.text_fields, BlockType.text),
              const SizedBox(width: 12),
              _buildAddBlockIcon(Icons.image, BlockType.image),
              const SizedBox(width: 12),
              _buildAddBlockIcon(Icons.note_add_outlined, BlockType.text), // Dummy for add page
            ],
          ),
          const SizedBox(height: 24),
          const Text('PAGES', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pages.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() { currentPageIndex = index; selectedBlockIndex = null; }),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: currentPageIndex == index ? themeColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: currentPageIndex == index ? themeColor : Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Center(child: Text('Page ${index + 1}', style: TextStyle(color: currentPageIndex == index ? Colors.white : Colors.white38, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBlockIcon(IconData icon, BlockType type) {
    return InkWell(
      onTap: () => _addBlock(type),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 300,
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(24), child: Text('BUILDER OPTIONS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(child: selectedBlockIndex == null ? _buildPageList() : _buildBlockEditor()),
        ],
      ),
    );
  }

  Widget _buildPageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        bool isActive = currentPageIndex == index;
        return ListTile(
          selected: isActive,
          title: Text(pages[index].title, style: const TextStyle(color: Colors.white)),
          onTap: () => setState(() { currentPageIndex = index; selectedBlockIndex = null; }),
        );
      },
    );
  }

  Widget _buildBlockEditor() {
    var block = pages[currentPageIndex].blocks[selectedBlockIndex!];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EDITING ${block.type.name.toUpperCase()}', style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 10, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => selectedBlockIndex = null), icon: const Icon(Icons.close, color: Colors.white24, size: 16)),
            ],
          ),
          const SizedBox(height: 16),
          if (block.type == BlockType.heading || block.type == BlockType.text)
            TextField(
              controller: TextEditingController(text: block.data['text']),
              onChanged: (v) => _updateBlock(selectedBlockIndex!, {'text': v}, null),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(filled: true, fillColor: Colors.white.withValues(alpha: 0.03), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    var page = pages[currentPageIndex];
    return Container(
      color: Colors.black45,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / 1.414,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)]),
            child: ListView.builder(
              padding: const EdgeInsets.all(40),
              itemCount: page.blocks.length,
              itemBuilder: (context, index) {
                var block = page.blocks[index];
                return GestureDetector(
                  onTap: isPreviewMode ? null : () => setState(() => selectedBlockIndex = index),
                  child: Container(
                    decoration: BoxDecoration(border: !isPreviewMode && selectedBlockIndex == index ? Border.all(color: themeColor, width: 2) : null),
                    child: _renderBlock(block),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderBlock(ProposalBlock block) {
    switch (block.type) {
      case BlockType.cover:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(block.data['title'], style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 20),
            Text('BY ${block.data['author']}', style: TextStyle(fontSize: 12, color: Colors.grey[600], letterSpacing: 2)),
          ],
        );
      case BlockType.heading:
        return Text(block.data['text'], style: TextStyle(fontSize: block.style['fontSize'], fontWeight: FontWeight.bold, color: Colors.black));
      case BlockType.text:
        return Text(block.data['text'], style: const TextStyle(fontSize: 14, color: Colors.black87));
      case BlockType.image:
        return Image.network(block.data['url'], height: block.style['height']);
      default:
        return const SizedBox();
    }
  }
}
