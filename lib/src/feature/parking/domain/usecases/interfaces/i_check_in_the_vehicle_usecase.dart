import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/parking_spot_entity.dart';

abstract class ICheckInTheVehicleUseCase {
  Future<Either<Failure, ParkingSpotEntity>> call({
    required ParkingSpotEntity parkingSpot,
  });
}
