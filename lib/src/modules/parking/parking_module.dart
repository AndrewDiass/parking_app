import 'package:flutter_modular/flutter_modular.dart';

import '../../feature/parking/data/datasources/implementations/storage_parking_datasource_impl.dart';
import '../../feature/parking/data/datasources/interfaces/i_parking_datasource.dart';
import '../../feature/parking/data/repositories/implementations/parking_repository_impl.dart';
import '../../feature/parking/data/repositories/interfaces/i_parking_repository.dart';
import '../../feature/parking/domain/usecases/implementations/check_in_the_vehicle_usecase_impl.dart';
import '../../feature/parking/domain/usecases/implementations/check_out_the_vehicle_usecase_impl.dart';
import '../../feature/parking/domain/usecases/implementations/generate_parking_spot_usecase_impl.dart';
import '../../feature/parking/domain/usecases/implementations/get_parking_spot_list_usecase_impl.dart';
import '../../feature/parking/domain/usecases/interfaces/i_check_in_the_vehicle_usecase.dart';
import '../../feature/parking/domain/usecases/interfaces/i_check_out_the_vehicle_usecase.dart';
import '../../feature/parking/domain/usecases/interfaces/i_generate_parking_spot_usecase.dart';
import '../../feature/parking/domain/usecases/interfaces/i_get_parking_spot_list_usecase.dart';
import '../../feature/parking/presentation/bloc/parking/parking_bloc.dart';
import '../../feature/parking/presentation/bloc/parking_spot_edit/parking_spot_edit_bloc.dart';
import '../../feature/parking/presentation/pages/parking_page.dart';

class ParkingModule extends Module {
  @override
  void binds(i) {
    i.add<IParkingDataSource>(
      () => StorageParkingDataSourceImpl(
        storageService: i.get(),
      ),
    );
    i.add<IParkingRepository>(
      () => ParkingRepositoryImpl(
        // storageService: i.get(),
        dataSource: i.get(),
      ),
    );
    i.add<IGetParkingSpotListUseCase>(
      () => GetParkingSpotListUseCase(
        repository: i.get(),
      ),
    );
    i.add<IGenerateParkingSpotUseCase>(
      () => GenerateParkingSpotUseCase(
        repository: i.get(),
      ),
    );
    i.add<ParkingBloc>(
      () => ParkingBloc(
        getParkingSpotListUseCase: i.get(),
        generateParkingSpotUseCase: i.get(),
      ),
    );
    i.add<ICheckInTheVehicleUseCase>(
      () => CheckInTheVehicleUseCase(
        repository: i.get(),
      ),
    );
    i.add<ICheckOutTheVehicleUseCase>(
      () => CheckOutTheVehicleUseCase(
        repository: i.get(),
      ),
    );
    i.add<ParkingSpotEditBloc>(
      () => ParkingSpotEditBloc(
        checkInTheVehicleUseCase: i.get(),
        checkOutTheVehicleUseCase: i.get(),
      ),
    );
  }

  @override
  void routes(r) {}
}
