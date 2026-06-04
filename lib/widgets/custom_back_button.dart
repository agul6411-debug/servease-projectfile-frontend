import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.color, this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color ?? Colors.black),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: 'Back',
    );
  }
}
