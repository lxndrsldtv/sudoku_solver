import 'package:flutter/material.dart';
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
    return Container(
      // color: Colors.green,
      color: Colors.black,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key: const Key('DialogFrameTitleTextWidget'),
            titleText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
          ElevatedButton(
            onPressed: onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.cancel_rounded,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [title(), ...children]);
  }
}
