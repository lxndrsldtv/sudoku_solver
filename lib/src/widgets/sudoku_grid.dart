import 'dart:math';

import 'package:flutter/material.dart';

interface class SudokuGridWidgetSettings {
  final int gridSize = 9;
  final double gridPadding = 1.0;
  final double padding = 8.0;
  final double cellPadding = 2.0;
  final Color backgroundColor = const Color(0xFF616161);
}

typedef SubgridBuilder = Widget Function(BuildContext context, int index);

class SudokuGridWidget extends StatelessWidget {
  const SudokuGridWidget({
    super.key,
    required this.padding,
    required this.gridSize,
    required this.gridPadding,
    required this.cellPadding,
    required this.backgroundColor,
    required this.subgridBuilder,
  });

  final int gridSize;
  final double gridPadding;
  final double cellPadding;
  final double padding;
  final Color backgroundColor;
  final SubgridBuilder subgridBuilder;

  @override
  Widget build(BuildContext context) {
    final minSide = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Container(
      color: backgroundColor,
      height: minSide - padding,
      width: minSide - padding,
      child: GridView.builder(
        padding: EdgeInsets.all(gridPadding),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: sqrt(gridSize).toInt(),
          mainAxisSpacing: cellPadding,
          crossAxisSpacing: cellPadding,
        ),
        itemBuilder: _itemBuilder,
        itemCount: gridSize,
      ),
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    if (index > gridSize - 1) return null;
    return subgridBuilder(context, index);
  }
}
