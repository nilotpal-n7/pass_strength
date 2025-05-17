import 'package:flutter/material.dart';

class MyToggler extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const MyToggler({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected 
          ? Theme.of(context).colorScheme.tertiary 
          : Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
