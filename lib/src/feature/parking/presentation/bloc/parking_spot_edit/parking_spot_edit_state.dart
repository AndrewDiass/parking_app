import 'package:equatable/equatable.dart';

import '../../../domain/entities/parking_spot_entity.dart';

enum ParkingSpotEditStatus {
  INITIAL,
  LOADING,
  FAILURE,
  ENTRY_SUCCESS,
  EXIT_SUCCESS,
}

class ParkingSpotEditState extends Equatable {
  final String? messageFailure;
  final ParkingSpotEditStatus status;
  final ParkingSpotEntity? parkignSpotToSave;

  const ParkingSpotEditState._({
    required this.messageFailure,
    required this.status,
    this.parkignSpotToSave,
  });

  ParkingSpotEditState.inital()
      : this._(
          messageFailure: '',
          status: ParkingSpotEditStatus.INITIAL,
        );

  @override
  List<Object?> get props => [
        messageFailure,
        status,
        this.parkignSpotToSave,
      ];

  ParkingSpotEditState copyWith({
    String? messageFailure,
    ParkingSpotEditStatus? status,
    ParkingSpotEntity? parkignSpotToSave,
  }) {
    return ParkingSpotEditState._(
      messageFailure: messageFailure ?? this.messageFailure,
      status: status ?? this.status,
      parkignSpotToSave: parkignSpotToSave ?? this.parkignSpotToSave,
    );
  }
}
