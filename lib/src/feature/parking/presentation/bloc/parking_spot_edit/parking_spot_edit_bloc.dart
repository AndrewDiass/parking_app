import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/interfaces/i_check_in_the_vehicle_usecase.dart';
import '../../../domain/usecases/interfaces/i_check_out_the_vehicle_usecase.dart';
import 'parking_spot_edit_event.dart';
import 'parking_spot_edit_state.dart';

class ParkingSpotEditBloc
    extends Bloc<ParkingSpotEditEvent, ParkingSpotEditState> {
  final ICheckInTheVehicleUseCase _checkInTheVehicleUseCase;
  final ICheckOutTheVehicleUseCase _checkOutTheVehicleUseCase;

  ParkingSpotEditBloc({
    required ICheckInTheVehicleUseCase checkInTheVehicleUseCase,
    required ICheckOutTheVehicleUseCase checkOutTheVehicleUseCase,
  })  : _checkInTheVehicleUseCase = checkInTheVehicleUseCase,
        _checkOutTheVehicleUseCase = checkOutTheVehicleUseCase,
        super(ParkingSpotEditState.inital()) {
    on<CheckInTheVehicleEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingSpotEditStatus.LOADING));
      final checkInTheVehicleResult =
          await _checkInTheVehicleUseCase(parkingSpot: event.parkingSpot);

      checkInTheVehicleResult.fold(
        (failure) {
          emit(state.copyWith(status: ParkingSpotEditStatus.FAILURE));
        },
        (parkingSpotListResult) {
          emit(
            state.copyWith(
              status: ParkingSpotEditStatus.ENTRY_SUCCESS,
            ),
          );
        },
      );
    });

    on<CheckOutTheVehicleEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingSpotEditStatus.LOADING));
      final parkingSpots =
          await _checkOutTheVehicleUseCase(parkingSpotId: event.parkingSpotId);

      parkingSpots.fold(
        (failure) {
          emit(state.copyWith(status: ParkingSpotEditStatus.FAILURE));
        },
        (parkingSpotEntity) {
          emit(state.copyWith(
            status: ParkingSpotEditStatus.EXIT_SUCCESS,
            parkignSpotToSave: parkingSpotEntity,
          ));
        },
      );
    });
  }
}
