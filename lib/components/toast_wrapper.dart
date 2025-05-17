import 'package:flutter/material.dart';

class ToastWrapper extends StatefulWidget {
  final Widget child;

  const ToastWrapper({
    super.key,
    required this.child,
  });

  static ToastWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<ToastWrapperState>();

  @override
  State<ToastWrapper> createState() => ToastWrapperState();
}

class ToastWrapperState extends State<ToastWrapper>
    with TickerProviderStateMixin {
  TickerProvider get vsync => this;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
