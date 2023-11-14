import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/repositories/interfaces/i_parking_repository.dart';
import '../../entities/parking_spot_entity.dart';
import '../interfaces/i_generate_parking_spot_usecase.dart';

class GenerateParkingSpotUseCase implements IGenerateParkingSpotUseCase {
  GenerateParkingSpotUseCase({required this.repository});
  final IParkingRepository repository;

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> call({
    required List<ParkingSpotEntity> listGenereted,
  }) async {
    return repository.generateParkingSpot(listGenereted: listGenereted);
  }
}
