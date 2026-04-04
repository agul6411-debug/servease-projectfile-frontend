import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/card_widgets.dart';
import '../widgets/common_widgets.dart';

/// HowItWorksSection - Section explaining the process
class HowItWorksSection extends StatelessWidget {
  static const _stepsList = [
    StepData(
      '01',
      'Register & Log In',
      'Create your account in minutes. OTP verification keeps your profile safe.',
    ),
    StepData(
      '02',
      'Search & Browse',
      'Filter by category & location. View profiles, ratings & live availability.',
    ),
    StepData(
      '03',
      'Book & Chat',
      'Confirm instantly. Message your provider through secure in-app chat.',
    ),
    StepData(
      '04',
      'Review & Repeat',
      'Rate your experience, build trusted relationships, keep your home perfect.',
    ),
  ];

  const HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTag(label: 'The Process'),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 44,
                height: 1.1,
                color: AppColors.dark,
              ),
              children: [
                TextSpan(text: 'From Request to\n'),
                TextSpan(
                  text: 'Resolution',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.teal,
                  ),
                ),
                TextSpan(text: ' — Effortlessly'),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _stepsList
                .map((step) => Expanded(child: StepCard(step: step)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
