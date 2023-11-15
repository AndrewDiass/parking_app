import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/interfaces/i_get_parking_history_usecase.dart';
import 'parking_history_event.dart';
import 'parking_history_state.dart';

class ParkingHistoryBloc
    extends Bloc<ParkingHistoryEvent, ParkingHistoryState> {
  final IGetParkingHistoryUseCase _getParkingHistoryUseCase;

  ParkingHistoryBloc({
    required IGetParkingHistoryUseCase getParkingHistoryUseCase,
  })  : _getParkingHistoryUseCase = getParkingHistoryUseCase,
        super(ParkingHistoryState.inital()) {
    on<GetParkingHistoryEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingHistoryStatus.LOADING));
      final result = await _getParkingHistoryUseCase();

      result.fold(
        (failure) {
          emit(state.copyWith(status: ParkingHistoryStatus.FAILURE));
        },
        (parkingSpotListResult) {
          emit(
            state.copyWith(
              status: ParkingHistoryStatus.SUCCESS,
              parkingSpotList: parkingSpotListResult,
            ),
          );
        },
      );
    });
  }
}
