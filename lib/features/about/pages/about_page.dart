import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About GDG Gurugram University',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1F),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Google Developer Groups (GDG) are community groups for developers interested in Google technologies. GDG Gurugram University is a local chapter that brings together developers, designers, and tech enthusiasts.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF44474F),
              height: 1.6,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4285F4),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'To create a platform where students can learn, share, and grow together in the field of technology.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF44474F),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
} 