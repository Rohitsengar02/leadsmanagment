import 'package:flutter/material.dart';
import 'package:leads_management/core/theme.dart';
import 'package:leads_management/widgets/glass_card.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF7C3AED),
                      Color(0xFF06B6D4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      left: -100,
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.pentagon,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Nexus CRM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBOIV7HuCUcvz2-7tyacCAl5aRuqf12Du97ELEInE5RBDF7ZcweF1IG4uuN1I1rz44svCv4VdSAhwh8IhQPQ02R8ASMW1FpJEjzjAsy5N6tY8AsGfxgRpG7ML3Z6RCQvPrTUFB42YMdSEX7PqDAqJZN9oRY3r4xas7Wm91MeVVJIbZjHTErl6JZfhAcsWcbi0oJrCqvW2xoz32S8kKSZWAOWZwFGrlicsdHeORowjyXl4vJAHIg7_s4QX9gghnabhklHAPMWvQx7Ow',
                              width: 500,
                              height: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Elevate your customer\nrelationships.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Join 10,000+ companies growing faster with our\npremium, data-driven CRM platform.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          const Row(
                            children: [
                              Text(
                                '© 2024 Nexus Inc.',
                                style: TextStyle(color: Colors.white54),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Privacy Policy',
                                style: TextStyle(color: Colors.white54),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Terms of Service',
                                style: TextStyle(color: Colors.white54),
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
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: GlassCard(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter your details to access your dashboard.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Email address',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: 'name@company.com',
                              suffixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.white30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              suffixIcon: Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.white30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text(
                                    'Remember for 30 days',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () => context.go('/dashboard'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white12)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white30,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white12)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                                    width: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up for free',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 24),
                          const Center(
                            child: Text(
                              'TRUSTED BY INDUSTRY LEADERS',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white30,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildBrand('Acme Corp', Icons.diamond),
                              _buildBrand('Global', Icons.blur_on),
                              _buildBrand('Hexa', Icons.polymer),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand(String name, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white30),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
