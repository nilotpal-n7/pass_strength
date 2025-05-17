import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String text;
  final MainAxisAlignment mainAxisAlignment;

  const MySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.blueAccent.shade400,
          ),
        ),
      ],
    );
  }
}
