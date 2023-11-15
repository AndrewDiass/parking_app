import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/parking_spot_entity.dart';

abstract class IGenerateParkingSpotUseCase {
  Future<Either<Failure, List<ParkingSpotEntity>>> call({
    required List<ParkingSpotEntity> listGenerated,
  });
}
