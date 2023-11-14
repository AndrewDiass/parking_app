import 'dart:convert';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/enums/parking_spot_status.dart';
import '../../../../../core/utils/services/interfaces/i_storage_service.dart';
import '../../models/parking_spot_model.dart';
import '../interfaces/i_parking_datasource.dart';

const PARKING_SPOT_LIST = 'parking_spot_list';
const PARKING_SPOT_LIST_HISTORY = 'parking_spot_list_history';

class StorageParkingDataSourceImpl implements IParkingDataSource {
  const StorageParkingDataSourceImpl({
    required this.storageService,
  });

  final IMemoryStorageService storageService;

  @override
  Future<List<ParkingSpotModel>> getParkingSpotList() async {
    try {
      return await readParkingSpotListStorage(
          keyNameStorage: PARKING_SPOT_LIST);
    } catch (e) {
      throw DataSourceException(message: dataSourceException);
    }
  }

  @override
  Future<List<ParkingSpotModel>> generateParkingSpot({
    required List<ParkingSpotModel> listGenereted,
  }) async {
    try {
      final isSaved = await writeParkingSpotListStorage(
        keyNameStorage: PARKING_SPOT_LIST,
        parkingPostList: listGenereted,
      );
      if (isSaved) {
        return listGenereted;
      } else {
        throw DataSourceException(message: dataSourceException);
      }
    } catch (e) {
      throw DataSourceException(message: dataSourceException);
    }
  }

  @override
  Future<ParkingSpotModel> checkInTheVehicle({
    required ParkingSpotModel parkingSpot,
  }) async {
    try {
      final parkingSpotList =
          await readParkingSpotListStorage(keyNameStorage: PARKING_SPOT_LIST);

      final index =
          parkingSpotList.indexWhere((spot) => spot.id == parkingSpot.id);

      parkingSpotList[index] = parkingSpot;

      final isSaved = await writeParkingSpotListStorage(
          keyNameStorage: PARKING_SPOT_LIST, parkingPostList: parkingSpotList);

      if (isSaved) {
        return parkingSpot;
      } else {
        throw DataSourceException(message: dataSourceException);
      }
    } catch (e) {
      throw DataSourceException(message: dataSourceException);
    }
  }

  @override
  Future<void> checkOutTheVehicle({
    required String parkingSpotId,
  }) async {
    try {
      final parkingSpotList =
          await readParkingSpotListStorage(keyNameStorage: PARKING_SPOT_LIST);

      final index =
          parkingSpotList.indexWhere((spot) => spot.id == parkingSpotId);

      parkingSpotList[index] = ParkingSpotModel(
        id: parkingSpotList[index].id,
        createdAt: parkingSpotList[index].createdAt,
        positionName: parkingSpotList[index].positionName,
        positionNumber: parkingSpotList[index].positionNumber,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        vehiclePlate: null,
        departureDate: null,
        nameOfCarOwner: null,
        parkingSpotStatus: ParkingSpotStatus.AVAILABLE,
        entryDate: null,
      );

      await writeParkingSpotListStorage(
          keyNameStorage: PARKING_SPOT_LIST, parkingPostList: parkingSpotList);
    } catch (e) {
      throw DataSourceException(message: dataSourceException);
    }
  }

  @override
  Future<bool> saveToHistory({
    required ParkingSpotModel parkingSpot,
  }) async {
    final parkingSpotList = await readParkingSpotListStorage(
      keyNameStorage: PARKING_SPOT_LIST_HISTORY,
    );
    parkingSpotList.add(parkingSpot);

    return await writeParkingSpotListStorage(
      keyNameStorage: PARKING_SPOT_LIST,
      parkingPostList: parkingSpotList,
    );
  }

  Future<List<ParkingSpotModel>> readParkingSpotListStorage({
    required String keyNameStorage,
  }) async {
    final result = await storageService.read(keyName: keyNameStorage);

    if (result != null) {
      final List<dynamic> jsonList = jsonDecode(result) as List<dynamic>;
      final parkingSpotList = jsonList
          .map(
            (jsonItem) => ParkingSpotModel.fromJson(jsonItem),
          )
          .toList();

      return parkingSpotList;
    } else {
      return [];
    }
  }

  Future<bool> writeParkingSpotListStorage({
    required String keyNameStorage,
    required List<ParkingSpotModel> parkingPostList,
  }) async {
    final listGeneretedMap =
        parkingPostList.map((spot) => spot.toJson()).toList();

    final encodedList = jsonEncode(listGeneretedMap);

    final isSaved = await storageService.write(
      keyName: PARKING_SPOT_LIST,
      value: encodedList,
    );

    return isSaved;
  }
}
