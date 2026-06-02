import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'sound_helper.dart';

class AIPlaygroundScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onBack;
  final Function(String message) showToast;
  final Function(String tab, String leadName) onNavigate;

  const AIPlaygroundScreen({
    super.key,
    required this.isDark,
    required this.onBack,
    required this.showToast,
    required this.onNavigate,
  });

  @override
  State<AIPlaygroundScreen> createState() => _AIPlaygroundScreenState();
}

class _AIPlaygroundScreenState extends State<AIPlaygroundScreen> {
  final Map<String, dynamic> _toolStates = {
    'proposal': {'status': 'Idle', 'val': '₹48.6L'},
    'talks': {'status': 'Ready', 'wave': true},
    'scorer': {'status': 'Scored', 'score': '94.2%'},
    'copilot': {'status': 'Generating...', 'msg': 'Generating reply...'},
    'autopilot': {'status': 'Active', 'mode': 'Performance Routing'},
    'sentiment': {'status': 'Idle', 'result': 'Positive'},
    'enrichment': {'status': 'Idle', 'found': 12},
    'forecaster': {'status': 'Idle', 'forecast': '₹54.2L'},
    'sla': {'status': 'Monitoring', 'risk': 'Low (2%)'},
    'benchmarking': {'status': 'Idle', 'analyzed': '3 Rivals'},
  };

  void _runAction(String toolKey, String label, VoidCallback cb) {
    playTukTukSound();
    widget.showToast("Executing $label... ⚡");
    setState(() {
      cb();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    final List<Map<String, dynamic>> tools = [
      {
        'key': 'copilot',
        'title': 'Reply Suggestions',
        'description': 'Get AI-generated responses for relevant posts and client queries instantly.',
        'gradient': [const Color(0xFFE0E0FF), const Color(0xFFF3E8FF)],
        'btnText': 'Generate Reply',
        'visual': _AnimatedReplySuggestionsVisual(isDark: isDark),
        'onTap': () => _runAction('copilot', 'Reply Copilot', () {
          _toolStates['copilot']['msg'] = 'Reply Copilot Ready! ✨';
        }),
      },
      {
        'key': 'proposal',
        'title': 'AI Proposal Maker',
        'description': 'Draft corporate proposals, quotes and support agreements automatically.',
        'gradient': [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
        'btnText': 'Create Proposal',
        'visual': _AnimatedProposalMakerVisual(isDark: isDark, value: _toolStates['proposal']['val']),
        'onTap': () => _runAction('proposal', 'Proposal Draft', () {
          _toolStates['proposal']['val'] = '₹52.4L (Draft)';
        }),
      },
      {
        'key': 'talks',
        'title': 'AI Talks & Voice Agent',
        'description': 'Transcribe customer calls and voice dictation logs in real time.',
        'gradient': [const Color(0xFFFDF2F8), const Color(0xFFFCE7F3)],
        'btnText': 'Start Recording',
        'visual': _AnimatedAITalksVisual(isDark: isDark),
        'onTap': () => _runAction('talks', 'Voice Intel', () {
          widget.showToast("Voice recorder initialized! 🎙️");
        }),
      },
      {
        'key': 'scorer',
        'title': 'Smart Intent Scorer',
        'description': 'Track and output lead conversion probabilities with behavioral data.',
        'gradient': [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
        'btnText': 'Run Scorer',
        'visual': _AnimatedIntentScorerVisual(isDark: isDark, scoreText: _toolStates['scorer']['score']),
        'onTap': () => _runAction('scorer', 'Scorer recalculation', () {
          _toolStates['scorer']['score'] = '98.1%';
        }),
      },
      {
        'key': 'autopilot',
        'title': 'Autopilot Router',
        'description': 'Simulate autonomous lead dispatch metrics mapping capacity loads.',
        'gradient': [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
        'btnText': 'Configure Router',
        'visual': _AnimatedAutopilotRouterVisual(isDark: isDark),
        'onTap': () => _runAction('autopilot', 'Autopilot config', () {
          widget.showToast("Dispatcher nodes configured successfully!");
        }),
      },
      {
        'key': 'sentiment',
        'title': 'Sentiment Analyzer',
        'description': 'Analyze customer interaction tone to identify churn and closing risks.',
        'gradient': [const Color(0xFFECFEFF), const Color(0xFFCFFAFE)],
        'btnText': 'Analyze Tone',
        'visual': _AnimatedSentimentAnalyzerVisual(isDark: isDark, resultText: _toolStates['sentiment']['result']),
        'onTap': () => _runAction('sentiment', 'Sentiment extraction', () {
          _toolStates['sentiment']['result'] = 'Positive (95%)';
        }),
      },
      {
        'key': 'enrichment',
        'title': 'Lead Enrichment Bot',
        'description': 'Auto-enrich prospect profiles with social profiles and organization logs.',
        'gradient': [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
        'btnText': 'Fetch Profile',
        'visual': _AnimatedEnrichmentVisual(isDark: isDark, count: _toolStates['enrichment']['found']),
        'onTap': () => _runAction('enrichment', 'Profile enrichment', () {
          _toolStates['enrichment']['found'] = 24;
        }),
      },
      {
        'key': 'forecaster',
        'title': 'Revenue Forecaster',
        'description': 'Forecast pipeline velocity and conversion milestones using deal trends.',
        'gradient': [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)],
        'btnText': 'Run Forecast',
        'visual': _AnimatedForecasterVisual(isDark: isDark, forecastText: _toolStates['forecaster']['forecast']),
        'onTap': () => _runAction('forecaster', 'Forecast simulator', () {
          _toolStates['forecaster']['forecast'] = '₹62.8L (+15%)';
        }),
      },
      {
        'key': 'sla',
        'title': 'SLA Breach Predictor',
        'description': 'Predict response time alerts and bypass lead queue bottlenecks.',
        'gradient': [const Color(0xFFF9FAFB), const Color(0xFFF3F4F6)],
        'btnText': 'Scan Safety',
        'visual': _AnimatedSLAPredictorVisual(isDark: isDark, riskText: _toolStates['sla']['risk']),
        'onTap': () => _runAction('sla', 'SLA breach scan', () {
          _toolStates['sla']['risk'] = 'Near Zero (0.1%)';
        }),
      },
      {
        'key': 'benchmarking',
        'title': 'Competitor Benchmark',
        'description': 'Analyze feature and price differentials to offer custom counters.',
        'gradient': [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1)],
        'btnText': 'Assess Rivals',
        'visual': _AnimatedBenchmarkingVisual(isDark: isDark),
        'onTap': () => _runAction('benchmarking', 'Competitor benchmarking', () {
          _toolStates['benchmarking']['analyzed'] = '5 Rivals assessed';
        }),
      },
    ];

    return SingleChildScrollView(
      key: const PageStorageKey('ai_playground_scroll'),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                onPressed: widget.onBack,
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2E1A47) : const Color(0xFFFFECE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, color: isDark ? const Color(0xFFD8B4FE) : const Color(0xFFFF3377), size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'AI UTILITIES PORTAL',
                                style: TextStyle(color: isDark ? const Color(0xFFD8B4FE) : const Color(0xFFFF3377), fontSize: 8.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sociafy AI Playground & Copilot Suite',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Interactive CRM automation models and client intelligence nodes with live process visualizers.',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Tools Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.78,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  final List<Color> bgGradient = tool['gradient'];

                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. TOP HALF: Animated Graphic Backdrop
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark 
                                      ? [bgGradient[0].withOpacity(0.12), bgGradient[1].withOpacity(0.08)]
                                      : bgGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _SparkleGridPainter(isDark: isDark),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: tool['visual'] as Widget,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          Container(
                            height: 1,
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          ),

                          // 2. BOTTOM HALF: Text Info & Action Button
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tool['title'] as String,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      tool['description'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _getToolStatus(tool['key'] as String),
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: tool['onTap'] as VoidCallback,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
                                          foregroundColor: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          tool['btnText'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
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
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getToolStatus(String key) {
    final state = _toolStates[key];
    if (key == 'copilot') return state['msg'];
    if (key == 'proposal') return "Value: ${state['val']}";
    if (key == 'scorer') return "Intent: ${state['score']}";
    if (key == 'sentiment') return "Sentiment: ${state['result']}";
    if (key == 'enrichment') return "Enriched: ${state['found']}";
    if (key == 'forecaster') return "Forecast: ${state['forecast']}";
    if (key == 'sla') return "Risk: ${state['risk']}";
    if (key == 'benchmarking') return "Status: ${state['analyzed']}";
    return "Status: ${state['status']}";
  }
}

// Sparkle Grid Background Painter
class _SparkleGridPainter extends CustomPainter {
  final bool isDark;
  _SparkleGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.015)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 20) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// =========================================================================
// ==================== ANIMATED VISUALS IMPLEMENTATIONS ===================
// =========================================================================

// Helper for bouncy custom springs
double _springCurve(double t) {
  // Simulates a spring/elastic response using dampened cosine wave
  if (t == 0 || t == 1) return t;
  const period = 0.3;
  return math.pow(2, -10 * t) * math.sin((t - period / 4) * (2 * math.pi) / period) + 1;
}

// Visual 1: Reply Suggestions (Staggered Chat Bubbles and sparkles bouncing with spring dynamics)
class _AnimatedReplySuggestionsVisual extends StatefulWidget {
  final bool isDark;
  const _AnimatedReplySuggestionsVisual({required this.isDark});

  @override
  State<_AnimatedReplySuggestionsVisual> createState() => _AnimatedReplySuggestionsVisualState();
}

class _AnimatedReplySuggestionsVisualState extends State<_AnimatedReplySuggestionsVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Setup 4 decorative floating sparkles
    _sparkles = List.generate(4, (index) {
      final rand = math.Random(index);
      return _Sparkle(
        x: 30.0 + rand.nextDouble() * 120.0,
        y: 20.0 + rand.nextDouble() * 80.0,
        size: 6.0 + rand.nextDouble() * 6.0,
        speed: 1.5 + rand.nextDouble() * 1.5,
        phase: rand.nextDouble() * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Custom staggered bouncy scales for chat bubbles using intervals & Curves.easeOutBack
        final bubble1Val = CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
        ).value;
        
        final bubble2Val = CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.15, 0.5, curve: Curves.easeOutBack),
        ).value;

        // Fade-out towards the end of the loop
        final fadeOut = CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
        ).value;
        final opacity = 1.0 - fadeOut;

        // Elastic scaling for the central reply pill
        final pillScale = 0.96 + 0.08 * math.sin(t * math.pi * 4).abs();

        return Stack(
          children: [
            // Infinite Floating Sparkles
            ..._sparkles.map((sparkle) {
              final sparkleOpacity = (0.2 + 0.8 * math.sin(t * math.pi * 2 * sparkle.speed + sparkle.phase)).clamp(0.0, 1.0);
              return Positioned(
                left: sparkle.x + 8 * math.sin(t * math.pi * sparkle.speed),
                top: sparkle.y + 8 * math.cos(t * math.pi * sparkle.speed),
                child: Opacity(
                  opacity: sparkleOpacity,
                  child: Icon(
                    Icons.auto_awesome, 
                    color: isDark ? const Color(0xFFA5B4FC).withOpacity(0.6) : const Color(0xFF6366F1).withOpacity(0.4), 
                    size: sparkle.size,
                  ),
                ),
              );
            }),

            // Chat bubble 1 (Top-Right)
            Positioned(
              top: 14,
              right: 12,
              child: Opacity(
                opacity: (opacity * bubble1Val).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: bubble1Val,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withOpacity(0.9) : Colors.white.withOpacity(0.95),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(2),
                      ),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Is the deal finalized?",
                      style: TextStyle(
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF475569), 
                        fontSize: 9, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Chat bubble 2 (Middle-Right)
            Positioned(
              top: 50,
              right: 20,
              child: Opacity(
                opacity: (opacity * bubble2Val).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: bubble2Val,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155).withOpacity(0.95) : Colors.white.withOpacity(0.95),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(2),
                      ),
                      border: Border.all(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Yes, proposal is sent! ⚡",
                      style: TextStyle(
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF334155), 
                        fontSize: 9, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Central Sparkle Reply Pill
            Center(
              child: Transform.scale(
                scale: pillScale,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF312E81) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark ? const Color(0xFF6366F1).withOpacity(0.6) : const Color(0xFFC7D2FE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)).withOpacity(isDark ? 0.4 : 0.15),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5), size: 14),
                      const SizedBox(width: 8),
                      Text(
                        "AI Suggestions Ready",
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Paper Airplane zooming out
            Positioned(
              bottom: 12,
              left: 24 + 140 * (t > 0.6 ? (t - 0.6) / 0.4 : 0.0),
              child: Opacity(
                opacity: (t > 0.6 ? (1.0 - (t - 0.6) / 0.4) : 1.0).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: -0.3 + 0.1 * math.sin(t * math.pi * 4),
                  child: Icon(
                    Icons.send_rounded, 
                    color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5), 
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Sparkle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  _Sparkle({required this.x, required this.y, required this.size, required this.speed, required this.phase});
}

// Visual 2: AI Proposal Maker (Scanner Laser line & bouncy approved stamp with 3D tilting)
class _AnimatedProposalMakerVisual extends StatefulWidget {
  final bool isDark;
  final String value;
  const _AnimatedProposalMakerVisual({required this.isDark, required this.value});

  @override
  State<_AnimatedProposalMakerVisual> createState() => _AnimatedProposalMakerVisualState();
}

class _AnimatedProposalMakerVisualState extends State<_AnimatedProposalMakerVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Laser Y position sweeps down, then returns
        final laserT = math.sin(t * math.pi);
        final laserY = laserT * 105.0;

        // Approved Stamp pops up with Spring curve when laser reaches bottom (t > 0.4)
        double stampScale = 0.0;
        if (t > 0.4 && t < 0.9) {
          final stampProgress = (t - 0.4) / 0.3;
          if (stampProgress < 1.0) {
            stampScale = _springCurve(stampProgress);
          } else {
            stampScale = 1.0;
          }
        } else if (t >= 0.9) {
          stampScale = 1.0 - (t - 0.9) / 0.1; // Fade out stamp
        }

        // Float / 3D Tilt of the sheet
        final tiltAngle = 0.04 * math.sin(t * math.pi * 2);

        return Stack(
          children: [
            // Document preview sheet
            Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective
                  ..rotateY(tiltAngle)
                  ..rotateX(tiltAngle * 0.5),
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 35, 
                            height: 6, 
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), 
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(4, (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Container(
                              width: 75.0 - (index * 8), 
                              height: 3.5, 
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9), 
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 25, 
                                height: 5, 
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF34D399).withOpacity(0.3) : const Color(0xFF10B981).withOpacity(0.2), 
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Icon(
                                Icons.check_circle_rounded, 
                                size: 12, 
                                color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Laser scanning bar
                      Positioned(
                        top: laserY,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFFF472B6) : const Color(0xFFFF3377),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark ? const Color(0xFFF472B6) : const Color(0xFFFF3377)).withOpacity(0.8), 
                                blurRadius: 6, 
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // APPROVED stamp
                      if (stampScale > 0)
                        Center(
                          child: Transform.scale(
                            scale: stampScale,
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981), 
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "APPROVED",
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Floating Price Badge
            Positioned(
              bottom: 12,
              right: 12,
              child: Transform.scale(
                scale: 0.95 + 0.05 * math.sin(t * math.pi * 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0369A1) : const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF0284C7) : const Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0369A1), 
                      fontSize: 10.5, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 3: AI Talks / Voice waveform active jumping bars with ripples
class _AnimatedAITalksVisual extends StatefulWidget {
  final bool isDark;
  const _AnimatedAITalksVisual({required this.isDark});

  @override
  State<_AnimatedAITalksVisual> createState() => _AnimatedAITalksVisualState();
}

class _AnimatedAITalksVisualState extends State<_AnimatedAITalksVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        return Stack(
          children: [
            // Radar pulse ring in background
            ...List.generate(2, (index) {
              final rippleProgress = (t + (index * 0.5)) % 1.0;
              final rippleRadius = 25.0 + rippleProgress * 65.0;
              final rippleOpacity = 1.0 - rippleProgress;

              return Center(
                child: Container(
                  width: rippleRadius,
                  height: rippleRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777)).withOpacity(rippleOpacity * 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),

            // Interactive jumping equalizer bars
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(10, (index) {
                  // Generate organic waves using sine and cos combinations
                  final phase = index * (math.pi / 5);
                  final waveVal = math.sin((t * math.pi * 2) + phase) * 0.6 + math.cos((t * math.pi * 4) - phase) * 0.4;
                  final height = 12 + (waveVal.abs() * 26);
                  final opacity = 0.5 + (waveVal.abs() * 0.5);

                  return Container(
                    width: 4,
                    height: height,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                            ? [const Color(0xFFF472B6), const Color(0xFFEC4899)] 
                            : [const Color(0xFFDB2777), const Color(0xFFF43F5E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2.5),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: const Color(0xFFEC4899).withOpacity(0.4),
                            blurRadius: 4,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Pulsing Recording Badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Transform.scale(
                scale: 0.95 + 0.05 * math.sin(t * math.pi * 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF4C0519) : const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF9F1239) : const Color(0xFFFBCFE8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Red flashing dot
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE11D48),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Voice Live", 
                        style: TextStyle(
                          color: isDark ? const Color(0xFFFDA4AF) : const Color(0xFFDB2777), 
                          fontSize: 8.5, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 4: Smart Intent Scorer (Speedometer / Gauge with concentric rotations)
class _AnimatedIntentScorerVisual extends StatefulWidget {
  final bool isDark;
  final String scoreText;
  const _AnimatedIntentScorerVisual({required this.isDark, required this.scoreText});

  @override
  State<_AnimatedIntentScorerVisual> createState() => _AnimatedIntentScorerVisualState();
}

class _AnimatedIntentScorerVisualState extends State<_AnimatedIntentScorerVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = 0.97 + 0.06 * math.sin(t * math.pi * 2).abs();

        return Stack(
          children: [
            // Background Dashboard Ring rotating clockwise
            Center(
              child: Transform.rotate(
                angle: t * 2 * math.pi,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFCBD5E1).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Circular Progress Indicator pulsing
            Center(
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? const Color(0xFF10B981) : const Color(0xFF34D399)).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 66,
                      height: 66,
                      child: CircularProgressIndicator(
                        value: 0.65 + 0.28 * math.sin(t * math.pi * 2).abs(),
                        strokeWidth: 6,
                        backgroundColor: isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Inner Core Text Display
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.scoreText,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A), 
                      fontSize: 14, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "CONVERSION", 
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), 
                      fontSize: 6.5, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 5: Autopilot Router (Nodes bouncing with multiple fast routing packets)
class _AnimatedAutopilotRouterVisual extends StatefulWidget {
  final bool isDark;
  const _AnimatedAutopilotRouterVisual({required this.isDark});

  @override
  State<_AnimatedAutopilotRouterVisual> createState() => _AnimatedAutopilotRouterVisualState();
}

class _AnimatedAutopilotRouterVisualState extends State<_AnimatedAutopilotRouterVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Path positions for 3 routing packets at staggered timeline offsets
        final packets = List.generate(3, (index) {
          final pT = (t + (index * 0.33)) % 1.0;
          const p0 = Offset(24, 24);
          final p1 = Offset(140 * 0.35, 100 * 0.9);
          final p2 = Offset(140 * 0.65, 100 * 0.15);
          const p3 = Offset(116, 76);

          // Bezier calculation
          final x = math.pow(1 - pT, 3) * p0.dx +
              3 * math.pow(1 - pT, 2) * pT * p1.dx +
              3 * (1 - pT) * math.pow(pT, 2) * p2.dx +
              math.pow(pT, 3) * p3.dx;
          final y = math.pow(1 - pT, 3) * p0.dy +
              3 * math.pow(1 - pT, 2) * pT * p1.dy +
              3 * (1 - pT) * math.pow(pT, 2) * p2.dy +
              math.pow(pT, 3) * p3.dy;

          return Offset(x, y);
        });

        // Bouncy scales for the endpoints whenever packet reaches them
        final startNodeScale = 1.0 + 0.12 * math.sin(t * math.pi * 6).abs();
        final endNodeScale = 1.0 + 0.15 * math.cos(t * math.pi * 6).abs();

        return Stack(
          children: [
            Center(
              child: SizedBox(
                width: 140,
                height: 100,
                child: CustomPaint(
                  painter: _RouterPathPainter(isDark: isDark),
                ),
              ),
            ),

            // Packet dots floating along bezier path
            ...packets.map((pos) => Positioned(
                  left: pos.dx - 4,
                  top: pos.dy - 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFBBF24).withOpacity(0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                )),

            // Starting Node (Top Left)
            Positioned(
              top: 14,
              left: 14,
              child: Transform.scale(
                scale: startNodeScale,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person, 
                    size: 12, 
                    color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ),

            // Receiving Node (Bottom Right)
            Positioned(
              bottom: 14,
              right: 18,
              child: Transform.scale(
                scale: endNodeScale,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF312E81) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.call_split_rounded, 
                    size: 12, 
                    color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 6: Sentiment Analyzer (Emoji rotation & spring bouncing scans)
class _AnimatedSentimentAnalyzerVisual extends StatefulWidget {
  final bool isDark;
  final String resultText;
  const _AnimatedSentimentAnalyzerVisual({required this.isDark, required this.resultText});

  @override
  State<_AnimatedSentimentAnalyzerVisual> createState() => _AnimatedSentimentAnalyzerVisualState();
}

class _AnimatedSentimentAnalyzerVisualState extends State<_AnimatedSentimentAnalyzerVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Determine which face is currently scanning/selected
        // Splits the 0.0 - 1.0 timeline into 3 segments
        int activeIdx = 0;
        double faceScaleVal = 0.0;
        if (t < 0.33) {
          activeIdx = 0; // Very Satisfied
          final progress = (t / 0.33);
          faceScaleVal = progress < 0.7 
              ? _springCurve(progress / 0.7) 
              : 1.0 - ((progress - 0.7) / 0.3) * 0.15;
        } else if (t < 0.66) {
          activeIdx = 1; // Neutral
          final progress = ((t - 0.33) / 0.33);
          faceScaleVal = progress < 0.7 
              ? _springCurve(progress / 0.7) 
              : 1.0 - ((progress - 0.7) / 0.3) * 0.15;
        } else {
          activeIdx = 2; // Dissatisfied
          final progress = ((t - 0.66) / 0.34);
          faceScaleVal = progress < 0.7 
              ? _springCurve(progress / 0.7) 
              : 1.0 - ((progress - 0.7) / 0.3) * 0.15;
        }

        return Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: activeIdx == 0 ? 1.0 + 0.22 * faceScaleVal : 0.9,
                    child: _buildSentimentFace(
                      Icons.sentiment_very_satisfied, 
                      const Color(0xFF06B6D4), 
                      activeIdx == 0, 
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Transform.scale(
                    scale: activeIdx == 1 ? 1.0 + 0.22 * faceScaleVal : 0.9,
                    child: _buildSentimentFace(
                      Icons.sentiment_neutral, 
                      const Color(0xFFF59E0B), 
                      activeIdx == 1, 
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Transform.scale(
                    scale: activeIdx == 2 ? 1.0 + 0.22 * faceScaleVal : 0.9,
                    child: _buildSentimentFace(
                      Icons.sentiment_very_dissatisfied, 
                      const Color(0xFFEF4444), 
                      activeIdx == 2, 
                      isDark,
                    ),
                  ),
                ],
              ),
            ),

            // Glowing Indicator tag
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF083344) : const Color(0xFFCFFAFE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF0891B2) : const Color(0xFF22D3EE),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.resultText,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2), 
                    fontSize: 9, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSentimentFace(IconData icon, Color color, bool isSelected, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected 
            ? color.withOpacity(isDark ? 0.25 : 0.15) 
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)), 
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Icon(
        icon, 
        color: isSelected ? color : (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)), 
        size: 24,
      ),
    );
  }
}

// Visual 7: Lead Enrichment Bot (Profiles & connection lines spring-bouncing out)
class _AnimatedEnrichmentVisual extends StatefulWidget {
  final bool isDark;
  final int count;
  const _AnimatedEnrichmentVisual({required this.isDark, required this.count});

  @override
  State<_AnimatedEnrichmentVisual> createState() => _AnimatedEnrichmentVisualState();
}

class _AnimatedEnrichmentVisualState extends State<_AnimatedEnrichmentVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Radiating node points animation (LinkedIn, Web, Mail, Phone)
        // Nodes pop out using the custom spring curve
        final nodeProgress = (t < 0.7) ? (t / 0.5).clamp(0.0, 1.0) : 1.0 - ((t - 0.7) / 0.3);
        final springVal = _springCurve(nodeProgress);

        final List<Map<String, dynamic>> nodes = [
          {'icon': Icons.business_rounded, 'color': const Color(0xFF0077B5), 'x': -34.0 * springVal, 'y': -34.0 * springVal},
          {'icon': Icons.alternate_email_rounded, 'color': const Color(0xFFEA4335), 'x': 34.0 * springVal, 'y': -34.0 * springVal},
          {'icon': Icons.phone_android_rounded, 'color': const Color(0xFF34A853), 'x': -34.0 * springVal, 'y': 34.0 * springVal},
          {'icon': Icons.public_rounded, 'color': const Color(0xFFFF9900), 'x': 34.0 * springVal, 'y': 34.0 * springVal},
        ];

        // Central card pulse
        final centerScale = 0.95 + 0.08 * math.sin(t * math.pi * 2).abs();

        return Stack(
          alignment: Alignment.center,
          children: [
            // Connection links drawing
            if (nodeProgress > 0)
              CustomPaint(
                size: const Size(120, 120),
                painter: _ConnectionPainter(springVal: springVal, isDark: isDark),
              ),

            // Floating nodes
            ...nodes.map((n) {
              return Transform.translate(
                offset: Offset(n['x'], n['y']),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: n['color'].withOpacity(0.6), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: n['color'].withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(n['icon'], color: n['color'], size: 13),
                ),
              );
            }),

            // Central Prospect Avatar
            Transform.scale(
              scale: centerScale,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0077B5).withOpacity(0.2) : const Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0077B5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0077B5).withOpacity(0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(Icons.shield_rounded, color: Color(0xFF0077B5), size: 22),
              ),
            ),

            // Total Enriched indicator badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF059669) : const Color(0xFF86EFAC),
                  ),
                ),
                child: Text(
                  "+${widget.count} Signals",
                  style: TextStyle(
                    color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857), 
                    fontSize: 8.5, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 8: Revenue Forecaster (Bouncy charts & tracing sparkles)
class _AnimatedForecasterVisual extends StatefulWidget {
  final bool isDark;
  final String forecastText;
  const _AnimatedForecasterVisual({required this.isDark, required this.forecastText});

  @override
  State<_AnimatedForecasterVisual> createState() => _AnimatedForecasterVisualState();
}

class _AnimatedForecasterVisualState extends State<_AnimatedForecasterVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Path positions for graph tracer
        final start = Offset(12, 54);
        final mid1 = Offset(120 * 0.35, 38);
        final mid2 = Offset(120 * 0.65, 24);
        final end = Offset(120 - 12, 10);

        late Offset currentPoint;
        if (t < 0.33) {
          currentPoint = Offset.lerp(start, mid1, t / 0.33)!;
        } else if (t < 0.66) {
          currentPoint = Offset.lerp(mid1, mid2, (t - 0.33) / 0.33)!;
        } else {
          currentPoint = Offset.lerp(mid2, end, (t - 0.66) / 0.34)!;
        }

        // Bouncy scale for columns/bars in background
        final barHeightFactor = 0.8 + 0.25 * math.sin(t * math.pi * 2).abs();

        return Stack(
          children: [
            // Dotted grids and bouncy columns
            Positioned(
              left: 20,
              bottom: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(4, (idx) {
                  final baseH = 15.0 + (idx * 12);
                  return Container(
                    width: 14,
                    height: baseH * barHeightFactor,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFFF43F5E).withOpacity(0.08) : const Color(0xFFFFE4E6).withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Custom Painted graph path
            Center(
              child: SizedBox(
                width: 120,
                height: 60,
                child: CustomPaint(
                  painter: _ForecasterGraphPainter(progress: t, isDark: isDark),
                ),
              ),
            ),

            // Pulsing tracer dot
            Positioned(
              left: currentPoint.dx + 12, // Offset to align with center
              top: currentPoint.dy + 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFFFB7185) : const Color(0xFFE11D48),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE11D48).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Floating value label
            Positioned(
              top: 10,
              right: 12,
              child: Transform.scale(
                scale: 0.95 + 0.05 * math.sin(t * math.pi * 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF4C0519) : const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF9F1239) : const Color(0xFFFDA4AF),
                    ),
                  ),
                  child: Text(
                    widget.forecastText,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFFDA4AF) : const Color(0xFFBE123C), 
                      fontSize: 9.5, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 9: SLA Breach Predictor (Rotating shield and flashing corner target bracket nodes)
class _AnimatedSLAPredictorVisual extends StatefulWidget {
  final bool isDark;
  final String riskText;
  const _AnimatedSLAPredictorVisual({required this.isDark, required this.riskText});

  @override
  State<_AnimatedSLAPredictorVisual> createState() => _AnimatedSLAPredictorVisualState();
}

class _AnimatedSLAPredictorVisualState extends State<_AnimatedSLAPredictorVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Bouncy scales using custom spring
        final scanProgress = (t < 0.5) ? (t / 0.5) : 1.0 - ((t - 0.5) / 0.5);
        final springScale = 0.95 + 0.12 * _springCurve(scanProgress);

        final glowOpacity = (0.05 + 0.18 * math.sin(t * math.pi * 2).abs()).clamp(0.0, 1.0);
        final shieldRotation = 0.15 * math.sin(t * math.pi * 2);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glowing Wave
            Container(
              width: 86 * springScale,
              height: 86 * springScale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626)).withOpacity(glowOpacity),
              ),
            ),

            // Corner Target brackets
            CustomPaint(
              size: const Size(90, 90),
              painter: _TargetBracketPainter(progress: springScale, isDark: isDark),
            ),

            // Center Shield
            Transform.scale(
              scale: springScale,
              child: Transform.rotate(
                angle: shieldRotation,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626), 
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shield_outlined, 
                    color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFEF4444), 
                    size: 28,
                  ),
                ),
              ),
            ),

            // Risk status display banner
            Positioned(
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  widget.riskText,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563), 
                    fontSize: 8.5, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Visual 10: Competitor Benchmark (Comparison rows sliding & bouncy checks popping)
class _AnimatedBenchmarkingVisual extends StatefulWidget {
  final bool isDark;
  const _AnimatedBenchmarkingVisual({required this.isDark});

  @override
  State<_AnimatedBenchmarkingVisual> createState() => _AnimatedBenchmarkingVisualState();
}

class _AnimatedBenchmarkingVisualState extends State<_AnimatedBenchmarkingVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Custom staggered slide-in and pop values
        final row1Progress = (t < 0.6) ? (t / 0.45).clamp(0.0, 1.0) : 1.0 - ((t - 0.6) / 0.35).clamp(0.0, 1.0);
        final row2Progress = (t > 0.1 && t < 0.7) ? ((t - 0.1) / 0.45).clamp(0.0, 1.0) : (t >= 0.7 ? 1.0 - ((t - 0.7) / 0.25).clamp(0.0, 1.0) : 0.0);
        final row3Progress = (t > 0.2 && t < 0.8) ? ((t - 0.2) / 0.45).clamp(0.0, 1.0) : (t >= 0.8 ? 1.0 - ((t - 0.8) / 0.2).clamp(0.0, 1.0) : 0.0);

        final row1X = -30 * (1.0 - _springCurve(row1Progress));
        final row2X = -30 * (1.0 - _springCurve(row2Progress));
        final row3X = -30 * (1.0 - _springCurve(row3Progress));

        return Stack(
          children: [
            Center(
              child: Container(
                width: 130,
                height: 88,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A).withOpacity(0.9) : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(row1X, 0),
                      child: Opacity(
                        opacity: row1Progress,
                        child: _buildBenchmarkRow("Sociafy CRM", true, isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Transform.translate(
                      offset: Offset(row2X, 0),
                      child: Opacity(
                        opacity: row2Progress,
                        child: _buildBenchmarkRow("Competitor A", false, isDark),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Transform.translate(
                      offset: Offset(row3X, 0),
                      child: Opacity(
                        opacity: row3Progress,
                        child: _buildBenchmarkRow("Competitor B", false, isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenchmarkRow(String name, bool isWon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isWon 
            ? (isDark ? const Color(0xFF064E3B).withOpacity(0.3) : const Color(0xFFECFDF5))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name, 
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A), 
              fontSize: 8.5, 
              fontWeight: isWon ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Icon(
            isWon ? Icons.check_circle_rounded : Icons.cancel_rounded, 
            size: 11, 
            color: isWon 
                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF059669)) 
                : (isDark ? const Color(0xFFF87171) : const Color(0xFFE11D48)),
          ),
        ],
      ),
    );
  }
}


// =========================================================================
// ==================== PAINTERS FOR CUSTOM DRAWINGS =======================
// =========================================================================

// Custom path drawing for Autopilot Router path
class _RouterPathPainter extends CustomPainter {
  final bool isDark;
  _RouterPathPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0xFFFBBF24).withOpacity(0.4) : const Color(0xFFF59E0B).withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(24, 24)
      ..cubicTo(size.width * 0.35, size.height * 0.9, size.width * 0.65, size.height * 0.15, size.width - 24, size.height - 24);

    // Draw dashed bezier path
    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double distance = 0.0;
      const dashLength = 4.0;
      const gapLength = 4.0;
      while (distance < metric.length) {
        final pathSegment = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(pathSegment, paint);
        distance += dashLength + gapLength;
      }
    }

    // Midpoints
    final nodePaint = Paint()
      ..color = isDark ? const Color(0xFFF59E0B) : const Color(0xFFFBBF24)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 3, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Connection line drawing for Lead Enrichment radial nodes
class _ConnectionPainter extends CustomPainter {
  final double springVal;
  final bool isDark;
  _ConnectionPainter({required this.springVal, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0xFF0077B5).withOpacity(0.3 * springVal) : const Color(0xFF0077B5).withOpacity(0.15 * springVal)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final offsets = [
      Offset(center.dx - 34.0 * springVal, center.dy - 34.0 * springVal),
      Offset(center.dx + 34.0 * springVal, center.dy - 34.0 * springVal),
      Offset(center.dx - 34.0 * springVal, center.dy + 34.0 * springVal),
      Offset(center.dx + 34.0 * springVal, center.dy + 34.0 * springVal),
    ];

    for (var offset in offsets) {
      canvas.drawLine(center, offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) {
    return oldDelegate.springVal != springVal || oldDelegate.isDark != isDark;
  }
}

// Custom path drawing for Revenue Forecaster chart line
class _ForecasterGraphPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _ForecasterGraphPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Glow/shadow path
    final glowPaint = Paint()
      ..color = (isDark ? const Color(0xFFF43F5E) : const Color(0xFFE11D48)).withOpacity(0.1)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final paint = Paint()
      ..color = isDark ? const Color(0xFFF43F5E) : const Color(0xFFE11D48)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(12, size.height - 6)
      ..lineTo(size.width * 0.35, size.height * 0.6)
      ..lineTo(size.width * 0.65, size.height * 0.4)
      ..lineTo(size.width - 12, 10);

    // Compute partial path to animate path drawing
    final partialPath = Path();
    for (var metric in path.computeMetrics()) {
      partialPath.addPath(
        metric.extractPath(0.0, metric.length * progress),
        Offset.zero,
      );
    }

    canvas.drawPath(partialPath, glowPaint);
    canvas.drawPath(partialPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ForecasterGraphPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

// SLA Breach Predictor target scanner bracket frames
class _TargetBracketPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _TargetBracketPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626)).withOpacity(0.6 * progress)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    const len = 12.0;

    // Draw 4 corner L-bracket marks
    // Top-Left
    canvas.drawPath(Path()..moveTo(0, len)..lineTo(0, 0)..lineTo(len, 0), paint);
    // Top-Right
    canvas.drawPath(Path()..moveTo(w - len, 0)..lineTo(w, 0)..lineTo(w, len), paint);
    // Bottom-Left
    canvas.drawPath(Path()..moveTo(0, h - len)..lineTo(0, h)..lineTo(len, h), paint);
    // Bottom-Right
    canvas.drawPath(Path()..moveTo(w - len, h)..lineTo(w, h)..lineTo(w, h - len), paint);
  }

  @override
  bool shouldRepaint(covariant _TargetBracketPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
