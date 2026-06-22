// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          _page(context, 'Welcome to Drawify', 'Create digital art easily'),
          _page(context, 'AI Enhancer', 'Enhance sketches automatically'),
          _page(context, 'Save & Share', 'Save to gallery or Cloudinary', last: true),
        ],
      ),
    );
  }

  Widget _page(BuildContext c, String title, String subtitle, {bool last=false}) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Theme.of(c).scaffoldBackgroundColor,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/artist.png', height: 220),
        const SizedBox(height:20),
        Text(title, style: Theme.of(c).textTheme.headlineSmall),
        const SizedBox(height:8),
        Text(subtitle, textAlign: TextAlign.center, style: Theme.of(c).textTheme.bodyMedium),
        const SizedBox(height: 30),
        if (last)
          ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(c, '/login'), child: const Text('Get started'))
      ]),
    );
  }
}
