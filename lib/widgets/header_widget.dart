import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style =
    NeumorphicStyle(border: NeumorphicBorder(width: 1.0),
        depth: 2.0,
        color: Colors.white,
        intensity: 1.0);
    final textStyle =
    NeumorphicTextStyle(fontSize: 40, fontWeight: FontWeight.bold);
    final screenOrientation = MediaQuery
        .of(context)
        .orientation;

    return screenOrientation == Orientation.portrait
        ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicText('S', style: style, textStyle: textStyle),
          NeumorphicText('U', style: style, textStyle: textStyle),
          NeumorphicText('D', style: style, textStyle: textStyle),
          NeumorphicText('O', style: style, textStyle: textStyle),
          NeumorphicText('K', style: style, textStyle: textStyle),
          NeumorphicText('U', style: style, textStyle: textStyle),
        ])
        : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicText('S', style: style, textStyle: textStyle),
          NeumorphicText('U', style: style, textStyle: textStyle),
          NeumorphicText('D', style: style, textStyle: textStyle),
          NeumorphicText('O', style: style, textStyle: textStyle),
          NeumorphicText('K', style: style, textStyle: textStyle),
          NeumorphicText('U', style: style, textStyle: textStyle),
        ]);
  }
}
