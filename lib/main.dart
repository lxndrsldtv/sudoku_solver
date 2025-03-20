import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
// import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/l10n/app_texts.dart';
import 'package:sudoku_solver/src/app/sudoku_solver_app.dart';
import 'package:sudoku_solver/src/module/module.dart';

import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import './blocs/sudoku_bloc.dart';
import './pages/sudoku_home_page.dart';

Future<void> main() async {
  // Logger.root.level = Level.SHOUT;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  Module().initialize(Injector());

  // runApp(SudokuSolver(imagePathProvider: ImagePickerPathProvider()));
  // runApp(SudokuSolver());
  runApp(SudokuSolverApp());
}

class SudokuSolver extends StatelessWidget {
  // const SudokuSolver({super.key, required this.imagePathProvider});
  const SudokuSolver({super.key});

  // final ImagePathProvider imagePathProvider;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SudokuBloc>(
            create: (context) =>
                // SudokuBloc(imagePathProvider: ImagePickerPathProvider())),
                // SudokuBloc(imagePathProvider: imagePathProvider)),
                SudokuBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        BlocProvider<PresentationBloc>(create: (context) => PresentationBloc()),
      ],
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
