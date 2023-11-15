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
    required List<ParkingSpotEntity> listGenerated,
  }) {
    return _handleRequestOrErros<List<ParkingSpotEntity>>(
      () async {
        return await dataSource.generateParkingSpot(
          listGenerated: List.generate(
            listGenerated.length,
            (index) => ParkingSpotModel(
              id: listGenerated[index].id,
              positionName: listGenerated[index].positionName,
              positionNumber: listGenerated[index].positionNumber,
              parkingSpotStatus: listGenerated[index].parkingSpotStatus,
              createdAt: listGenerated[index].createdAt,
              updatedAt: listGenerated[index].updatedAt,
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
  Future<Either<Failure, ParkingSpotEntity>> checkOutTheVehicle({
    required String parkingSpotId,
  }) {
    return _handleRequestOrErros<ParkingSpotEntity>(
      () async {
        return await dataSource.checkOutTheVehicle(
            parkingSpotId: parkingSpotId);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> saveToHistory({
    required ParkingSpotEntity parkingSpot,
  }) {
    return _handleRequestOrErros<bool>(
      () async {
        return await dataSource.saveToHistory(
          parkingSpot: ParkingSpotModel(
            id: parkingSpot.id,
            positionName: parkingSpot.positionName,
            positionNumber: parkingSpot.positionNumber,
            parkingSpotStatus: parkingSpot.parkingSpotStatus,
            createdAt: parkingSpot.createdAt,
            updatedAt: parkingSpot.updatedAt,
            entryDate: parkingSpot.entryDate,
            departureDate: parkingSpot.departureDate,
            nameOfCarOwner: parkingSpot.nameOfCarOwner,
            vehiclePlate: parkingSpot.vehiclePlate,
          ),
        );
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
