// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

class CustomDropDownTextField extends StatelessWidget {
  CustomDropDownTextField({
    required this.hasDroppedDown,
    required this.onTap,
    required this.text,
    this.borderColor,
  });
  final bool hasDroppedDown;
  final Color? borderColor;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: whiteColor,
          border: Border.all(
            color:
                text == ''
                    ? hasDroppedDown
                        ? filledColor
                        : borderColor ?? filledColor
                    : filledColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text == '' ? 'Select Category' : text,
              style: style14.copyWith(
                color:
                    text == ''
                        ? hasDroppedDown
                            ? blackColor
                            : borderColor
                        : blackColor,
              ),
            ),
            Icon(
              hasDroppedDown
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: filledColor,
            ),
          ],
        ),
      ),
    );
  }
}
