import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/src/app/app_settings.dart';
import 'package:sudoku_solver/src/widgets/sudoku_cell.dart';
import 'package:sudoku_solver/src/widgets/sudoku_grid.dart';
import 'package:sudoku_solver/src/widgets/sudoku_subgrid.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<AppSettings>();

    return Scaffold(
      body: Center(
        child: SudokuGridWidget(
          padding: settings.padding,
          gridSize: settings.gridSize,
          gridPadding: settings.gridPadding,
          cellPadding: settings.cellPadding,
          backgroundColor: settings.backgroundColor,
          subgridBuilder: (_, index) => SudokuSubgridWidget(
            padding: settings.padding,
            gridSize: settings.subgridSize,
            gridPadding: settings.subgridPadding,
            cellPadding: settings.subgridCellPadding,
            backgroundColor: settings.subgridBackgroundColor,
            index: index,
            cellBuilder: (_, subgridIndex, subgridCellIndex) => SudokuCellWidget(
              subgridIndex: subgridIndex,
              subgridCellIndex: subgridCellIndex,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.grid_on_sharp),
        onPressed: () {},
      ),
    );
  }
}
