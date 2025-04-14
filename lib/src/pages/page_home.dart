import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/src/app/app_settings.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';
import 'package:sudoku_solver/src/pages/sudoku_data.dart';
import 'package:sudoku_solver/src/services/solver_service.dart';
import 'package:sudoku_solver/src/widgets/sudoku_grid.dart';
import 'package:sudoku_solver/src/widgets/sudoku_subgrid.dart';

class PageHome extends StatelessWidget {
  final SolverService solver;
  final ReactiveSudokuModel sudoku;

  const PageHome({super.key, required this.sudoku, required this.solver});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<AppSettings>();

    return Scaffold(
      body: Center(
        child: SafeArea(
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
              // cellBuilder: (_, subgridIndex, subgridCellIndex) => SudokuCellWidget(
              //   subgridIndex: subgridIndex,
              //   subgridCellIndex: subgridCellIndex,
              // ),
              cellBuilder: Injector().get<CellBuilder>(),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          Spacer(),
          FloatingActionButton(
            child: const Icon(Icons.grid_on_sharp),
            onPressed: () => sudoku.loadData(cellDTOs),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.skip_previous),
              onPressed: () => solver.undoMove(sudoku),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () => solver.solve(sudoku),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.skip_next),
              onPressed: () => solver.doMove(sudoku),
            ),
          ),
        ],
      ),
    );
  }
}
