import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_get_parking_spot_list_usecase.dart';

class GetParkingSpotListUseCase implements IGetParkingSpotListUseCase {
  GetParkingSpotListUseCase({required this.repository});
  final IParkingRepository repository;

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> call() async {
    return repository.getParkingSpotList();
  }
}
