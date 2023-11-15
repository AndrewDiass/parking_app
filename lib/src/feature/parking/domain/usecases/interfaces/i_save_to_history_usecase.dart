import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/parking_spot_entity.dart';

abstract class ISaveToHistoryUseCase {
  Future<Either<Failure, bool>> call({required ParkingSpotEntity parkingSpot});
}
