import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';

import '../models/sudoku_cell_model.dart';

class CellInfoWidget extends StatelessWidget {
  const CellInfoWidget({Key? key, required this.cell, required this.cellImage})
      : super(key: key);

  final SudokuCellModel cell;
  final Uint8List cellImage;

  Widget styleText(String text) => Text(
        text,
        key: Key(text),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      );

  Widget buildLabel(Widget child) =>
      Flexible(child: Container(alignment: Alignment.centerLeft, child: child));

  Widget buildValue(Widget child) => Flexible(child: Center(child: child));

  @override
  Widget build(BuildContext context) {
    final cellValue = cell.value;

    return Container(
        //Neumorphic(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              buildLabel(styleText(
                  AppLocalizations.of(context)?.dlgSetCellValue_lblCellValue ??
                      'Cell value:')),
              buildValue(styleText(cellValue != 0 ? cellValue.toString() : '')),
            ],
          ),
          const Divider(height: 8.0),
          Row(children: [
            buildLabel(styleText(
                AppLocalizations.of(context)?.dlgSetCellValue_lblCellImage ??
                    'Cell image:')),
            buildValue(cellImage.isNotEmpty
                ? Image.memory(
                    key: const Key('Image'),
                    cellImage,
                    fit: BoxFit.fill,
                    alignment: Alignment.centerRight,
                  )
                : const SizedBox(
                    key: Key('EmptyImage'), width: 0.0, height: 0.0))
          ])
        ]));
  }
}
