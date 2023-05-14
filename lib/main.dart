import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';

import './blocs/sudoku_bloc.dart';
import './pages/sudoku_home_page.dart';

Future<void> main() async {
  Logger.root.level = Level.SHOUT;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return BlocProvider(
      create: (context) => SudokuBloc(),
      child: MaterialApp(
        title: 'Sudoku Solver',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // locale: const Locale('ru'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: //const SudokuImageScreen(),
            SudokuHomePage(),
      ),
    );
  }
}
