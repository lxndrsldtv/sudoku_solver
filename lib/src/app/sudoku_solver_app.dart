import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class SudokuSolverApp extends StatelessWidget {
  const SudokuSolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sudoku Solver',
      routerDelegate: Injector().get<RouterDelegate>() as RouterDelegate<Object>?,
      routeInformationParser: Injector().get<RouteInformationParser>() as RouteInformationParser<Object>?,
      debugShowCheckedModeBanner: false,
    );
  }
}
