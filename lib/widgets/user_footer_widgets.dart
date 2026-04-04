import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// UserCard - Card showing a user type (Customer/Provider/Admin)
class UserCard extends StatefulWidget {
  final String emoji, role, title, description;
  final List<String> features;
  final bool highlight;

  const UserCard({
    super.key,
    required this.emoji,
    required this.role,
    required this.title,
    required this.description,
    required this.features,
    this.highlight = false,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.highlight
                ? AppColors.orange.withOpacity(0.3)
                : AppColors.teal.withOpacity(0.1),
            width: widget.highlight ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.teal.withOpacity(0.12),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: widget.highlight
                    ? AppColors.orange.withOpacity(0.1)
                    : AppColors.teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.role.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.muted,
                height: 1.7,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            ...widget.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    const Text(
                      '✓',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// FooterColumn - Column section in the footer
class FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const FooterColumn({super.key, required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(
              link,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white38,
                fontWeight: FontWeight.w300,
              ),
            ),
          );
        }),
      ],
    );
  }
}
