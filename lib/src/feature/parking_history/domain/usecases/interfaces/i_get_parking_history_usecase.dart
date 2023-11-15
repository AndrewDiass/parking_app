import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/parking_spot_entity.dart';

abstract class IGetParkingHistoryUseCase {
  Future<Either<Failure, List<ParkingSpotEntity>>> call();
}
