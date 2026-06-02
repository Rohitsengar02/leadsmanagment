import 'package:flutter/material.dart';
import 'sound_helper.dart';

class TeamScreen extends StatefulWidget {
  final bool isDark;
  final Function(String message) showToast;
  final ValueChanged<String>? onChatWithMember;

  const TeamScreen({
    super.key,
    required this.isDark,
    required this.showToast,
    this.onChatWithMember,
  });

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool _isGridView = true;
  String _searchQuery = "";
  final Set<String> _selectedMemberIds = {'member_2'}; // John selected by default

  List<Map<String, dynamic>>? _addedMembers;

  List<Map<String, dynamic>> get _members {
    final list = List<Map<String, dynamic>>.from(_initialMembers);
    if (_addedMembers != null) {
      list.addAll(_addedMembers!);
    }
    return list;
  }

  List<Map<String, dynamic>> get _initialMembers => [
    {
      'id': 'member_1',
      'name': 'Talha',
      'role': 'Admin',
      'roleColor': const Color(0xFFEFF6FF),
      'roleTextColor': const Color(0xFF1E40AF),
      'title': 'CEO & Founder',
      'bio': 'CEO & Founder focusing on operations & growth.',
      'email': 'talha@addmee.com',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Talha',
      'cover': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500&auto=format&fit=crop&q=60',
      'badge': Icons.apple,
      'badgeBg': Colors.black,
      'badgeIconColor': Colors.white,
      'tasksAssigned': 24,
      'tasksDone': 21,
      'attendance': 98,
      'progress': 0.85,
      'views': 120,
    },
    {
      'id': 'member_2',
      'name': 'John',
      'role': 'Moderator',
      'roleColor': const Color(0xFFF3E8FF),
      'roleTextColor': const Color(0xFF6B21A8),
      'title': 'Business Analyst',
      'bio': 'Business Analyst optimizing pipelines.',
      'email': 'john@addmee.com',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=John',
      'cover': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=500&auto=format&fit=crop&q=60',
      'badge': Icons.discord_rounded,
      'badgeBg': const Color(0xFF5865F2),
      'badgeIconColor': Colors.white,
      'tasksAssigned': 15,
      'tasksDone': 12,
      'attendance': 92,
      'progress': 0.60,
      'views': 94,
    },
    {
      'id': 'member_3',
      'name': 'Ben',
      'role': 'Lead',
      'roleColor': const Color(0xFFFEF2F2),
      'roleTextColor': const Color(0xFF991B1B),
      'title': 'Frontend Dev',
      'bio': 'Frontend Developer crafting user interfaces.',
      'email': 'ben@addmee.com',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Ben',
      'cover': 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=500&auto=format&fit=crop&q=60',
      'badge': Icons.electric_car, 
      'badgeBg': const Color(0xFFE82127),
      'badgeIconColor': Colors.white,
      'tasksAssigned': 32,
      'tasksDone': 28,
      'attendance': 96,
      'progress': 0.45,
      'views': 210,
    },
    {
      'id': 'member_4',
      'name': 'Sarah',
      'role': 'Support',
      'roleColor': const Color(0xFFECFDF5),
      'roleTextColor': const Color(0xFF047857),
      'title': 'Customer Success',
      'bio': 'Client Success Manager keeping retention high.',
      'email': 'sarah@addmee.com',
      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=Sarah',
      'cover': 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=500&auto=format&fit=crop&q=60',
      'badge': Icons.support_agent_rounded,
      'badgeBg': const Color(0xFF047857),
      'badgeIconColor': Colors.white,
      'tasksAssigned': 18,
      'tasksDone': 17,
      'attendance': 99,
      'progress': 0.94,
      'views': 85,
    },
  ];


  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final filteredMembers = _members.where((m) {
      final query = _searchQuery.toLowerCase();
      return m['name'].toString().toLowerCase().contains(query) ||
          m['title'].toString().toLowerCase().contains(query) ||
          m['email'].toString().toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        key: const PageStorageKey('team_screen_scroll'),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER & CONTROLS ROW
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Members',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _members.length.toString(),
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_rounded,
                              size: 16,
                              color: _isGridView 
                                  ? (isDark ? Colors.white : const Color(0xFF4F46E5))
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              playTukTukSound();
                              setState(() => _isGridView = true);
                            },
                            style: _isGridView 
                                ? IconButton.styleFrom(
                                    backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFEEF2FF),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  )
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.list_rounded,
                              size: 16,
                              color: !_isGridView 
                                  ? (isDark ? Colors.white : const Color(0xFF4F46E5))
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              playTukTukSound();
                              setState(() => _isGridView = false);
                            },
                            style: !_isGridView 
                                ? IconButton.styleFrom(
                                    backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFEEF2FF),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    IconButton(
                      icon: Icon(Icons.filter_list_rounded, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        playTukTukSound();
                        widget.showToast("Filter options opening... 📊");
                      },
                    ),
                    const SizedBox(width: 12),

                    SizedBox(
                      width: 220,
                      height: 40,
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          prefixIcon: const Icon(Icons.search, size: 14, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    ElevatedButton.icon(
                      icon: const Text('Add Members', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      label: const Icon(Icons.keyboard_arrow_down_rounded, size: 14),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        playTukTukSound();
                        _showAddMemberDialog();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    playTukTukSound();
                    setState(() {
                      if (_selectedMemberIds.length == _members.length) {
                        _selectedMemberIds.clear();
                      } else {
                        _selectedMemberIds.addAll(_members.map((m) => m['id'] as String));
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedMemberIds.length == _members.length
                                ? const Color(0xFF4F46E5)
                                : Colors.grey,
                            width: 1.5,
                          ),
                          color: _selectedMemberIds.length == _members.length
                              ? const Color(0xFF4F46E5)
                              : Colors.transparent,
                        ),
                        child: _selectedMemberIds.length == _members.length
                            ? const Icon(Icons.check, size: 10, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select all',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _isGridView 
                ? _buildMembersGrid(filteredMembers, isDark)
                : _buildMembersList(filteredMembers, isDark),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final titleController = TextEditingController();
    final bioController = TextEditingController();
    final emailController = TextEditingController();
    final tasksAssignedController = TextEditingController(text: '10');
    final tasksDoneController = TextEditingController(text: '8');
    final attendanceController = TextEditingController(text: '95');
    
    String selectedRole = 'Lead';
    
    final List<String> coverPresets = [
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=500&auto=format&fit=crop&q=60',
    ];
    String selectedCover = coverPresets[0];

    final List<String> avatarSeeds = ['Talha', 'John', 'Ben', 'Sarah', 'Grace', 'Lucas', 'Alex', 'Emma'];
    String selectedSeed = 'Grace';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = widget.isDark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final double progress = (nameController.text.trim().isNotEmpty ? 0.25 : 0) +
                (titleController.text.trim().isNotEmpty ? 0.25 : 0) +
                (emailController.text.trim().isNotEmpty && emailController.text.contains('@') ? 0.25 : 0) +
                (bioController.text.trim().isNotEmpty ? 0.25 : 0);

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF4F46E5), size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Add Team Member',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Form Completion: ${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (progress == 1.0)
                            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Full Name',
                              placeholder: 'e.g. Gladys Leonard',
                              controller: nameController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Email',
                              placeholder: 'e.g. gladys@addmee.com',
                              controller: emailController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Title / Profession',
                              placeholder: 'e.g. Graphick Designer',
                              controller: titleController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Role Group',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedRole,
                                      isExpanded: true,
                                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                      items: ['Admin', 'Moderator', 'Lead', 'Support'].map((String val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(
                                            val,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        if (newVal != null) {
                                          playTukTukSound();
                                          setDialogState(() {
                                            selectedRole = newVal;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildDialogInput(
                        label: 'Short Bio',
                        placeholder: 'UX/UI designer creating dynamic web workflows...',
                        controller: bioController,
                        isDark: isDark,
                        onChanged: (val) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Assigned Tasks',
                              placeholder: '10',
                              controller: tasksAssignedController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Completed Tasks',
                              placeholder: '8',
                              controller: tasksDoneController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDialogInput(
                              label: 'Attendance %',
                              placeholder: '95',
                              controller: attendanceController,
                              isDark: isDark,
                              onChanged: (val) => setDialogState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Select Cover Banner Image',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: coverPresets.length,
                          itemBuilder: (context, idx) {
                            final preset = coverPresets[idx];
                            final bool isSel = selectedCover == preset;
                            return GestureDetector(
                              onTap: () {
                                playTukTukSound();
                                setDialogState(() {
                                  selectedCover = preset;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSel ? const Color(0xFF4F46E5) : Colors.transparent,
                                    width: 2,
                                  ),
                                  image: DecorationImage(image: NetworkImage(preset), fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Select Profile avatar seed',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: avatarSeeds.length,
                          itemBuilder: (context, idx) {
                            final seed = avatarSeeds[idx];
                            final avatarUrl = 'https://api.dicebear.com/7.x/open-peeps/png?seed=$seed';
                            final bool isSel = selectedSeed == seed;
                            return GestureDetector(
                              onTap: () {
                                playTukTukSound();
                                setDialogState(() {
                                  selectedSeed = seed;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSel ? const Color(0xFF4F46E5) : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(avatarUrl),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    final String email = emailController.text.trim();
                    if (name.isEmpty || email.isEmpty) {
                      widget.showToast('Please fill in Name and Email! ❌');
                      return;
                    }
                    if (!email.contains('@')) {
                      widget.showToast('Please provide a valid Email! ❌');
                      return;
                    }

                    final int tAssigned = int.tryParse(tasksAssignedController.text.trim()) ?? 0;
                    final int tDone = int.tryParse(tasksDoneController.text.trim()) ?? 0;
                    final int att = int.tryParse(attendanceController.text.trim()) ?? 0;
                    final double progressValue = tAssigned > 0 ? (tDone / tAssigned).clamp(0.0, 1.0) : 0.0;

                    Color rColor = const Color(0xFFEFF6FF);
                    Color rtColor = const Color(0xFF1E40AF);
                    if (selectedRole == 'Moderator') {
                      rColor = const Color(0xFFF3E8FF);
                      rtColor = const Color(0xFF6B21A8);
                    } else if (selectedRole == 'Support') {
                      rColor = const Color(0xFFECFDF5);
                      rtColor = const Color(0xFF047857);
                    } else if (selectedRole == 'Lead') {
                      rColor = const Color(0xFFFEF2F2);
                      rtColor = const Color(0xFF991B1B);
                    }

                    final newMember = {
                      'id': 'member_${DateTime.now().millisecondsSinceEpoch}',
                      'name': name,
                      'role': selectedRole,
                      'roleColor': rColor,
                      'roleTextColor': rtColor,
                      'title': titleController.text.trim().isEmpty ? 'Team Specialist' : titleController.text.trim(),
                      'bio': bioController.text.trim().isEmpty ? 'Active team contributor.' : bioController.text.trim(),
                      'email': email,
                      'avatar': 'https://api.dicebear.com/7.x/open-peeps/png?seed=$selectedSeed',
                      'cover': selectedCover,
                      'badge': selectedRole == 'Admin' 
                          ? Icons.apple 
                          : (selectedRole == 'Moderator' ? Icons.discord_rounded : Icons.support_agent_rounded),
                      'badgeBg': const Color(0xFF4F46E5),
                      'badgeIconColor': Colors.white,
                      'tasksAssigned': tAssigned,
                      'tasksDone': tDone,
                      'attendance': att,
                      'progress': progressValue,
                      'views': 12,
                    };

                    playTukTukSound();
                    setState(() {
                      _addedMembers ??= [];
                      _addedMembers!.add(newMember);
                    });
                    
                    Navigator.pop(context);
                    widget.showToast("Member '$name' added successfully! 🎉");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Member', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogInput({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required bool isDark,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersGrid(List<Map<String, dynamic>> members, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 Cards in 1 Row
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78, // Increased ratio to shrink height and remove empty space
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final String id = member['id'];
        final bool isSelected = _selectedMemberIds.contains(id);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected 
                  ? (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5))
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? (isDark ? const Color(0xFF818CF8).withOpacity(0.12) : const Color(0xFF4F46E5).withOpacity(0.06))
                    : Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cover Image Banner (Height: 85) & Overlapping Profile Photo
              SizedBox(
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      height: 85,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          member['cover'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Top-Right Glass Plus Button
                    Positioned(
                      top: 14,
                      right: 14,
                      child: InkWell(
                        onTap: () {
                          playTukTukSound();
                          widget.showToast("Followed ${member['name']}! 🚀");
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, size: 14, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ),

                    // Centered Avatar (Top: 55, Radius: 28) with Gradient Border Ring
                    Positioned(
                      top: 55,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Color(0xFF8B5CF6),
                              Color(0xFF3B82F6),
                              Color(0xFF10B981),
                              Color(0xFFF59E0B),
                              Color(0xFFEF4444),
                              Color(0xFF8B5CF6),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(member['avatar']),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Member Profile Details (Name, Role, Bio Subtitle)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          member['name'],
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : member['roleColor'],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            member['role'],
                            style: TextStyle(
                              color: isDark ? const Color(0xFFCBD5E1) : member['roleTextColor'],
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      member['bio'],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 3. Stats details displayed in vertical list form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  children: [
                    _buildRefListDetailRow(
                      icon: Icons.assignment_outlined,
                      iconColor: const Color(0xFF3B82F6),
                      label: "Tasks Assigned",
                      value: member['tasksAssigned'].toString(),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 4),
                    _buildRefListDetailRow(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: const Color(0xFF10B981),
                      label: "Tasks Completed",
                      value: member['tasksDone'].toString(),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 4),
                    _buildRefListDetailRow(
                      icon: Icons.calendar_today_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      label: "Attendance Rate",
                      value: "${member['attendance']}%",
                      isDark: isDark,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 4. Progress bar with gradients
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 4.5,
                    width: double.infinity,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: member['progress'],
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10), // Replaced Spacer with tight spacing to collapse gap

              // 5. Action Buttons with 3D Gradients
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _build3DGradientButton(
                      icon: Icons.info_outline_rounded,
                      tooltip: "Details",
                      gradient: const LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFF1D4ED8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      onTap: () {
                        playTukTukSound();
                        widget.showToast("Profile details of ${member['name']}");
                      },
                    ),
                    _build3DGradientButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      tooltip: "Chat",
                      gradient: const LinearGradient(
                        colors: [Color(0xFF34D399), Color(0xFF047857)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      onTap: () {
                        playTukTukSound();
                        if (widget.onChatWithMember != null) {
                          widget.onChatWithMember!(member['name']);
                        } else {
                          widget.showToast("Opening DM with ${member['name']}...");
                        }
                      },
                    ),
                    _build3DGradientButton(
                      icon: Icons.phone_outlined,
                      tooltip: "Call",
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF472B6), Color(0xFFBE123C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      onTap: () {
                        playTukTukSound();
                        widget.showToast("Dialing voice bridge for ${member['name']}...");
                      },
                    ),
                    _build3DGradientButton(
                      icon: Icons.add_task_rounded,
                      tooltip: "Assign Task",
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFF6D28D9)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      onTap: () {
                        playTukTukSound();
                        widget.showToast("Sprint dispatch card sent to ${member['name']}!");
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              Divider(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                height: 1,
              ),

              // 6. Bottom card selector row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        playTukTukSound();
                        setState(() {
                          if (isSelected) {
                            _selectedMemberIds.remove(id);
                          } else {
                            _selectedMemberIds.add(id);
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF4F46E5) : Colors.grey,
                                width: 1.5,
                              ),
                              color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 7, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isSelected ? 'Selected' : 'Select',
                            style: TextStyle(
                              color: isSelected 
                                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                  : const Color(0xFF94A3B8),
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded, size: 14),
                      color: const Color(0xFF94A3B8),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        playTukTukSound();
                        widget.showToast("More menu for ${member['name']}");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRefListDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4.5),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 11, color: iconColor),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isHighlight
                ? const Color(0xFF10B981)
                : (isDark ? Colors.white : const Color(0xFF0F172A)),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _build3DGradientButton({
    required IconData icon,
    required String tooltip,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 2.5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 0.8,
                ),
              ),
              child: Icon(
                icon,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersList(List<Map<String, dynamic>> members, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = members[index];
        final String id = member['id'];
        final bool isSelected = _selectedMemberIds.contains(id);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                activeColor: const Color(0xFF4F46E5),
                onChanged: (val) {
                  playTukTukSound();
                  setState(() {
                    if (isSelected) {
                      _selectedMemberIds.remove(id);
                    } else {
                      _selectedMemberIds.add(id);
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(member['avatar']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member['name'],
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : member['roleColor'],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            member['role'],
                            style: TextStyle(
                              color: isDark ? const Color(0xFFCBD5E1) : member['roleTextColor'],
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${member['title']} • ${member['email']}",
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildStatItem(Icons.visibility_outlined, member['views'].toString(), isDark),
                ],
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 16),
                color: const Color(0xFF94A3B8),
                onPressed: () {
                  playTukTukSound();
                  widget.showToast("More options for ${member['name']}");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String val, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon, 
          size: 13, 
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 4),
        Text(
          val,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
