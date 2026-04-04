import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// NavBtn - Navigation button in the app bar
class NavBtn extends StatefulWidget {
  final String label;
  const NavBtn(this.label);

  @override
  State<NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<NavBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: () {},
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            color: _isHovered ? AppColors.teal : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

/// SectionTag - Small tag that appears before section titles
class SectionTag extends StatelessWidget {
  final String label;
  final bool dark;
  const SectionTag({required this.label, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final color = dark ? const Color(0xFFF5A055) : AppColors.orange;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 1.5, color: color),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// StatCard - Shows statistics (number + label)
class StatCard extends StatelessWidget {
  final String number, label;
  const StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18),
      margin: const EdgeInsets.only(right: 36),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0x221A6B5A), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.teal,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.muted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
