import 'package:equatable/equatable.dart';

import '../../../domain/entities/parking_spot_entity.dart';

enum CurrentMenuItem {
  ALL,
  BUSY,
  AVAILABLE,
}

enum ParkingStatus {
  INITIAL,
  LOADING,
  FAILURE,
  SUCCESS,
}

class ParkingState extends Equatable {
  final List<ParkingSpotEntity> parkingSpotList;
  final String? messageFailure;
  final ParkingStatus status;
  final CurrentMenuItem currentMenuItem;
  final String? currentTextMenu;

  const ParkingState._({
    required this.parkingSpotList,
    this.messageFailure,
    required this.status,
    required this.currentMenuItem,
    this.currentTextMenu,
  });

  ParkingState.inital()
      : this._(
          parkingSpotList: [],
          messageFailure: '',
          status: ParkingStatus.INITIAL,
          currentMenuItem: CurrentMenuItem.ALL,
        );

  @override
  List<Object?> get props => [
        parkingSpotList,
        messageFailure,
        status,
        currentMenuItem,
        currentTextMenu,
      ];

  ParkingState copyWith({
    List<ParkingSpotEntity>? parkingSpotList,
    String? messageFailure,
    ParkingStatus? status,
    CurrentMenuItem? currentMenuItem,
    String? currentTextMenu,
  }) {
    return ParkingState._(
      parkingSpotList: parkingSpotList ?? this.parkingSpotList,
      messageFailure: messageFailure ?? this.messageFailure,
      status: status ?? this.status,
      currentMenuItem: currentMenuItem ?? this.currentMenuItem,
      currentTextMenu: currentTextMenu ?? this.currentTextMenu,
    );
  }
}
