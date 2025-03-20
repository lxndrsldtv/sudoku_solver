import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerLogger implements Logger {
  TalkerLogger._();

  static final TalkerLogger _instance = TalkerLogger._();

  static TalkerLogger get i => _instance;

  final talker = TalkerFlutter.init();

  @override
  void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      talker.error(
        message,
        error,
        stackTrace,
      );

  @override
  void warning(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      talker.warning(
        message,
        error,
        stackTrace,
      );

  @override
  void debug(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      talker.debug(
        message,
        error,
        stackTrace,
      );

  @override
  void info(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      talker.info(
        message,
        error,
        stackTrace,
      );
}
