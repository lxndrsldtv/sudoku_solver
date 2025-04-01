import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/logger/talker_logger.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';
import 'package:sudoku_solver/src/router/app_route_information_parser.dart';
import 'package:sudoku_solver/src/router/app_router_delegate.dart';
import 'package:sudoku_solver/src/router/navigation_state.dart';

class Module {
  Injector initialize(Injector injector) {
    injector.map<Logger>(
      (i) => TalkerLogger.i,
      isSingleton: true,
    );

    injector.map<NavigationState>(
      (i) => NavigationState(logger: i.get<Logger>()),
    );

    injector.map<RouterDelegate>(
      (i) => AppRouterDelegate(
        navigationState: i.get<NavigationState>(),
        logger: i.get<Logger>(),
      ),
      isSingleton: true,
    );

    injector.map<RouteInformationParser>(
      (i) => AppRouteInformationParser(logger: i.get<Logger>()),
      isSingleton: true,
    );

    injector.map<ReactiveSudokuModel>(
      (i) => ReactiveSudokuLoggableModel(
        cellFactory: i.get<SudokuCellModelFactoryFunction>(),
        logger: i.get<Logger>(),
      ),
      isSingleton: true,
    );

    injector.mapWithParams<SudokuCellModelFactoryFunction>(
      (i, params) => ({required Map<String, dynamic> params}) => ReactiveSudokuCellLoggableModel(
            subgridIndex: params['subgridIndex'] as int,
            subgridCellIndex: params['subgridCellIndex'] as int,
            logger: i.get<Logger>(),
          ),
    );

    return injector;
  }
}
