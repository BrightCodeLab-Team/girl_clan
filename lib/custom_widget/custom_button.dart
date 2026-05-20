// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/text_style.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? text; // 👈 text optional kar diya
  final Widget? child; // 👈 new optional widget child
  final Color backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.onTap,
    this.text, // 👈 required nahi hai ab
    this.child, // 👈 user koi bhi widget de sakta hai (Icon, Row, etc.)
    required this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: 45.h,
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor ?? Colors.transparent),
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(99),
            boxShadow:
                _isPressed
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
          ),
          child: Center(
            child:
                widget.child ??
                (widget.text != null
                    ? Text(
                      widget.text!,
                      style: style20.copyWith(
                        fontSize: 14,
                        color: widget.textColor ?? Colors.white,
                      ),
                    )
                    : const SizedBox.shrink()), // 👈 Agar dono null hain to empty
          ),
        ),
      ),
    );
  }
}
