// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/widgets/header_widget.dart';

import '../widgets/control_button_bar.dart';
import '../widgets/sudoku_widget.dart';

class SudokuHomePage extends StatelessWidget {
  final logger = Logger('SudokuHomePage');

  SudokuHomePage({super.key});

  List<Widget> pageWidgets() {
    return [
      const Spacer(),
      const HeaderWidget(),
      const Spacer(),
      SudokuWidget(),
      const Spacer(),
      const ControlButtonBar()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SafeArea(
          child: screenOrientation == Orientation.portrait
              ? Column(children: [...pageWidgets(), const SizedBox(height: 8.0)])
              : Row(children: [...pageWidgets(), const SizedBox(width: 8.0)])),
    );
  }
}
