import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../feature/parking/presentation/pages/parking_page.dart';
import '../../feature/parking_history/presentation/pages/parking_history_page.dart';
import '../../shared/widgets/buttons/pk_button_text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funções'),
      ),
      body: Center(
        child: Column(
          children: [
            PKButtonTextWidget(
              onPressed: () => Modular.to.pushNamed('/$HISTORY_ROUTE_NAME'),
              child: Text('Histórico'),
            ),
            SizedBox(
              height: 10,
            ),
            PKButtonTextWidget(
              onPressed: () => Modular.to.pushNamed('/$PARKING_ROUTE_NAME'),
              child: Text('Estacionamento'),
            ),
          ],
        ),
      ),
    );
  }
}
