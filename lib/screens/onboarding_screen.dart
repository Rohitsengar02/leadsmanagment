import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_management/core/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Real-Time Kiosk Updates',
      description:
          'Receive real-time notifications about kiosk fill levels & specific waste types. Plan your routes accordingly and maximize efficiency.',
      image: 'assets/onboarding_kiosk.png',
    ),
    OnboardingData(
      title: 'Connect with Partners',
      description:
          'Our app facilitates connections between waste collectors, recyclers, upcyclers, and businesses. Collaborate & share resources.',
      image: 'assets/onboarding_partners.png',
    ),
    OnboardingData(
      title: 'Streamline Your Operations',
      description:
          'Our app simplifies your waste collection and disposal tasks. Easily track routes, optimize pickups, and manage your inventory.',
      image: 'assets/onboarding_operations.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          return Stack(
            children: [
              // Decorative background elements
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -150,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.02),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], isDesktop);
                },
              ),

              // Bottom controls
              Positioned(
                bottom: isDesktop ? 60 : 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: _currentPage == index ? 24 : 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppColors.success
                                    : AppColors.textSecondary.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOutCubic,
                                );
                              } else {
                                context.go('/');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Next Step',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Skip Button
              Positioned(
                top: 60,
                right: 24,
                child: TextButton(
                  onPressed: () => context.go('/'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPage(OnboardingData data, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: _buildImage(data.image, isDesktop),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: _buildContent(data),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildImage(data.image, isDesktop),
                const Spacer(flex: 1),
                _buildContent(data),
                const Spacer(flex: 3),
              ],
            ),
    );
  }

  Widget _buildImage(String imagePath, bool isDesktop) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isDesktop ? 500 : 320,
        maxWidth: isDesktop ? 600 : double.infinity,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: isDesktop ? 400 : 260,
            height: isDesktop ? 400 : 260,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
          // Illustration
          Hero(
            tag: imagePath,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(OnboardingData data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}
