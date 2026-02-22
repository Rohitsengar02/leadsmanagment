import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:go_router/go_router.dart';

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
      data: data != null
          ? Map<String, dynamic>.from(data)
          : Map<String, dynamic>.from(this.data),
      style: style != null
          ? Map<String, dynamic>.from(style)
          : Map<String, dynamic>.from(this.style),
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
  Color themeColor = const Color(
    0xFFFFD700,
  ); // Default Golden/Yellow from image
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
                'title':
                    "We're A\nDesign Studio\nThat Believe\nIn The Power\nOf Ideas.",
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
                  {'id': '04', 'title': 'Project Timeline', 'page': '7'},
                  {'id': '05', 'title': 'Project Breakdown', 'page': '8'},
                  {'id': '06', 'title': 'Terms & Conditions', 'page': '10'},
                ],
              },
              style: {},
            ),
          ],
        ),
        ProposalPage(
          id: 'p3',
          title: 'About Us & Team',
          blocks: [
            ProposalBlock(
              id: 'b3',
              type: BlockType.team,
              data: {
                'title': 'About Us',
                'teamTitle': 'Our Team',
                'members': [
                  {
                    'name': 'Marcus Miller',
                    'role': 'UX Designer',
                    'exp': '85%',
                    'skills': '90%',
                  },
                  {
                    'name': 'Bill Gardner',
                    'role': 'Art Director',
                    'exp': '95%',
                    'skills': '80%',
                  },
                  {
                    'name': 'Jeremy Dupont',
                    'role': 'Developer',
                    'exp': '80%',
                    'skills': '95%',
                  },
                ],
              },
              style: {},
            ),
          ],
        ),
        ProposalPage(
          id: 'p4',
          title: 'Our Portfolio',
          blocks: [
            ProposalBlock(
              id: 'b4',
              type: BlockType.portfolio,
              data: {
                'title': 'Our Portfolio',
                'items': [
                  {
                    'title': 'Project Name One',
                    'desc': 'Client Name / Tech Stack',
                    'url':
                        'https://images.unsplash.com/photo-1542744094-24638eff58bb?q=80&w=400',
                  },
                  {
                    'title': 'Project Name Two',
                    'desc': 'Client Name / Tech Stack',
                    'url':
                        'https://images.unsplash.com/photo-1541462608141-ad603a95048a?q=80&w=400',
                  },
                  {
                    'title': 'Project Name Three',
                    'desc': 'Client Name / Tech Stack',
                    'url':
                        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=400',
                  },
                  {
                    'title': 'Project Name Four',
                    'desc': 'Client Name / Tech Stack',
                    'url':
                        'https://images.unsplash.com/photo-1522071823902-b2da85918712?q=80&w=400',
                  },
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
        newBlock = ProposalBlock(
          id: newId,
          type: type,
          data: {'text': 'New Heading', 'subtitle': ''},
          style: {'fontSize': 42.0},
        );
        break;
      case BlockType.text:
        newBlock = ProposalBlock(
          id: newId,
          type: type,
          data: {'text': 'Enter your content here...'},
          style: {'fontSize': 16.0},
        );
        break;
      case BlockType.image:
        newBlock = ProposalBlock(
          id: newId,
          type: type,
          data: {
            'url':
                'https://images.unsplash.com/photo-1497215728101-856f4ea42174?q=80&w=1000',
            'caption': '',
          },
          style: {'height': 300.0},
        );
        break;
      case BlockType.services:
        newBlock = ProposalBlock(
          id: newId,
          type: type,
          data: {
            'title': 'Scope of Services',
            'items': [
              {
                'icon': 'design_services',
                'title': 'Web Design',
                'desc': 'Custom UI/UX solutions.',
              },
              {
                'icon': 'code',
                'title': 'Development',
                'desc': 'High-performance web apps.',
              },
              {
                'icon': 'branding_watermark',
                'title': 'Branding',
                'desc': 'Identity & logo design.',
              },
            ],
          },
          style: {},
        );
        break;
      default:
        newBlock = ProposalBlock(
          id: newId,
          type: BlockType.text,
          data: {'text': 'New Block'},
          style: {},
        );
    }

    setState(() {
      pages[currentPageIndex].blocks.add(newBlock);
      selectedBlockIndex = pages[currentPageIndex].blocks.length - 1;
    });
  }

  void _updateBlock(
    int index,
    Map<String, dynamic>? data,
    Map<String, dynamic>? style,
  ) {
    setState(() {
      pages[currentPageIndex].blocks[index] = pages[currentPageIndex]
          .blocks[index]
          .copyWith(data: data, style: style);
    });
  }

  void _addPage() {
    setState(() {
      pages.add(
        ProposalPage(
          id: 'p${DateTime.now().millisecondsSinceEpoch}',
          title: 'New Page',
          blocks: [],
        ),
      );
      currentPageIndex = pages.length - 1;
      selectedBlockIndex = null;
    });
  }

  void _removePage(int index) {
    if (pages.length <= 1) return;
    setState(() {
      pages.removeAt(index);
      if (currentPageIndex >= pages.length) currentPageIndex = pages.length - 1;
      selectedBlockIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF130E1B),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                Expanded(child: _buildCanvas()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
            onPressed: () => context.go('/proposals'),
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Design Studio Builder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Multi-Page High Fidelity Template',
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          _buildEditorToggle(),
          const SizedBox(width: 48),
          _buildThemeColorPicker(),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Export PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildToggleBtn(
            Icons.edit,
            'Edit',
            !isPreviewMode,
            () => setState(() => isPreviewMode = false),
          ),
          _buildToggleBtn(
            Icons.visibility,
            'View',
            isPreviewMode,
            () => setState(() => isPreviewMode = true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.white38,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white38,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorPicker() {
    List<Color> colors = [
      const Color(0xFFFFD700),
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
    ];
    return Row(
      children: [
        const Text(
          'Theme:',
          style: TextStyle(color: Colors.white24, fontSize: 12),
        ),
        const SizedBox(width: 8),
        ...colors.map(
          (c) => GestureDetector(
            onTap: () => setState(() => themeColor = c),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: themeColor == c
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          _buildSidebarTabs(),
          Expanded(
            child: selectedBlockIndex == null
                ? _buildPageList()
                : _buildBlockEditor(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'PAGES (${pages.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              bool isActive = currentPageIndex == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isActive
                      ? themeColor.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? themeColor
                        : Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    pages[index].title,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${pages[index].blocks.length} Blocks',
                    style: const TextStyle(color: Colors.white24, fontSize: 10),
                  ),
                  trailing: IconButton(
                    onPressed: () => _removePage(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.white24,
                    ),
                  ),
                  onTap: () => setState(() {
                    currentPageIndex = index;
                    selectedBlockIndex = null;
                  }),
                ),
              );
            },
          ),
        ),
        _buildSidebarActions(),
      ],
    );
  }

  Widget _buildSidebarActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _addPage,
            icon: const Icon(Icons.note_add_outlined, size: 18),
            label: const Text('Add Blank Page'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'ADD BLOCK TO CURRENT PAGE',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAddBlockIcon(Icons.title, BlockType.heading),
              _buildAddBlockIcon(Icons.text_fields, BlockType.text),
              _buildAddBlockIcon(Icons.image, BlockType.image),
              _buildAddBlockIcon(Icons.design_services, BlockType.services),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddBlockIcon(IconData icon, BlockType type) {
    return InkWell(
      onTap: () => _addBlock(type),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }

  Widget _buildBlockEditor() {
    var block = pages[currentPageIndex].blocks[selectedBlockIndex!];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${block.type.name.toUpperCase()} EDITOR',
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => selectedBlockIndex = null),
                icon: const Icon(Icons.close, color: Colors.white24, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (block.type == BlockType.cover) ...[
            _buildPropInput(
              'Big Title',
              block.data['title'],
              (v) => _updateBlock(selectedBlockIndex!, {
                'title': v,
                'author': block.data['author'],
              }, null),
              maxLines: 5,
            ),
            _buildPropInput(
              'Author',
              block.data['author'],
              (v) => _updateBlock(selectedBlockIndex!, {
                'title': block.data['title'],
                'author': v,
              }, null),
            ),
          ],
          if (block.type == BlockType.heading) ...[
            _buildPropInput(
              'Text',
              block.data['text'],
              (v) => _updateBlock(selectedBlockIndex!, {'text': v}, null),
            ),
            _buildPropSlider(
              'Font Size',
              block.style['fontSize'] ?? 32.0,
              20,
              80,
              (v) => _updateBlock(selectedBlockIndex!, null, {'fontSize': v}),
            ),
          ],
          if (block.type == BlockType.text) ...[
            _buildPropInput(
              'Content',
              block.data['text'],
              (v) => _updateBlock(selectedBlockIndex!, {'text': v}, null),
              maxLines: 10,
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  pages[currentPageIndex].blocks.removeAt(selectedBlockIndex!);
                  selectedBlockIndex = null;
                });
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete Block'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropInput(
    String label,
    String value,
    Function(String) onChange, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white24, fontSize: 11),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChange,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPropSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.white24, fontSize: 11),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: themeColor,
          onChanged: onChange,
        ),
      ],
    );
  }

  Widget _buildCanvas() {
    return Container(
      color: Colors.black,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Container(
            width: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.1),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                pages[currentPageIndex].blocks.length,
                (index) => _buildBlockOnCanvas(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockOnCanvas(int index) {
    var block = pages[currentPageIndex].blocks[index];
    bool isSelected = selectedBlockIndex == index && !isPreviewMode;

    return GestureDetector(
      onTap: isPreviewMode
          ? null
          : () => setState(() => selectedBlockIndex = index),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: themeColor, width: 2) : null,
        ),
        child: _renderBlock(block),
      ),
    );
  }

  Widget _renderBlock(ProposalBlock block) {
    switch (block.type) {
      case BlockType.cover:
        return Container(
          height: block.style['height'] ?? 800.0,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 200,
                child: Container(color: themeColor),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(250, 100, 50, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.data['title'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Container(width: 80, height: 4, color: themeColor),
                    const SizedBox(height: 24),
                    Text(
                      block.data['author'],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case BlockType.toc:
        return Container(
          padding: const EdgeInsets.all(80),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Content',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              ...(block.data['items'] as List).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['page'],
                        style: const TextStyle(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case BlockType.team:
        return Container(
          padding: const EdgeInsets.all(64),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.data['title'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Who We Are?',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'We are a collective of designers and developers pushing the limits of modern digital experiences...',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                block.data['teamTitle'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (block.data['members'] as List)
                    .map(
                      (m) => Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://i.pravatar.cc/150?u=${m['name']}',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              m['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              m['role'],
                              style: const TextStyle(
                                color: Colors.black26,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildMiniSkillBar('Experience', m['exp']),
                            _buildMiniSkillBar('Soft Skills', m['skills']),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      case BlockType.portfolio:
        return Container(
          padding: const EdgeInsets.all(64),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.data['title'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemCount: (block.data['items'] as List).length,
                itemBuilder: (context, i) {
                  var item = block.data['items'][i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(item['url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['desc'],
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      case BlockType.heading:
        return Container(
          padding: const EdgeInsets.fromLTRB(64, 48, 64, 24),
          child: Text(
            block.data['text'],
            style: TextStyle(
              color: Colors.black,
              fontSize: block.style['fontSize'] ?? 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case BlockType.text:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          child: Text(
            block.data['text'],
            style: TextStyle(
              color: Colors.black54,
              fontSize: block.style['fontSize'] ?? 16,
              height: 1.6,
            ),
          ),
        );
      case BlockType.image:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          child: Column(
            children: [
              Container(
                height: block.style['height'] ?? 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(block.data['url']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      case BlockType.services:
        return Container(
          padding: const EdgeInsets.all(64),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.data['title'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 32,
                runSpacing: 32,
                children: (block.data['items'] as List)
                    .map(
                      (s) => SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: themeColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.flash_on,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              s['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s['desc'],
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildMiniSkillBar(String label, String value) {
    double percent = double.parse(value.replaceAll('%', '')) / 100;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 9, color: Colors.black38),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(color: themeColor),
            ),
          ),
        ],
      ),
    );
  }
}
