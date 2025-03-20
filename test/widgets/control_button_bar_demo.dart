import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_solver/blocs/presentation/presentation_bloc.dart';
import 'package:sudoku_solver/blocs/sudoku_bloc.dart';
import 'package:sudoku_solver/l10n/app_texts.dart';
import 'package:sudoku_solver/widgets/control_button_bar.dart';

Future<void> main() async {
  runApp(const CellEditButtonBarWidgetDemo());
}

class CellEditButtonBarWidgetDemo extends StatelessWidget {
  const CellEditButtonBarWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SudokuBloc>(
            create: (context) =>
                // SudokuBloc(imagePathProvider: ImagePickerPathProvider())),
                SudokuBloc()),
        // BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        BlocProvider<PresentationBloc>(create: (context) => PresentationBloc()),
      ],
      child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // locale: Locale('ru'),
          home: ControlButtonBar()),
    );
  }
}
