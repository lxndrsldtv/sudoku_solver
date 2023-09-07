import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/blocs/presentation/presentation_bloc.dart';
import 'package:sudoku_solver/blocs/sudoku_bloc.dart';
import 'package:sudoku_solver/services/image_path_provider.dart';
import 'package:sudoku_solver/widgets/control_button_bar.dart';

Future<void> main() async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('CellInfoWidget ', (() {
    testWidgets('Test control buttons are displayed with labels',
        (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SudokuBloc>(
                create: (context) =>
                    SudokuBloc(imagePathProvider: ImagePickerPathProvider())),
            // BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
            BlocProvider<PresentationBloc>(
                create: (context) => PresentationBloc()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // locale: Locale('ru'),
            home: Scaffold(
              body: ControlButtonBar(),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('select_image_btn')), findsOneWidget);
      expect(find.byIcon(Icons.image_search_rounded), findsOneWidget);

      expect(find.byKey(const Key('solve_btn')), findsOneWidget);
      expect(find.byIcon(Icons.play_circle), findsOneWidget);

      expect(find.byKey(const Key('reset_btn')), findsOneWidget);
      expect(find.byIcon(Icons.restart_alt), findsOneWidget);

      expect(find.byKey(const Key('settings_btn')), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  }));
}
