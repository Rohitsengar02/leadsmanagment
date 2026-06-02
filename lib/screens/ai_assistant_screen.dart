import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/sidebar.dart';
import 'package:leads_management/widgets/custom_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'ai',
      'text':
          'Hello! I am your Neon AI assistant. Select a lead to start strategizing or generating proposals.',
      'reaction': '⚡',
    },
  ];

  String? _selectedLead = 'Acme Corp';
  bool _isTyping = false;

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'text': _controller.text,
        'reaction': _getRandomEmoji(),
      });
      _isTyping = true;
    });

    String userText = _controller.text;
    _controller.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({
          'role': 'ai',
          'text': _getAIResponse(userText),
          'isProposal': userText.toLowerCase().contains('proposal'),
        });
      });
    });
  }

  String _getRandomEmoji() {
    final emojis = ['❤️', '🔥', '👍', '🚀', '✨', '💯'];
    return emojis[math.Random().nextInt(emojis.length)];
  }

  String _getAIResponse(String input) {
    if (input.toLowerCase().contains('proposal')) {
      return 'I\'ve drafted a preliminary proposal for $_selectedLead. It includes a 15% discount for early closure and a custom integration roadmap.';
    }
    return 'Based on $_selectedLead\'s recent activity, I recommend following up with a focus on their Q3 scaling goals.';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B09),
      body: Row(
        children: [
          if (!isMobile) const SideBar(activeRoute: '/ai-assistant'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isMobile),
                Expanded(child: _buildChatList()),
                _buildInputArea(isMobile),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? const CustomBottomBar(selectedIndex: 5)
          : null, // Assuming index 5 or similar
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => context.go('/dashboard'),
            ),
          if (isMobile) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Neon AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Lead Strategist',
                style: TextStyle(
                  color: Color(0xFFCCFF00),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showLeadSelector(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFF00).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFCCFF00).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_search,
                    color: Color(0xFFCCFF00),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedLead ?? 'Select Lead',
                    style: const TextStyle(
                      color: Color(0xFFCCFF00),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  void _showLeadSelector(BuildContext context) {
    final leads = [
      'Acme Corp',
      'TechFlow Inc',
      'Global Media',
      'Nexus Systems',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131313),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'SELECT A LEAD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...leads.map(
              (l) => ListTile(
                title: Text(l, style: const TextStyle(color: Colors.white70)),
                onTap: () {
                  setState(() => _selectedLead = l);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        bool isAI = msg['role'] == 'ai';
        return _buildMessageBubble(msg, isAI);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isAI) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isAI
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isAI
                        ? Colors.white.withValues(alpha: 0.03)
                        : const Color(0xFFCCFF00).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25),
                      topRight: const Radius.circular(25),
                      bottomLeft: isAI
                          ? Radius.zero
                          : const Radius.circular(25),
                      bottomRight: isAI
                          ? const Radius.circular(25)
                          : Radius.zero,
                    ),
                    border: Border.all(
                      color: isAI
                          ? Colors.white.withValues(alpha: 0.05)
                          : const Color(0xFFCCFF00).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['text'],
                        style: TextStyle(
                          color: isAI ? Colors.white70 : Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      if (msg['isProposal'] == true) ...[
                        const SizedBox(height: 20),
                        _buildProposalCard(),
                      ],
                    ],
                  ),
                ),
                if (msg['reaction'] != null)
                  Positioned(
                    bottom: -10,
                    right: isAI ? -10 : null,
                    left: isAI ? null : -10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131313),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        msg['reaction'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFCCFF00).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DRAFT PROPOSAL',
            style: TextStyle(
              color: Color(0xFFCCFF00),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Custom Tech Implementation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Value: 12,500.00',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/proposals/builder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCFF00),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Open in Builder',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, isMobile ? 40 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Ask Neon AI about leads...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFCCFF00),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
