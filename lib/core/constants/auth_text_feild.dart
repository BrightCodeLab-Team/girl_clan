import 'package:flutter/material.dart';

import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

final InputDecoration customAuthField3 = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: ternaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: ternaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: ternaryColor),
  ),
  filled: true,
  fillColor: Colors.white,
  hintStyle: style14B.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: ternaryColor,
  ),
  prefixStyle: style20B.copyWith(
    fontWeight: FontWeight.w400,
    color: Colors.grey.shade400,
  ),
  isDense: true,
);
