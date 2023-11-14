import 'package:flutter_modular/flutter_modular.dart';

import 'core/utils/services/implementations/shared_preferences_storage_service_impl.dart';
import 'core/utils/services/interfaces/i_storage_service.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<IMemoryStorageService>(
      SharedPreferencesStorageService.new,
    );
  }

  @override
  void routes(r) {}
}
