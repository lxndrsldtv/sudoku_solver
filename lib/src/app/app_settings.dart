import 'package:flutter/material.dart';
import 'package:sudoku_solver/src/widgets/sudoku_grid.dart';
import 'package:sudoku_solver/src/widgets/sudoku_subgrid.dart';

class AppSettings implements SudokuGridWidgetSettings, SudokuSubgridWidgetSettings {
  // SudokuGridSettings
  @override
  final int gridSize = 9;

  @override
  final double padding = 8.0;

  @override
  final double gridPadding = 4.0;

  @override
  final double cellPadding = 2.0;

  @override
  final Color backgroundColor = Color(0xFF616161);

  @override
  final int subgridSize = 9;

  @override
  final double subgridPadding = 0.0;

  @override
  final double subgridCellPadding = 1.0;

  @override
  final Color subgridBackgroundColor = const Color(0xFF9E9E9E);
  // ===========================================================================
}
