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
    return StreamBuilder<CellState>(
      stream: Injector().get<ReactiveSudokuModel>().cellStateStream(subgridIndex, subgridCellIndex),
      builder: (context, snapshot) => Container(
        color: Color(0xFFFFFFFF),
        child: Stack(
          children: [
            if (doShowCellCoordinates && snapshot.data != null)
              Text(
                '${snapshot.data?.coordinates.toString()}',
                style: TextStyle(fontSize: 8.0),
                textScaler: TextScaler.linear(MediaQuery.of(context).size.width / minScreenWidth),
              ),
            Align(
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  key: ValueKey(snapshot.data?.value),
                  snapshot.data == null || snapshot.data?.value == 0 ? '' : '${snapshot.data?.value}',
                  style: TextStyle(fontSize: 24.0),
                  textScaler: TextScaler.linear(MediaQuery.of(context).size.width / minScreenWidth),
                ),
              ),
              // },
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
                    child: SudokuCellTestedOfPossibleValues(
                      key: ValueKey(snapshot.data?.possibleValues),
                      cellPossibleValues: snapshot.data?.possibleValues ?? {},
                      cellTestedValues: snapshot.data?.testedValues ?? {},
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class SudokuCellTestedOfPossibleValues extends StatelessWidget {
  final Set<int> cellPossibleValues;
  final Set<int> cellTestedValues;

  const SudokuCellTestedOfPossibleValues({
    super.key,
    required this.cellPossibleValues,
    required this.cellTestedValues,
  });

  @override
  Widget build(BuildContext context) {
    return cellPossibleValues.isEmpty
        ? const SizedBox.shrink()
        : Row(
            children: cellPossibleValues
                .map((value) => Text(
                      '$value',
                      style: TextStyle(
                        color: cellTestedValues.contains(value) ? Colors.red : Colors.green,
                        fontSize: 6.0,
                      ),
                      textScaler: TextScaler.linear(MediaQuery.of(context).size.width / minScreenWidth),
                    ))
                .toList(),
          );
  }
}
