import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/main.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  // runApp(SudokuSolver(imagePathProvider: StubImagePathProvider()));
  runApp(SudokuSolver());
}
