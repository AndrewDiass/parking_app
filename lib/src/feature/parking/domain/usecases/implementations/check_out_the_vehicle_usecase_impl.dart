import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_check_out_the_vehicle_usecase.dart';

class CheckOutTheVehicleUseCase implements ICheckOutTheVehicleUseCase {
  CheckOutTheVehicleUseCase({required this.repository});
  final IParkingRepository repository;

  @override
  Future<Either<Failure, ParkingSpotEntity>> call({
    required String parkingSpotId,
  }) async {
    return await repository.checkOutTheVehicle(parkingSpotId: parkingSpotId);
  }
}
