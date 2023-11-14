import '../../models/parking_spot_model.dart';

abstract class IParkingDataSource {
  Future<List<ParkingSpotModel>> getParkingSpotList();

  Future<List<ParkingSpotModel>> generateParkingSpot({
    required List<ParkingSpotModel> listGenereted,
  });

  Future<ParkingSpotModel> checkInTheVehicle({
    required ParkingSpotModel parkingSpot,
  });

  Future<ParkingSpotModel> checkOutTheVehicle({
    required String parkingSpotId,
  });

  Future<bool> saveToHistory({
    required ParkingSpotModel parkingSpot,
  });
}
