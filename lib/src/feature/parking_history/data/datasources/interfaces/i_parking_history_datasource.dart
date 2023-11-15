import '../../models/parking_spot_model.dart';

abstract class IParkingHistoryDataSource {
  Future<List<ParkingSpotModel>> getParkingHistory();
}
