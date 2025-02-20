import 'package:flutter/material.dart';


class MyGradientText extends StatelessWidget {
  const MyGradientText({
    super.key,
    this.fontFamily,
    required this.fontSize,
    required this.text,
    required this.colors
  });


  final String? fontFamily;
  final double fontSize;
  final String text;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
        tileMode: TileMode.clamp,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: fontFamily?? 'Poppins',
            fontSize: fontSize,
            color: Colors.white
        ),
      ),
    );
  }
}
