import 'dart:typed_data';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';

class CellInfoWidget extends StatelessWidget {
  const CellInfoWidget({Key? key, required this.cell}) : super(key: key);

  final SudokuCellModel cell;

  Widget styleText(String text) => NeumorphicText(text,
      style: const NeumorphicStyle(
          color: Colors.black87, depth: 1.0, intensity: 1.0),
      textStyle: NeumorphicTextStyle(fontSize: 16));

  Widget buildLabel(Widget child) =>
      Flexible(child: Container(alignment: Alignment.centerLeft, child: child));

  Widget buildValue(Widget child) => Flexible(child: Center(child: child));

  @override
  Widget build(BuildContext context) {
    final cellValue = cell.value;
    final cellImage = cell.image ?? Uint8List(0);

    return Neumorphic(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        style: const NeumorphicStyle(
            color: Colors.white, depth: -1.0, intensity: 1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              buildLabel(styleText('Cell value:')),
              buildValue(styleText(cellValue != 0 ? cellValue.toString() : '')),
            ],
          ),
          const Divider(height: 8.0),
          Row(children: [
            buildLabel(styleText('Cell image:')),
            buildValue(cellImage.isNotEmpty
                ? Image.memory(
                    cellImage,
                    fit: BoxFit.fill,
                    alignment: Alignment.centerRight,
                  )
                : const SizedBox(width: 0.0, height: 0.0))
          ])
        ]));
  }
}
