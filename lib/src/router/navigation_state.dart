import 'package:sudoku_solver/src/logger/logger.dart';

class NavigationState {
  final Logger logger;

  bool onHomePage = true;

  NavigationState({required this.logger});

  @override
  String toString() {
    return 'NavigationState{onHomePage: $onHomePage}';
  }
}
