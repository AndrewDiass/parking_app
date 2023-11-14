import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_widget.dart';
import 'src/app_module.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
