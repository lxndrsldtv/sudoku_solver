import 'dart:math';

import 'package:flutter/material.dart';

interface class SudokuSubgridWidgetSettings {
  final int subgridSize = 9;
  final double subgridPadding = 0.0;
  final double subgridCellPadding = 1.0;
  final Color subgridBackgroundColor = Color(0xFF9E9E9E);
}

typedef CellBuilder = Widget Function(BuildContext context, int subgridIndex, int subgridCellindex);

class SudokuSubgridWidget extends StatelessWidget {
  const SudokuSubgridWidget({
    super.key,
    required this.padding,
    required this.gridSize,
    required this.gridPadding,
    required this.cellPadding,
    required this.backgroundColor,
    required this.cellBuilder,
    required this.index,
  });

  final int gridSize;
  final double padding;
  final double gridPadding;
  final double cellPadding;
  final Color backgroundColor;
  final CellBuilder cellBuilder;
  final int index;

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

  Widget? _itemBuilder(BuildContext context, int i) {
    if (index > gridSize - 1) return null;
    return cellBuilder(context, index, i);
  }
}
