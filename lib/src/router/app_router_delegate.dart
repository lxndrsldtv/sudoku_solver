import 'package:flutter/material.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/pages/page_home.dart';
import 'package:sudoku_solver/src/router/navigation_state.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final Logger logger;
  final NavigationState _navigationState;

  AppRouterDelegate({
    required NavigationState navigationState,
    required this.logger,
  }) : _navigationState = navigationState;

  @override
  Widget build(BuildContext context) {
    logger.info('AppRouterDelegate.build(): _navigationState: ${_navigationState.toString()}');

    return Navigator(
      key: _key,
      // onPopPage: (route, result) => route.didPop(result),
      onDidRemovePage: (page) => logger.info('Navigator.onDidRemovePage: $page'),
      pages: [
        // TODO:  think to inject pages as dependency
        if (_navigationState.onHomePage) MaterialPage(child: PageHome()),
      ],
    );
  }

  final _key = GlobalKey<NavigatorState>();
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    logger.info('AppRouterDelegate.setNewRoutePath(${configuration.toString()});');
    _navigationState.onHomePage = configuration.onHomePage;
  }

  @override
  NavigationState get currentConfiguration => _navigationState;

  void openPage(String pageName) {
    logger.info('AppRouterDelegate.openPage($pageName)');
    switch (pageName) {
      case 'Home':
        _navigationState.onHomePage = true;
        break;
      default:
        _navigationState.onHomePage = true;
    }
    notifyListeners();
  }
}
