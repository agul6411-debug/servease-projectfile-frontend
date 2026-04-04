import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/user_footer_widgets.dart';

/// FooterSection - Footer with company info and links
class FooterSection extends StatelessWidget {
  const FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark,
      padding: const EdgeInsets.fromLTRB(40, 56, 40, 32),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Serv',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'Ease',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Smart On-Demand Home Services Platform. Connecting '
                      'customers with verified professionals — faster, safer, simpler.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white38,
                        height: 1.7,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              const FooterColumn(
                title: 'Services',
                links: [
                  'Plumbing',
                  'Electrician',
                  'Cleaning',
                  'Tutoring',
                ],
              ),
              const SizedBox(width: 32),
              const FooterColumn(
                title: 'More',
                links: [
                  'Beautician',
                  'Carpentry',
                  'Painting',
                  'And More →',
                ],
              ),
              const SizedBox(width: 32),
              const FooterColumn(
                title: 'Platform',
                links: [
                  'How It Works',
                  'For Providers',
                  'For Customers',
                  'Admin Portal',
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: Text(
                  '© 2026 ServEase. FYDP — Dept. of IT, Postgraduate College for Women, Kamoke.',
                  style: TextStyle(fontSize: 11, color: Colors.white24),
                ),
              ),
              Text(
                'Your Service Solution.',
                style: TextStyle(fontSize: 11, color: Colors.white24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
