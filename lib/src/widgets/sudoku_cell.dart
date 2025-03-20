import 'dart:math';

import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  const SudokuCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      alignment: Alignment.center,
      child: Text(Random().nextInt(9).toString()),
    );
  }
}
