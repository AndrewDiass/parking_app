import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'src/shared/theme/pk_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Estacionamento App',
      theme: PK_THEME_DATA,
      routerConfig: Modular.routerConfig,
      builder: BotToastInit(),
    );
  }
}
