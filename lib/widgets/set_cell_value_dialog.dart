import 'package:flutter/material.dart';

import '../models/sudoku_cell_model.dart';

import './button_pad_widget.dart';
import './cell_info_widget.dart';
import './dialog_frame.dart';

class SetCellValueDialog extends StatelessWidget {
  const SetCellValueDialog({Key? key, required this.cellModel})
      : super(key: key);

  final SudokuCellModel cellModel;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenOrientation = mediaQuery.orientation;

    return DialogFrame(
      titleText: 'Set cell value',
      children: screenOrientation == Orientation.portrait
          ? [
              CellInfoWidget(cell: cellModel),
              const SizedBox(height: 16.0),
              const ButtonPadWidget(),
            ]
          : [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                    width: mediaQuery.size.width / 2,
                    child: CellInfoWidget(cell: cellModel)),
                const ButtonPadWidget(),
              ])
            ],
      onClose: () => Navigator.of(context).pop(),
    );
  }
}
