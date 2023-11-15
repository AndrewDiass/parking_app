import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/parking_spot_entity.dart';

abstract class IParkingHistoryRepository {
  Future<Either<Failure, List<ParkingSpotEntity>>> getParkingHistory();
}
