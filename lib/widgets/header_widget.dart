import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style =
    TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold);
    final screenOrientation = MediaQuery
        .of(context)
        .orientation;

    return screenOrientation == Orientation.portrait
        ? const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('S', style: style),
          Text('U', style: style),
          Text('D', style: style),
          Text('O', style: style),
          Text('K', style: style),
          Text('U', style: style),
        ])
        : const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('S', style: style),
          Text('U', style: style),
          Text('D', style: style),
          Text('O', style: style),
          Text('K', style: style),
          Text('U', style: style),
        ]);
  }
}
