import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'sound_helper.dart';

class ChatScreen extends StatefulWidget {
  final bool isDark;
  final Function(String message) showToast;
  final String? initialMemberName;

  const ChatScreen({
    super.key,
    required this.isDark,
    required this.showToast,
    this.initialMemberName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _messageScrollController = ScrollController();
  late String _activeContactId;
  String _searchQuery = '';
  bool _showEmojiPicker = false;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _typingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  // Emoji categories
  final Map<String, List<String>> _emojiCategories = {
    '😀 Smileys': ['😀', '😁', '😂', '🤣', '😃', '😄', '😅', '😆', '😉', '😊', '😋', '😎', '😍', '🥰', '😘', '😗', '😙', '😚', '🙂', '🤗', '🤩', '🥳', '😏', '😌', '😛', '😜', '🤪', '😝', '🤑', '🤓', '😎', '🥸'],
    '👋 Gestures': ['👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '👇', '☝️', '👍', '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '🫶', '👐', '🤲', '🤝', '🙏', '💪'],
    '❤️ Hearts': ['❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔', '❣️', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟', '♥️', '🫀', '💌', '💐', '🌹', '🌺', '🌸', '🌷', '🌻', '🌼', '💮', '🏵️', '🎕'],
    '🎉 Celebrate': ['🎉', '🎊', '🎈', '🎁', '🎀', '🎂', '🧁', '🍰', '🎃', '🎄', '🎆', '🎇', '✨', '🎍', '🎎', '🎏', '🎐', '🎑', '🎋', '🎗️', '🎟️', '🎫', '🏆', '🏅', '🥇', '🥈', '🥉', '⚽', '🏀', '🎯', '🎮', '🕹️'],
    '🔥 Objects': ['🔥', '💯', '⭐', '🌟', '💫', '⚡', '☀️', '🌈', '🎵', '🎶', '🎤', '🎧', '📱', '💻', '⌨️', '🖥️', '📷', '📸', '🔮', '💎', '🪙', '💰', '📦', '📩', '📨', '✉️', '📝', '📌', '📎', '🔗', '🧲', '🚀'],
  };
  String _selectedEmojiCategory = '😀 Smileys';

  // Active chat threads list data
  final List<Map<String, dynamic>> _threads = [
    {
      'id': 'thread_1',
      'name': 'Brooke Webb',
      'title': 'Friday Update',
      'lastMsg': 'Happy Friday Team! This week\'s updates are ready.',
      'time': '5 min ago',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Brooke',
      'status': 'online',
      'job': 'Product Lead',
      'jobs': '124',
      'completed': '98',
      'progress': '26',
      'unread': 3,
    },
    {
      'id': 'thread_2',
      'name': 'Thomas Merritt',
      'title': 'How to create a great design',
      'lastMsg': 'UX design is a valuable art that you can practice daily.',
      'time': '1 hr ago',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Thomas',
      'status': 'offline',
      'job': 'UX Director',
      'jobs': '92',
      'completed': '78',
      'progress': '14',
      'unread': 0,
    },
    {
      'id': 'thread_3',
      'name': 'Frank Baker',
      'title': 'Let\'s meet for dinner later',
      'lastMsg': 'Hey Jason, How do you feel about grabbing some sushi?',
      'time': '9:34 am',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Frank',
      'status': 'online',
      'job': 'Operations Head',
      'jobs': '64',
      'completed': '52',
      'progress': '12',
      'unread': 1,
    },
    {
      'id': 'thread_4',
      'name': 'Gladys Leonard',
      'title': 'Your insights?',
      'lastMsg': 'Hey, if I\'m not mistaken, you signed up for our plan.',
      'time': '9:03 am',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Gladys',
      'status': 'online',
      'job': 'Graphics Designer',
      'jobs': '80',
      'completed': '54',
      'progress': '80',
      'unread': 2,
    },
    {
      'id': 'thread_5',
      'name': 'Debra Reynolds',
      'title': 'Travel Photos',
      'lastMsg': 'What do you think about the latest shots from the trip?',
      'time': '9:00 am',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Debra',
      'status': 'offline',
      'job': 'Content Writer',
      'jobs': '48',
      'completed': '40',
      'progress': '8',
      'unread': 0,
    },
    {
      'id': 'thread_6',
      'name': 'Monica Henry',
      'title': 'Company Q&A',
      'lastMsg': 'We have a Company Q&A scheduled for tomorrow.',
      'time': '8:23 am',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Monica',
      'status': 'online',
      'job': 'Support Specialist',
      'jobs': '150',
      'completed': '138',
      'progress': '12',
      'unread': 5,
    },
  ];

  late Map<String, List<Map<String, dynamic>>> _messagesByThread;

  @override
  void initState() {
    super.initState();
    _activeContactId = 'thread_4';

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _fadeController.forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // If navigated with a specific member name, auto-select their thread if found
    if (widget.initialMemberName != null) {
      final index = _threads.indexWhere((t) => t['name'].toString().toLowerCase().contains(widget.initialMemberName!.toLowerCase()));
      if (index != -1) {
        _activeContactId = _threads[index]['id'];
      } else {
        final String newId = 'thread_dyn_${DateTime.now().millisecondsSinceEpoch}';
        _threads.insert(0, {
          'id': newId,
          'name': widget.initialMemberName!,
          'title': 'Direct Conversation',
          'lastMsg': 'No messages yet.',
          'time': 'Just now',
          'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=${Uri.encodeComponent(widget.initialMemberName!)}',
          'status': 'online',
          'job': 'Team Member',
          'jobs': '0',
          'completed': '0',
          'progress': '0',
          'unread': 0,
        });
        _activeContactId = newId;
      }
    }

    _messagesByThread = {
      'thread_1': [
        {'isMe': false, 'type': 'text', 'text': 'Hey everyone, check out the Friday updates! 🎉', 'time': '10:00 AM'},
        {'isMe': true, 'type': 'text', 'text': 'Great work this week! Love the progress on the new features.', 'time': '10:05 AM'},
      ],
      'thread_2': [
        {'isMe': false, 'type': 'text', 'text': 'I drafted the new UX design guide.', 'time': '9:30 AM'},
        {'isMe': true, 'type': 'text', 'text': 'Looks amazing! Let me review it.', 'time': '9:45 AM'},
      ],
      'thread_3': [
        {'isMe': false, 'type': 'text', 'text': 'Dinner later tonight? 🍣', 'time': '8:00 AM'},
      ],
      'thread_4': [
        {'isMe': false, 'type': 'text', 'text': 'Praesent a imperdiet felis. Nulla facilisi. 💡', 'time': '8:30 AM'},
        {
          'isMe': true,
          'type': 'audio',
          'duration': '00:54',
          'time': '8:45 AM',
          'waveform': [0.2, 0.4, 0.6, 0.8, 0.5, 0.3, 0.7, 0.9, 0.4, 0.6, 0.8, 0.3, 0.5, 0.7, 0.2, 0.5]
        },
        {'isMe': false, 'type': 'text', 'text': 'Nullam libero leo, elementum et rutrum a, aliquet vel augue. Nullam dignissim, elit sit amet suscipit blandit 😜', 'time': '9:00 AM'},
        {'isMe': false, 'type': 'text', 'text': 'Praesent a imperdiet felis...', 'time': '9:02 AM'},
        {
          'isMe': true,
          'type': 'attachments',
          'count': 3,
          'time': '9:10 AM',
          'images': [
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=150',
            'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=150',
            'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=150'
          ]
        },
        {
          'isMe': false,
          'type': 'audio',
          'duration': '01:24',
          'time': '9:15 AM',
          'waveform': [0.3, 0.5, 0.7, 0.4, 0.6, 0.8, 0.5, 0.3, 0.4, 0.7, 0.9, 0.5, 0.6, 0.8, 0.4, 0.3]
        },
      ],
      'thread_5': [
        {'isMe': false, 'type': 'text', 'text': 'Check out these travel photos! 📸', 'time': '8:00 AM'},
      ],
      'thread_6': [
        {'isMe': false, 'type': 'text', 'text': 'Let\'s prep for the Q&A. 📋', 'time': '7:30 AM'},
        {'isMe': true, 'type': 'text', 'text': 'Sure! I\'ll prepare the slides.', 'time': '7:45 AM'},
        {'isMe': false, 'type': 'text', 'text': 'Perfect, let me know if you need help.', 'time': '8:00 AM'},
      ],
    };

    if (!_messagesByThread.containsKey(_activeContactId)) {
      _messagesByThread[_activeContactId] = [
        {'isMe': false, 'type': 'text', 'text': 'Hello! Let\'s collaborate on this project. 👋', 'time': 'Just now'},
      ];
    }

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _typingController.dispose();
    _msgController.dispose();
    _searchController.dispose();
    _messageScrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    playTukTukSound();
    setState(() {
      _messagesByThread[_activeContactId]?.add({
        'isMe': true,
        'type': 'text',
        'text': text,
        'time': 'Just now',
      });
      _threads.firstWhere((t) => t['id'] == _activeContactId)['lastMsg'] = text;
      _threads.firstWhere((t) => t['id'] == _activeContactId)['time'] = 'Just now';
      _showEmojiPicker = false;
    });

    _msgController.clear();
    
    // Scroll to bottom after message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_messageScrollController.hasClients) {
        _messageScrollController.animateTo(
          _messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _insertEmoji(String emoji) {
    playTukTukSound();
    final text = _msgController.text;
    final selection = _msgController.selection;
    final newText = text.replaceRange(
      selection.start < 0 ? text.length : selection.start,
      selection.end < 0 ? text.length : selection.end,
      emoji,
    );
    _msgController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: (selection.start < 0 ? text.length : selection.start) + emoji.length,
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredThreads {
    if (_searchQuery.isEmpty) return _threads;
    return _threads.where((t) {
      return t['name'].toString().toLowerCase().contains(_searchQuery) ||
          t['lastMsg'].toString().toLowerCase().contains(_searchQuery) ||
          t['job'].toString().toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final activeThread = _threads.firstWhere((t) => t['id'] == _activeContactId);
    final activeMessages = _messagesByThread[_activeContactId] ?? [];
    final filteredThreads = _filteredThreads;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF4F7FE),
        body: Row(
          children: [
            // ═══════════════════════════════════════════════════
            // COLUMN 1: PREMIUM INBOX THREADS LIST (LEFT)
            // ═══════════════════════════════════════════════════
            Container(
              width: 340,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                border: Border(
                  right: BorderSide(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // ── Premium Header with gradient ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF1E1B4B), const Color(0xFF111827)]
                            : [const Color(0xFFEEF2FF), const Color(0xFFFFFFFF)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF111827),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  '${_threads.where((t) => t['status'] == 'online').length} online now',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF6366F1) : const Color(0xFF6366F1),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _buildGlassIconButton(
                              icon: Icons.edit_square,
                              isDark: isDark,
                              onTap: () {
                                playTukTukSound();
                                widget.showToast("New conversation... ✏️");
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Premium Search Bar ──
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF111827),
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search conversations...',
                              hintStyle: TextStyle(
                                color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  // ── Inbox Threads List ──
                  Expanded(
                    child: filteredThreads.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No conversations found',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredThreads.length,
                            itemBuilder: (context, index) {
                              final thread = filteredThreads[index];
                              final bool isActive = thread['id'] == _activeContactId;
                              final int unread = thread['unread'] ?? 0;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                child: InkWell(
                                  onTap: () {
                                    playTukTukSound();
                                    setState(() {
                                      _activeContactId = thread['id'];
                                      // Reset emoji picker when switching threads
                                      _showEmojiPicker = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? (isDark ? const Color(0xFF6366F1).withOpacity(0.12) : const Color(0xFFEEF2FF))
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                      border: isActive
                                          ? Border.all(
                                              color: const Color(0xFF6366F1).withOpacity(0.3),
                                              width: 1,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar with status
                                        Stack(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: isActive
                                                    ? const SweepGradient(
                                                        colors: [
                                                          Color(0xFF6366F1),
                                                          Color(0xFF8B5CF6),
                                                          Color(0xFFA78BFA),
                                                          Color(0xFF6366F1),
                                                        ],
                                                      )
                                                    : null,
                                                color: isActive ? null : Colors.transparent,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(1.5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isDark ? const Color(0xFF111827) : Colors.white,
                                                ),
                                                child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: NetworkImage(thread['avatar']),
                                                ),
                                              ),
                                            ),
                                            if (thread['status'] == 'online')
                                              Positioned(
                                                bottom: 1,
                                                right: 1,
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF10B981),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: isDark ? const Color(0xFF111827) : Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),

                                        // Text content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      thread['name'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: isDark ? Colors.white : const Color(0xFF111827),
                                                        fontSize: 13.5,
                                                        fontWeight: unread > 0 ? FontWeight.w800 : FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    thread['time'],
                                                    style: TextStyle(
                                                      color: unread > 0
                                                          ? const Color(0xFF6366F1)
                                                          : (isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                                                      fontSize: 10,
                                                      fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                thread['title'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      thread['lastMsg'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                                        fontSize: 11,
                                                        fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  if (unread > 0)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Text(
                                                        '$unread',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w800,
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
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════════════
            // COLUMN 2: ACTIVE CONVERSATION (CENTER)
            // ═══════════════════════════════════════════════════
            Expanded(
              child: Column(
                children: [
                  // ── Premium Chat Header with glassmorphism ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF111827), const Color(0xFF1F2937)]
                            : [Colors.white, const Color(0xFFF9FAFB)],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Animated avatar with gradient ring
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Color(0xFF6366F1),
                                Color(0xFF8B5CF6),
                                Color(0xFFA78BFA),
                                Color(0xFF6366F1),
                              ],
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF111827) : Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(activeThread['avatar']),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeThread['name'],
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF111827),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: activeThread['status'] == 'online'
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF6B7280),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  activeThread['status'] == 'online' ? 'Active now' : 'Offline',
                                  style: TextStyle(
                                    color: activeThread['status'] == 'online'
                                        ? const Color(0xFF10B981)
                                        : (isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '  •  ${activeThread['job']}',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Action buttons
                        _buildHeaderActionButton(Icons.videocam_rounded, isDark, () {
                          widget.showToast("Starting video call... 📹");
                        }),
                        const SizedBox(width: 6),
                        _buildHeaderActionButton(Icons.call_rounded, isDark, () {
                          widget.showToast("Dialing ${activeThread['name']}... 📞");
                        }),
                        const SizedBox(width: 6),
                        _buildHeaderActionButton(Icons.more_horiz_rounded, isDark, () {}),
                      ],
                    ),
                  ),

                  // ── Messages list ──
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? [const Color(0xFF0A0E1A), const Color(0xFF0F1629)]
                              : [const Color(0xFFF4F7FE), const Color(0xFFEEF2FF).withOpacity(0.3)],
                        ),
                      ),
                      child: ListView.builder(
                        controller: _messageScrollController,
                        padding: const EdgeInsets.all(24),
                        itemCount: activeMessages.length,
                        itemBuilder: (context, index) {
                          final msg = activeMessages[index];
                          final bool isMe = msg['isMe'];

                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 300 + index * 50),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(isMe ? 20 * (1 - value) : -20 * (1 - value), 0),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!isMe) ...[
                                        Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF4F7FE),
                                            ),
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundImage: NetworkImage(activeThread['avatar']),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],

                                      _buildMessageContent(msg, isMe, isDark),

                                      if (isMe) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF4F7FE),
                                            ),
                                            child: const CircleAvatar(
                                              radius: 14,
                                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=dwayne'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  // Timestamp
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      left: isMe ? 0 : 42,
                                      right: isMe ? 42 : 0,
                                    ),
                                    child: Text(
                                      msg['time'] ?? '',
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Emoji Picker (shown above the input) ──
                  if (_showEmojiPicker)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      height: 280,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF111827) : Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Category tabs
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _emojiCategories.keys.map((category) {
                                  final bool isSelected = _selectedEmojiCategory == category;
                                  return GestureDetector(
                                    onTap: () {
                                      playTukTukSound();
                                      setState(() => _selectedEmojiCategory = category);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? const LinearGradient(
                                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                              )
                                            : null,
                                        color: isSelected ? null : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6)),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // Emoji grid
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: _emojiCategories[_selectedEmojiCategory]!.length,
                              itemBuilder: (context, index) {
                                final emoji = _emojiCategories[_selectedEmojiCategory]![index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => _insertEmoji(emoji),
                                  child: Center(
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Premium Typing Bar ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF111827) : Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildInputActionButton(
                          Icons.add_rounded,
                          isDark,
                          () => widget.showToast("Attach file... 📎"),
                        ),
                        const SizedBox(width: 6),
                        _buildInputActionButton(
                          Icons.image_outlined,
                          isDark,
                          () => widget.showToast("Send image... 🖼️"),
                        ),
                        const SizedBox(width: 6),
                        // Emoji button
                        Container(
                          decoration: BoxDecoration(
                            gradient: _showEmojiPicker
                                ? const LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _showEmojiPicker ? Icons.keyboard_rounded : Icons.sentiment_satisfied_alt_rounded,
                              size: 20,
                              color: _showEmojiPicker
                                  ? Colors.white
                                  : (isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                            ),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              playTukTukSound();
                              setState(() => _showEmojiPicker = !_showEmojiPicker);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Text input field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _msgController,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF111827),
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(
                                  color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                                filled: false,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Send button with gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════════════
            // COLUMN 3: PREMIUM CONTACT PROFILE PANEL (RIGHT)
            // ═══════════════════════════════════════════════════
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                border: Border(
                  left: BorderSide(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Premium Avatar with animated gradient border ──
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                const Color(0xFF6366F1).withOpacity(_pulseAnimation.value),
                                const Color(0xFF8B5CF6).withOpacity(_pulseAnimation.value),
                                const Color(0xFF10B981).withOpacity(_pulseAnimation.value),
                                const Color(0xFFF59E0B).withOpacity(_pulseAnimation.value),
                                const Color(0xFFEF4444).withOpacity(_pulseAnimation.value),
                                const Color(0xFF6366F1).withOpacity(_pulseAnimation.value),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.2 * _pulseAnimation.value),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF111827) : Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundImage: NetworkImage(activeThread['avatar']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name & Role
                    Text(
                      activeThread['name'],
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF6366F1).withOpacity(0.15), const Color(0xFF8B5CF6).withOpacity(0.15)]
                              : [const Color(0xFFEEF2FF), const Color(0xFFF5F3FF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        activeThread['job'],
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: activeThread['status'] == 'online'
                                ? const Color(0xFF10B981)
                                : const Color(0xFF6B7280),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          activeThread['status'] == 'online' ? 'Active now' : 'Last seen recently',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Stats row box with gradient border ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                              : [const Color(0xFFF9FAFB), Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildContactStatColumn(activeThread['jobs'], "Total Jobs", isDark, const Color(0xFF6366F1)),
                          Container(
                            width: 1,
                            height: 30,
                            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                          ),
                          _buildContactStatColumn(activeThread['completed'], "Completed", isDark, const Color(0xFF10B981)),
                          Container(
                            width: 1,
                            height: 30,
                            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                          ),
                          _buildContactStatColumn(activeThread['progress'], "Progress", isDark, const Color(0xFFF59E0B)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Quick Action Buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.videocam_rounded,
                            label: 'Video',
                            gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            isDark: isDark,
                            onTap: () => widget.showToast("Starting video call... 📹"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.call_rounded,
                            label: 'Call',
                            gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                            isDark: isDark,
                            onTap: () => widget.showToast("Calling... 📞"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.share_rounded,
                            label: 'Share',
                            gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                            isDark: isDark,
                            onTap: () => widget.showToast("Share profile... 🔗"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Attachment Audios section
                    _buildSectionHeader("Attachment Audios"),
                    const SizedBox(height: 12),
                    _buildAudioAttachmentTile("It Ain't Me", "03:24", isDark),
                    _buildAudioAttachmentTile("Scared To Be Lonely", "04:24", isDark),
                    _buildAudioAttachmentTile("I Feel It Coming", "01:24", isDark),
                    const SizedBox(height: 24),

                    // Attachment Photos Grid
                    _buildSectionHeader("Attachment Photos"),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: List.generate(6, (index) {
                        final images = [
                          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=150',
                          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=150',
                          'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=150',
                          'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=150',
                          'https://images.unsplash.com/photo-1472214222541-d510753a8707?w=150',
                          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=150',
                        ];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(images[index], fit: BoxFit.cover),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // Attachment Videos
                    _buildSectionHeader("Attachment Videos"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildVideoThumb("https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=150", "03:38"),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildVideoThumb("https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=150", "09:40"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // HELPER WIDGETS
  // ═══════════════════════════════════════════════════

  Widget _buildGlassIconButton({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 16, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildHeaderActionButton(IconData icon, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        playTukTukSound();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 16, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildInputActionButton(IconData icon, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        playTukTukSound();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        playTukTukSound();
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> msg, bool isMe, bool isDark) {
    if (msg['type'] == 'text') {
      return Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : null,
            color: isMe
                ? null
                : (isDark ? const Color(0xFF1F2937) : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
            ),
            border: isMe
                ? null
                : Border.all(
                    color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
            boxShadow: [
              BoxShadow(
                color: isMe
                    ? const Color(0xFF6366F1).withOpacity(0.2)
                    : Colors.black.withOpacity(isDark ? 0.1 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            msg['text'],
            style: TextStyle(
              color: isMe ? Colors.white : (isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827)),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      );
    } else if (msg['type'] == 'audio') {
      final List<double> wave = msg['waveform'];
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                )
              : null,
          color: isMe ? null : (isDark ? const Color(0xFF1F2937) : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: isMe ? null : Border.all(color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? const Color(0xFF6366F1).withOpacity(0.2)
                  : Colors.black.withOpacity(isDark ? 0.1 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isMe ? Colors.white.withOpacity(0.2) : const Color(0xFF6366F1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: isMe ? Colors.white : const Color(0xFF6366F1),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: wave.map((h) => Container(
                width: 3,
                height: 8 + 18 * h,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isMe ? Colors.white.withOpacity(0.6) : const Color(0xFF6366F1).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              )).toList(),
            ),
            const SizedBox(width: 10),
            Text(
              msg['duration'],
              style: TextStyle(
                color: isMe ? Colors.white.withOpacity(0.8) : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    } else if (msg['type'] == 'attachments') {
      final List<String> imgs = msg['images'];
      return Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.1 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file_rounded, size: 12, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    Text(
                      "${msg['count']} attachments",
                      style: TextStyle(
                        color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: imgs.map((url) => Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(url, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildContactStatColumn(String val, String label, bool isDark, Color accentColor) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            color: accentColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: widget.isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: const Text(
            "View all",
            style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioAttachmentTile(String name, String time, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Audio file',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumb(String coverUrl, String duration) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
            ),
            Positioned(
              bottom: 6,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
