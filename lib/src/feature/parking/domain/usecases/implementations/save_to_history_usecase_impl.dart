import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_save_to_history_usecase.dart';

class GetParkingSpotListUseCase implements ISaveToHistoryUseCase {
  GetParkingSpotListUseCase({required this.repository});
  final IParkingRepository repository;

  @override
  Future<Either<Failure, bool>> call({
    required ParkingSpotEntity parkingSpot,
  }) async {
    return await repository.saveToHistory(
      parkingSpot: parkingSpot,
    );
  }
}
