import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  static void showToast(
    String title,
    String subtitle, {
    Color? backgroundColor,
    Duration? duration,
  }) {
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subtitle,
      backgroundColor: backgroundColor ?? Colors.white,
      hideCloseButton: true,
      duration: duration ?? const Duration(seconds: 2),
    );
  }
}
