import 'parking_state.dart';

abstract class ParkingEvent {}

class GetParkingSpotsEvent extends ParkingEvent {}

class GenerateParkingSpotsEvent extends ParkingEvent {}

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
