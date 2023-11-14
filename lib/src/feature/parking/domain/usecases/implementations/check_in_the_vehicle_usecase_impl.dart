import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_check_in_the_vehicle_usecase.dart';

class CheckInTheVehicleUseCase implements ICheckInTheVehicleUseCase {
  CheckInTheVehicleUseCase({required this.repository});
  final IParkingRepository repository;

  @override
  Future<Either<Failure, ParkingSpotEntity>> call({
    required ParkingSpotEntity parkingSpot,
  }) async {
    return await repository.checkInTheVehicle(parkingSpot: parkingSpot);
  }
}
