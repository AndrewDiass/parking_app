import 'package:equatable/equatable.dart';

enum ParkingSpotEditStatus {
  INITIAL,
  LOADING,
  FAILURE,
  SUCCESS,
}

class ParkingSpotEditState extends Equatable {
  final String? messageFailure;
  final ParkingSpotEditStatus status;

  const ParkingSpotEditState._({
    required this.messageFailure,
    required this.status,
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
      ];

  ParkingSpotEditState copyWith({
    String? messageFailure,
    ParkingSpotEditStatus? status,
  }) {
    return ParkingSpotEditState._(
      messageFailure: messageFailure ?? this.messageFailure,
      status: status ?? this.status,
    );
  }
}
