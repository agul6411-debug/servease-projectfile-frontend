import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/user_footer_widgets.dart';

/// UserTypesSection - Section showing different user types
class UserTypesSection extends StatelessWidget {
  const UserTypesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          const SectionTag(label: "Who It's For"),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 44,
                height: 1.1,
                color: AppColors.dark,
              ),
              children: [
                TextSpan(text: 'A Platform Built\nfor '),
                TextSpan(
                  text: 'Everyone',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: UserCard(
                  emoji: '👤',
                  role: 'Customer',
                  title: 'The Homeowner',
                  description: 'Book any service, anytime. Your home is your sanctuary — we help you keep it that way.',
                  features: [
                    'Search & book instantly',
                    'Track bookings in real-time',
                    'Chat with your provider',
                    'Rate & review after service',
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: UserCard(
                  emoji: '🔨',
                  role: 'Service Provider',
                  title: 'The Professional',
                  description: 'Grow your client base, manage your schedule, and build your reputation.',
                  features: [
                    'Create a verified profile',
                    'Accept or decline requests',
                    'Manage schedule & bookings',
                    'Build ratings & grow income',
                  ],
                  highlight: true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: UserCard(
                  emoji: '⚙️',
                  role: 'Administrator',
                  title: 'The Overseer',
                  description: 'Full platform control — verify providers, manage disputes, keep things running.',
                  features: [
                    'Verify & approve providers',
                    'Monitor platform activity',
                    'Handle complaints & disputes',
                    'Manage service categories',
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
