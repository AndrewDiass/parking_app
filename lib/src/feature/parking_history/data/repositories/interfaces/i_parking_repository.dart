import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/parking_spot_entity.dart';

abstract class IParkingRepository {
  Future<Either<Failure, List<ParkingSpotEntity>>> getParkingSpotList();

  Future<Either<Failure, List<ParkingSpotEntity>>> generateParkingSpot({
    required List<ParkingSpotEntity> listGenerated,
  });

  Future<Either<Failure, ParkingSpotEntity>> checkInTheVehicle({
    required ParkingSpotEntity parkingSpot,
  });

  Future<Either<Failure, ParkingSpotEntity>> checkOutTheVehicle({
    required String parkingSpotId,
  });

  Future<Either<Failure, bool>> saveToHistory({
    required ParkingSpotEntity parkingSpot,
  });
}
