import 'package:flutter_modular/flutter_modular.dart';

import 'core/utils/services/implementations/shared_preferences_storage_service_impl.dart';
import 'core/utils/services/interfaces/i_storage_service.dart';
import 'feature/parking/presentation/pages/parking_page.dart';
import 'feature/parking_history/presentation/pages/parking_history_page.dart';
import 'modules/home/home.dart';
import 'modules/parking_history/parking_history_module.dart';
import 'modules/parking/parking_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<IMemoryStorageService>(
      SharedPreferencesStorageService.new,
    );
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage());
    r.module('/$HISTORY_ROUTE_NAME', module: ParkingHistoryModule());
    r.module('/$PARKING_ROUTE_NAME', module: ParkingModule());
  }
}
