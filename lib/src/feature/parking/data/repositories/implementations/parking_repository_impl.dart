import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/parking_spot_entity.dart';
import '../../datasources/interfaces/i_parking_datasource.dart';
import '../../models/parking_spot_model.dart';
import '../interfaces/i_parking_repository.dart';

class ParkingRepositoryImpl implements IParkingRepository {
  ParkingRepositoryImpl({
    required this.dataSource,
  });

  final IParkingDataSource dataSource;

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> getParkingSpotList() {
    return _handleRequestOrErros<List<ParkingSpotEntity>>(
      () async {
        return await dataSource.getParkingSpotList();
      },
    );
  }

  @override
  Future<Either<Failure, List<ParkingSpotEntity>>> generateParkingSpot({
    required List<ParkingSpotEntity> listGenereted,
  }) {
    return _handleRequestOrErros<List<ParkingSpotEntity>>(
      () async {
        return await dataSource.generateParkingSpot(
          listGenereted: List.generate(
            listGenereted.length,
            (index) => ParkingSpotModel(
              id: listGenereted[index].id,
              positionName: listGenereted[index].positionName,
              positionNumber: listGenereted[index].positionNumber,
              parkingSpotStatus: listGenereted[index].parkingSpotStatus,
              createdAt: listGenereted[index].createdAt,
              updatedAt: listGenereted[index].updatedAt,
            ),
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, ParkingSpotEntity>> checkInTheVehicle({
    required ParkingSpotEntity parkingSpot,
  }) {
    return _handleRequestOrErros<ParkingSpotEntity>(
      () async {
        return await dataSource.checkInTheVehicle(
          parkingSpot: ParkingSpotModel(
            id: parkingSpot.id,
            positionName: parkingSpot.positionName,
            positionNumber: parkingSpot.positionNumber,
            parkingSpotStatus: parkingSpot.parkingSpotStatus,
            createdAt: parkingSpot.createdAt,
            updatedAt: parkingSpot.updatedAt,
            entryDate: parkingSpot.entryDate,
            nameOfCarOwner: parkingSpot.nameOfCarOwner,
            vehiclePlate: parkingSpot.vehiclePlate,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> checkOutTheVehicle({
    required String parkingSpotId,
  }) {
    return _handleRequestOrErros<void>(
      () async {
        return await dataSource.checkOutTheVehicle(
            parkingSpotId: parkingSpotId);
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