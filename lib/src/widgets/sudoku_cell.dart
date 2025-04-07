import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

const bool doShowCellCoordinates = true;
const double minScreenWidth = 340.0;

class SudokuCellWidget extends StatelessWidget {
  const SudokuCellWidget({
    super.key,
    required this.subgridIndex,
    required this.subgridCellIndex,
  });

  final int subgridIndex;
  final int subgridCellIndex;

  @override
  Widget build(BuildContext context) {
    final minSide = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return StreamBuilder<CellState>(
      stream: Injector().get<ReactiveSudokuModel>().cellStateStream(subgridIndex, subgridCellIndex),
      builder: (context, snapshot) => Container(
        color: Color(0xFFFFFFFF),
        child: Stack(
          children: [
            if (doShowCellCoordinates && snapshot.data != null)
              Text(
                '${snapshot.data?.coordinates.toString()}',
                style: TextStyle(fontSize: 8.0, color: Colors.blue[100]),
                textScaler: TextScaler.linear(minSide / minScreenWidth),
              ),
            Align(
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: TextField(
                  key: ValueKey(snapshot.data?.value),
                  controller: TextEditingController(
                      text: snapshot.data == null || snapshot.data?.value == 0 ? '' : '${snapshot.data?.value}'),
                  style: TextStyle(fontSize: 24.0 * (minSide / minScreenWidth)),
                  decoration: null,
                  cursorHeight: 24.0 * minSide / minScreenWidth,
                  textAlign: TextAlign.center,
                  onSubmitted: (value) => snapshot.data?.value = int.tryParse(value) ?? 0,
                ),
              ),
            ),
            if (snapshot.data?.possibleValues.isNotEmpty ?? false)
              Align(
                alignment: Alignment.bottomRight,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: SudokuCellTestedAndPossibleValuesWidget(
                    key: ValueKey(snapshot.data?.possibleValues),
                    cellPossibleValues: snapshot.data?.possibleValues ?? {},
                    cellTestedValues: snapshot.data?.testedValues ?? {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SudokuCellTestedAndPossibleValuesWidget extends StatelessWidget {
  final Set<int> cellPossibleValues;
  final Set<int> cellTestedValues;

  const SudokuCellTestedAndPossibleValuesWidget({
    super.key,
    required this.cellPossibleValues,
    required this.cellTestedValues,
  });

  @override
  Widget build(BuildContext context) {
    final minSide = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return cellPossibleValues.isEmpty
        ? const SizedBox.shrink()
        : Row(
            children: cellPossibleValues
                .map((value) => Text(
                      '$value',
                      style: TextStyle(
                        color: cellTestedValues.contains(value) ? Colors.red[100] : Colors.green[100],
                        fontSize: 6.0,
                      ),
                      textScaler: TextScaler.linear(minSide / minScreenWidth),
                    ))
                .toList(),
          );
  }
}
