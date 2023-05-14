import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:logging/logging.dart';

class DialogFrame extends StatelessWidget {
  final String titleText;
  final List<Widget> children;
  final void Function()? onClose;
  final logger = Logger('DialogFrame');

  DialogFrame(
      {Key? key, required this.titleText, required this.children, this.onClose})
      : super(key: key);

  Widget title() {
    return Neumorphic(
        style: const NeumorphicStyle(color: Colors.green),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          NeumorphicText(titleText,
              style: const NeumorphicStyle(
                  color: Colors.white, depth: 1.0, intensity: 1.0),
              textStyle: NeumorphicTextStyle(fontSize: 22.0)),
          NeumorphicButton(
              onPressed: onClose,
              padding: const EdgeInsets.all(4.0),
              style: const NeumorphicStyle(
                  depth: 1.0,
                  intensity: 1.0,
                  color: Colors.green,
                  boxShape: NeumorphicBoxShape.circle()),
              child: const Icon(Icons.cancel_rounded,
                  color: Colors.white, size: 28))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [title(), ...children]);
  }
}
