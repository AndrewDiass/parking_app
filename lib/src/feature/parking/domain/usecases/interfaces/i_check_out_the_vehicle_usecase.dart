import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

abstract class ICheckOutTheVehicleUseCase {
  Future<Either<Failure, void>> call({
    required String parkingSpotId,
  });
}
