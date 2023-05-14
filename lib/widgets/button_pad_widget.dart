import 'package:collection/collection.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ButtonPadWidget extends StatelessWidget {
  const ButtonPadWidget({Key? key}) : super(key: key);

  static const style =
      NeumorphicStyle(color: Colors.white, depth: 1.0, intensity: 1.0);

  List<Widget> buildButtonRows(BuildContext context) {
    List<Widget> buttons = [];
    for (int button = 0; button < 9; button++) {
      buttons.add(Container(
          margin: const EdgeInsets.all(4.0),
          child: NeumorphicButton(
              style: style,
              minDistance: -1.0,
              onPressed: () => Navigator.of(context).pop(button + 1),
              child: Text((button + 1).toString()))));
    }

    List<Widget> rows = [];
    for (int row = 0; row < 3; row++) {
      rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons.slices(3).toList()[row]));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          margin: const EdgeInsets.all(4.0),
          child: NeumorphicButton(
              onPressed: () => Navigator.of(context).pop(0),
              style: style,
              minDistance: -1.0,
              child: const Text('Clear cell'))),
      ...buildButtonRows(context)
    ]);
  }
}
