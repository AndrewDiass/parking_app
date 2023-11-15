import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_history_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_get_parking_history_usecase.dart';

class GetParkingHistoryUseCase implements IGetParkingHistoryUseCase {
  GetParkingHistoryUseCase({required this.repository});
  final IParkingHistoryRepository repository;

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> call() async {
    return await repository.getParkingHistory();
  }
}
