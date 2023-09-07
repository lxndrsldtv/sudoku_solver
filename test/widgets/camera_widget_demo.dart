import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/widgets/camera_widget.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  runApp(const CameraWidgetDemo());
}

class CameraWidgetDemo extends StatelessWidget {
  const CameraWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // locale: Locale('ru'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Widget Demo'),
        ),
        body: const CameraWidget(),
      ),
    );
  }
}
