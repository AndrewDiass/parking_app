import '../../../domain/entities/parking_spot_entity.dart';

abstract class ParkingSpotEditEvent {}

class CheckInTheVehicleEvent extends ParkingSpotEditEvent {
  CheckInTheVehicleEvent({required this.parkingSpot});
  final ParkingSpotEntity parkingSpot;
}

class CheckOutTheVehicleEvent extends ParkingSpotEditEvent {
  CheckOutTheVehicleEvent({required this.parkingSpotId});
  final String parkingSpotId;
}
