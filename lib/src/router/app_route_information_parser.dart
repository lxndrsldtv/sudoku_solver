import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/router/navigation_state.dart';

class AppRouteInformationParser extends RouteInformationParser<NavigationState> {
  final Logger logger;

  AppRouteInformationParser({required this.logger});

  @override
  Future<NavigationState> parseRouteInformation(RouteInformation routeInformation) async {
    logger.info(
      'AppRouteInformationParser.parseRouteInformation(...): uri: ${routeInformation.uri.pathSegments}',
    );

    if (routeInformation.uri.pathSegments.isEmpty) {
      return NavigationState(logger: Injector().get<Logger>());
    }

    // if (routeInformation.uri.pathSegments[0] == 'one') {
    //   final navigationState = (NavigationState()..isHomePage = true)..homeDetails = HomeDetails.one;
    //   if (routeInformation.uri.pathSegments.length > 1) {
    //     navigationState.oneDetails = switch (routeInformation.uri.pathSegments[1]) {
    //       '1' => OneDetails.one,
    //       '2' => OneDetails.two,
    //       '3' => OneDetails.three,

    //       // TODO: Handle this case.
    //       String() => throw UnimplementedError(),
    //     }
    //   }
    //   return navigationState;
    // }

    // if (routeInformation.uri.pathSegments[0] == 'two') {
    //   final navigationState = (NavigationState()..isHomePage = true)..homeDetails = HomeDetails.two;
    //   return navigationState;
    // }

    // if (routeInformation.uri.pathSegments[0] == 'three') {
    //   final navigationState = (NavigationState()..isHomePage = true)..homeDetails = HomeDetails.three;
    //   return navigationState;
    // }

    return NavigationState(logger: Injector().get<Logger>());
  }

  @override
  RouteInformation restoreRouteInformation(NavigationState configuration) {
    logger.info('AppRouteInformationParser.restoreRouteInformation(${configuration.toString()}');

    // if (configuration.onHomePage && configuration.homeDetails == HomeDetails.one) {
    //   switch (configuration.oneDetails) {
    //     case OneDetails.one:
    //       return RouteInformation(uri: Uri.parse('/one/1'));
    //     case OneDetails.two:
    //       return RouteInformation(uri: Uri.parse('/one/2'));
    //     case OneDetails.three:
    //       return RouteInformation(uri: Uri.parse('/one/3'));
    //     // default:
    //     //   return RouteInformation(uri: Uri.parse('/one/1'));
    //   }
    //   // return RouteInformation(uri: Uri.parse('/one'));
    // }

    // if (configuration.isHomePage && configuration.homeDetails == HomeDetails.two) {
    //   return RouteInformation(uri: Uri.parse('/two'));
    // }

    // if (configuration.isHomePage && configuration.homeDetails == HomeDetails.three) {
    //   return RouteInformation(uri: Uri.parse('/three'));
    // }

    return RouteInformation(uri: Uri.parse('/'));
  }
}
