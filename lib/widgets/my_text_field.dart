

import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/widgets/my_gradient_text.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  String? Function(String?)? validator;
  final double? borderRadius;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final String text;
  final bool? isObscure;
  final IconButton? suffixIcon;


  MyTextField({
    super.key,
    this.controller,
    this.borderRadius,
    this.colors,
    this.begin,
    this.end,
    required this.text,
    this.validator,
    this.isObscure,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyGradientText(
          fontSize: 14,
          text: text,
          colors: colors?? const [
            AppColors.appBlue,
            AppColors.appBlue,
            AppColors.appLightBlue,
          ],
        ),
        const SizedBox(height: 8,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius?? 8),
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
            gradient: LinearGradient(
              colors: colors?? const [
                AppColors.appBlue,
                AppColors.appBlue,
                AppColors.appLightBlue,
              ],
              begin: begin?? Alignment.topCenter,
              end: end?? Alignment.bottomCenter,
            ),
          ),
          child: TextFormField(
            obscureText: isObscure??false,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixIcon ?? null,
              suffixIconColor: Colors.black87,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius?? 8),
                  borderSide: BorderSide.none
              ),
            ),
            validator: validator ?? (val){ return;},
          ),
        ),
      ],
    );
  }
}



