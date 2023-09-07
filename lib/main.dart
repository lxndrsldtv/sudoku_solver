import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';

import './blocs/sudoku_bloc.dart';
import './pages/sudoku_home_page.dart';
import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../services/image_path_provider.dart';

Future<void> main() async {
  Logger.root.level = Level.SHOUT;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  runApp(SudokuSolver(imagePathProvider: ImagePickerPathProvider()));
}

class SudokuSolver extends StatelessWidget {
  const SudokuSolver({super.key, required this.imagePathProvider});

  final ImagePathProvider imagePathProvider;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SudokuBloc>(
            create: (context) =>
                // SudokuBloc(imagePathProvider: ImagePickerPathProvider())),
                SudokuBloc(imagePathProvider: imagePathProvider)),
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
