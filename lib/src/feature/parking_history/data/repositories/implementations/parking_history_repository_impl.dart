import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/parking_spot_entity.dart';
import '../../datasources/interfaces/i_parking_history_datasource.dart';
import '../interfaces/i_parking_history_repository.dart';

class ParkingHistoryRepositoryImpl implements IParkingHistoryRepository {
  ParkingHistoryRepositoryImpl({
    required this.dataSource,
  });

  final IParkingHistoryDataSource dataSource;

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> getParkingHistory() {
    return _handleRequestOrErros<List<ParkingSpotEntity>>(
      () async {
        return await dataSource.getParkingHistory();
      },
    );
  }

  Future<Either<Failure, T>> _handleRequestOrErros<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } catch (e) {
      return const Left(
        ServerFailure(
          message: serverFailureMessage,
        ),
      );
    }
  }
}
