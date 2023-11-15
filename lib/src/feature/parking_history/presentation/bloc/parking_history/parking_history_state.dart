import 'package:equatable/equatable.dart';

import '../../../domain/entities/parking_spot_entity.dart';

enum ParkingHistoryStatus {
  INITIAL,
  LOADING,
  FAILURE,
  SUCCESS,
}

class ParkingHistoryState extends Equatable {
  final List<ParkingSpotEntity> parkingSpotList;
  final String? messageFailure;
  final ParkingHistoryStatus status;

  const ParkingHistoryState._({
    required this.parkingSpotList,
    this.messageFailure,
    required this.status,
  });

  ParkingHistoryState.inital()
      : this._(
          parkingSpotList: [],
          messageFailure: '',
          status: ParkingHistoryStatus.INITIAL,
        );

  @override
  List<Object?> get props => [
        parkingSpotList,
        messageFailure,
        status,
      ];

  ParkingHistoryState copyWith({
    List<ParkingSpotEntity>? parkingSpotList,
    String? messageFailure,
    ParkingHistoryStatus? status,
  }) {
    return ParkingHistoryState._(
      parkingSpotList: parkingSpotList ?? this.parkingSpotList,
      messageFailure: messageFailure ?? this.messageFailure,
      status: status ?? this.status,
    );
  }
}
