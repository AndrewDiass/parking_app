import '../../../domain/entities/parking_spot_entity.dart';
import 'parking_state.dart';

abstract class ParkingEvent {}

class GetParkingSpotsEvent extends ParkingEvent {}

class GenerateParkingSpotsEvent extends ParkingEvent {}

class SaveToHistoryEvent extends ParkingEvent {
  final ParkingSpotEntity parkingSpot;

  SaveToHistoryEvent({required this.parkingSpot});
}

class SetCurrentFilterMenuEvent extends ParkingEvent {
  final CurrentMenuItem selectedMenu;
  final int availableSpot;
  final int busySpot;
  final int allSpot;

  SetCurrentFilterMenuEvent({
    required this.selectedMenu,
    required this.availableSpot,
    required this.busySpot,
    required this.allSpot,
  });
}
