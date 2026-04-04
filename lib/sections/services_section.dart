import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/card_widgets.dart';
import '../widgets/common_widgets.dart';

/// ServicesSection - Section displaying all available services
class ServicesSection extends StatelessWidget {
  static const _servicesList = [
    ServiceData(
      '🔧',
      'Plumbing',
      'Leaks, repairs & drainage by licensed plumbers — on your schedule.',
    ),
    ServiceData(
      '⚡',
      'Electrician',
      'Wiring, fuse boxes & appliance fitting by certified electricians.',
    ),
    ServiceData(
      '🧹',
      'Cleaning',
      'Deep cleans, housekeeping & post-construction — spotless results.',
    ),
    ServiceData(
      '📚',
      'Tutoring',
      'Home tutors for all subjects — qualified & results-driven.',
    ),
    ServiceData(
      '💅',
      'Beautician',
      'Hair, skincare & makeup by beauty professionals at your door.',
    ),
    ServiceData(
      '🪵',
      'Carpentry',
      'Custom furniture, installations & woodwork with precision.',
    ),
    ServiceData(
      '🎨',
      'Painting',
      'Interior & exterior painting — flawless wall finishes every time.',
    ),
    ServiceData(
      '➕',
      'And More',
      'New categories continuously added. If you need it home, we find the expert.',
    ),
  ];

  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isWide),
          const SizedBox(height: 56),
          _buildServicesGrid(isWide),
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
                  children: const [
                    SectionTag(label: 'What We Offer'),
                    SizedBox(height: 16),
                    Text(
                      'Every Service\nYour Home Needs',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 44,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              const Expanded(
                child: Text(
                  'Browse verified professionals across eight specialized service '
                  'categories — all in one trusted platform.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.75,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SectionTag(label: 'What We Offer'),
              SizedBox(height: 16),
              Text(
                'Every Service Your Home Needs',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
            ],
          );
  }

  /// Build services grid
  Widget _buildServicesGrid(bool isWide) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _servicesList.length,
      itemBuilder: (_, index) => ServiceCard(service: _servicesList[index]),
    );
  }
}
