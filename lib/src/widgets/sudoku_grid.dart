import 'dart:math';

import 'package:flutter/material.dart';

interface class SudokuGridSettings {
  final int gridSize = 9;
  final double gridPadding = 1.0;
  final double padding = 8.0;
  final double cellPadding = 2.0;
  final Color backgroundColor = const Color(0xFF616161);

  final int subgridSize = 9;
  final double subgridPadding = 0.0;
  final double subgridCellPadding = 1.0;
  final Color subgridBackgroundColor = Color(0xFF9E9E9E);
}

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({
    super.key,
    required this.padding,
    required this.gridSize,
    required this.gridPadding,
    required this.cellPadding,
    required this.backgroundColor,
    required this.cell,
  });

  final int gridSize;
  final double gridPadding;
  final double cellPadding;
  final double padding;
  final Color backgroundColor;
  final Widget? cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: MediaQuery.of(context).size.width - padding,
      width: MediaQuery.of(context).size.width - padding,
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
    if (cell == null || index > gridSize - 1) return null;
    return cell;
  }
}
