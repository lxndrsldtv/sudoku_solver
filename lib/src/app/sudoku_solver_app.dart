import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';
// import 'package:sudoku_solver/models/sudoku_model.dart';
import 'package:sudoku_solver/src/app/app_settings.dart';

class SudokuSolverApp extends StatelessWidget {
  const SudokuSolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppSettings>(create: (context) => AppSettings()),
      ],
      child: MaterialApp.router(
        title: 'Sudoku Solver',
        routerDelegate: Injector().get<RouterDelegate>() as RouterDelegate<Object>?,
        routeInformationParser: Injector().get<RouteInformationParser>() as RouteInformationParser<Object>?,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
