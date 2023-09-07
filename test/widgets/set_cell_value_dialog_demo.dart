import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';
import 'package:sudoku_solver/widgets/set_cell_value_dialog.dart';

Future<void> main() async {
  runApp(const CellEditButtonBarWidgetDemo());
}

class CellEditButtonBarWidgetDemo extends StatelessWidget {
  const CellEditButtonBarWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // locale: Locale('ru'),
      home: SetCellValueDialog(
        cellModel: SudokuCellModel(
            index: 0, row: 'R1', column: 'C1', subgrid: 'S01', value: 1),
        cellImage: Uint8List(0),
      ),
      // ),
    );
  }
}
