import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum EditMode {
  home,
  tools,
  squareEdit,
  circleEdit,
  textEdit,
  lineEdit,
  imageEdit,
}

enum ShapeType { square, circle, line, text, image, pen }

class ShapeModel {
  ShapeType type;
  Color color;
  double cornerRadius;
  double borderWeight;
  Color borderColor;
  double x;
  double y;
  double width;
  double height;

  // Text properties
  String textContent;
  double fontSize;
  FontWeight fontWeight;
  FontStyle fontStyle;
  TextAlign textAlign;

  // Image properties
  ui.Image? image;

  // Line properties
  Offset startPoint;
  Offset endPoint;
  double strokeWidth;
  Color strokeColor;

  ShapeModel({
    required this.type,
    this.color = Colors.red,
    this.cornerRadius = 0.0,
    this.borderWeight = 0.0,
    this.borderColor = Colors.black,
    this.x = 0.0,
    this.y = 0.0,
    this.width = 100.0,
    this.height = 100.0,
    this.textContent = 'New Text',
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textAlign = TextAlign.center,
    this.image,
    this.startPoint = Offset.zero,
    this.endPoint = const Offset(100.0, 0.0),
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.black,
  });

  ShapeModel copyWith({
    ShapeType? type,
    Color? color,
    double? cornerRadius,
    double? borderWeight,
    Color? borderColor,
    double? x,
    double? y,
    double? width,
    double? height,
    String? textContent,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextAlign? textAlign,
    ui.Image? image,
    Offset? startPoint,
    Offset? endPoint,
    double? strokeWidth,
    Color? strokeColor,
  }) {
    return ShapeModel(
      type: type ?? this.type,
      color: color ?? this.color,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      borderWeight: borderWeight ?? this.borderWeight,
      borderColor: borderColor ?? this.borderColor,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      textContent: textContent ?? this.textContent,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      textAlign: textAlign ?? this.textAlign,
      image: image ?? this.image,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
    );
  }
}
