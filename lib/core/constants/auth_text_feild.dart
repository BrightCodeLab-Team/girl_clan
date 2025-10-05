import 'package:flutter/material.dart';

import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';

final InputDecoration customAuthField3 = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 7),
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
  fillColor: whiteColor,
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

///
///    home screen search etc
///
final InputDecoration customHomeAuthField = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  filled: true,
  fillColor: thinGreyColor,
  hintText: 'Search',
  hintStyle: style14B.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: ternaryColor,
  ),
);
//******* */
//****************************************************************************************************************************************** */
///
///     edit profile text form field decoration
///
///

///
// ignore: non_constant_identifier_names
final InputDecoration EditProfileFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: greyBorderColor.withOpacity(0.1), width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: greyBorderColor, width: 1.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: borderColor.withOpacity(0.4)),
  ),
  filled: true,
  fillColor: whiteColor,
  hintText: 'DD/MM/YY',
  hintStyle: style14B.copyWith(fontWeight: FontWeight.w400),
  suffixIcon: Padding(padding: EdgeInsets.only(right: 15)),
  isDense: true,
);
