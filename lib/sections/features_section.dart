import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/card_widgets.dart';
import '../widgets/common_widgets.dart';

/// FeaturesSection - Section showcasing platform features
class FeaturesSection extends StatelessWidget {
  static const _featuresList = [
    FeatureData(
      '🔐',
      'Secure Authentication',
      'JWT sessions, OTP verification & SSL encryption — your data stays safe.',
    ),
    FeatureData(
      '📍',
      'GPS Location Services',
      'Find professionals near you in real time. Book the closest available expert.',
    ),
    FeatureData(
      '💬',
      'In-App Messaging',
      'Talk to providers directly — no personal numbers ever shared.',
    ),
    FeatureData(
      '⭐',
      'Ratings & Reviews',
      'A transparent review ecosystem that holds every provider accountable.',
    ),
    FeatureData(
      '🔔',
      'Smart Notifications',
      'Real-time push updates from booking confirmation to job completion.',
    ),
    FeatureData(
      '🛡️',
      'Provider Verification',
      'Every provider passes admin review before appearing on the platform.',
    ),
  ];

  const FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isWide),
          const SizedBox(height: 56),
          _buildFeaturesGrid(isWide),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildHeader(bool isWide) {
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTag(label: 'Platform Capabilities', dark: true),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 44,
                          height: 1.1,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: 'Built for Trust,\nDesigned for '),
                          TextSpan(
                            text: 'Speed',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFF5A055),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              const Expanded(
                child: Text(
                  'Every feature engineered to make booking professional home '
                  'services feel natural, fast & completely secure.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.75,
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SectionTag(label: 'Platform Capabilities', dark: true),
              SizedBox(height: 16),
              Text(
                'Built for Trust, Designed for Speed',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ],
          );
  }

  /// Build features grid
  Widget _buildFeaturesGrid(bool isWide) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 3 : 1,
        childAspectRatio: isWide ? 1.85 : 3.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _featuresList.length,
      itemBuilder: (_, index) => FeatureCard(feature: _featuresList[index]),
    );
  }
}
