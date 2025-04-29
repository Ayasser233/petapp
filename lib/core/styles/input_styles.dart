import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';

InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    )
  );
}

OutlineInputBorder focusedFieldStyle() {
  return const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.orange, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  );
}