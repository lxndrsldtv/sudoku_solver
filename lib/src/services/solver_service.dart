// import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

class SolverService {
  void solve(ReactiveSudokuModel sudoku) {}

  void doMove(ReactiveSudokuModel sudoku) {}

  void undoMove(ReactiveSudokuModel sudoku) {}
}

class SolverServiceLoggable extends SolverService {
  final Logger logger;

  SolverServiceLoggable({required this.logger});

  @override
  void solve(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.solve()');
  }

  @override
  void doMove(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.nextMove()');
  }

  @override
  void undoMove(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.undoMove()');
  }
}
