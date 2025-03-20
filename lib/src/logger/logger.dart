abstract class Logger {
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}
