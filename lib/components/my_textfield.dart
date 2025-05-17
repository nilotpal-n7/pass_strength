import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final void Function() onPressed;
  final TextSpan? richText;

  const MyTextfield({
    super.key,
    required this.text,
    required this.onPressed,
    required this.onTap,
    this.richText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Center(
                child: richText != null
                    ? RichText(text: richText!)
                    : Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
