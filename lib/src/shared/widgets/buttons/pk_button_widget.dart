import 'package:flutter/material.dart';

class PKButtonWidget extends ElevatedButton {
  const PKButtonWidget({
    super.key,
    required super.onPressed,
    required super.child,
    super.style,
  });

  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child!,
    );
  }
}
