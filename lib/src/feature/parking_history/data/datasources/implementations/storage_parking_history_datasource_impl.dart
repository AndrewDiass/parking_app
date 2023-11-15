import 'dart:convert';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/services/interfaces/i_storage_service.dart';
import '../../models/parking_spot_model.dart';
import '../interfaces/i_parking_history_datasource.dart';

const PARKING_SPOT_LIST_HISTORY = 'parking_spot_list_history';

class StorageParkingHistoryDataSourceImpl implements IParkingHistoryDataSource {
  const StorageParkingHistoryDataSourceImpl({
    required this.storageService,
  });

  final IMemoryStorageService storageService;

  @override
  Future<List<ParkingSpotModel>> getParkingHistory() async {
    try {
      return await readParkingSpotListStorage(
        keyNameStorage: PARKING_SPOT_LIST_HISTORY,
      );
    } catch (e) {
      throw DataSourceException(message: dataSourceException);
    }
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
}
