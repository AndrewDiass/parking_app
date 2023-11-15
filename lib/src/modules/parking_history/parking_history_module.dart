import 'package:flutter_modular/flutter_modular.dart';

import '../../feature/parking_history/data/datasources/implementations/storage_parking_history_datasource_impl.dart';
import '../../feature/parking_history/data/datasources/interfaces/i_parking_history_datasource.dart';
import '../../feature/parking_history/data/repositories/implementations/parking_history_repository_impl.dart';
import '../../feature/parking_history/data/repositories/interfaces/i_parking_history_repository.dart';
import '../../feature/parking_history/domain/usecases/implementations/get_parking_history_usecase.dart';
import '../../feature/parking_history/domain/usecases/interfaces/i_get_parking_history_usecase.dart';
import '../../feature/parking_history/presentation/bloc/parking_history/parking_history_bloc.dart';
import '../../feature/parking_history/presentation/pages/parking_history_page.dart';

class ParkingHistoryModule extends Module {
  @override
  void binds(i) {
    i.add<IParkingHistoryDataSource>(
      () => StorageParkingHistoryDataSourceImpl(
        storageService: i.get(),
      ),
    );
    i.add<IParkingHistoryRepository>(
      () => ParkingHistoryRepositoryImpl(
        dataSource: i.get(),
      ),
    );
    i.add<IGetParkingHistoryUseCase>(
      () => GetParkingHistoryUseCase(
        repository: i.get(),
      ),
    );
    i.add<ParkingHistoryBloc>(
      () => ParkingHistoryBloc(
        getParkingHistoryUseCase: i.get(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => ParkingHistoryPage(
        parkingHistoryBloc: Modular.get(),
      ),
    );
  }
}
