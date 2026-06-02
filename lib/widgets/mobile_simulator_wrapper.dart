import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/core/theme.dart';

class MobileSimulatorWrapper extends StatelessWidget {
  final Widget child;

  const MobileSimulatorWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    if (isMobile) {
      // On mobile viewports, render the screen directly full screen
      return child;
    }

    // On desktop viewports, wrap in a beautiful floating mobile smartphone mockup
    return Scaffold(
      backgroundColor: const Color(0xFF070709),
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -200,
            left: size.width * 0.1,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            right: size.width * 0.1,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFCCFF00).withValues(alpha: 0.04),
              ),
            ),
          ),

          // Central content simulator
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Translucent informational banner at the top
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phonelink_setup_rounded, color: Color(0xFFCCFF00), size: 18),
                      const SizedBox(width: 10),
                      const Text(
                        'MOBILE SCREEN SIMULATOR MODE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: () => context.go('/dashboard'),
                        icon: const Icon(Icons.arrow_back, size: 14, color: Color(0xFFCCFF00)),
                        label: const Text(
                          'Back to Desktop Dashboard',
                          style: TextStyle(
                            color: Color(0xFFCCFF00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sleek Smartphone Frame Mockup
                Container(
                  width: 390,
                  height: 800,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0B09),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF222226),
                      width: 12,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: Stack(
                      children: [
                        // The actual mobile widget view
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: Theme(
                            data: AppTheme.darkTheme,
                            child: child,
                          ),
                        ),

                        // Simulated status bar
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            color: const Color(0xFF0A0B09),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '9:41',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.signal_cellular_alt_rounded, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Icon(Icons.wifi, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Icon(Icons.battery_5_bar_rounded, color: Colors.white, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dynamic island Notch
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 105,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0F0E13),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Simulated iOS home indicator bar at the bottom
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
