import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/parking_spot_status.dart';
import '../../../domain/entities/parking_spot_entity.dart';
import '../../../domain/usecases/interfaces/i_generate_parking_spot_usecase.dart';
import '../../../domain/usecases/interfaces/i_get_parking_spot_list_usecase.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final IGetParkingSpotListUseCase _getParkingSpotListUseCase;
  final IGenerateParkingSpotUseCase _generateParkingSpotUseCase;

  ParkingBloc({
    required IGetParkingSpotListUseCase getParkingSpotListUseCase,
    required IGenerateParkingSpotUseCase generateParkingSpotUseCase,
  })  : _getParkingSpotListUseCase = getParkingSpotListUseCase,
        _generateParkingSpotUseCase = generateParkingSpotUseCase,
        super(ParkingState.inital()) {
    on<GetParkingSpotsEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingStatus.LOADING));
      final parkingSpots = await _getParkingSpotListUseCase();

      parkingSpots.fold(
        (failure) {
          emit(state.copyWith(status: ParkingStatus.FAILURE));
        },
        (parkingSpotListResult) {
          emit(
            state.copyWith(
              status: ParkingStatus.SUCCESS,
              parkingSpotList: parkingSpotListResult,
            ),
          );
        },
      );
    });

    on<GenerateParkingSpotsEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingStatus.LOADING));
      final result = List<ParkingSpotEntity>.generate(
        30,
        (index) => ParkingSpotEntity(
          id: index.toString(),
          positionName: 'A',
          positionNumber: index,
          parkingSpotStatus: ParkingSpotStatus.AVAILABLE,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final parkingSpots =
          await _generateParkingSpotUseCase(listGenereted: result);

      parkingSpots.fold(
        (failure) {
          emit(state.copyWith(status: ParkingStatus.FAILURE));
        },
        (parkingSpotListResult) {
          emit(
            state.copyWith(
              status: ParkingStatus.SUCCESS,
              parkingSpotList: parkingSpotListResult,
            ),
          );
        },
      );
    });

    on<SetCurrentFilterMenuEvent>((event, emit) async {
      String textMenu = '';

      switch (event.selectedMenu) {
        case CurrentMenuItem.AVAILABLE:
          textMenu = 'Vagas Disponíveis (${event.availableSpot})';
          break;
        case CurrentMenuItem.BUSY:
          textMenu = 'Vagas Ocupadas (${event.busySpot})';
          break;
        case CurrentMenuItem.ALL:
        default:
          textMenu = 'Todas as vagas (${event.allSpot})';
      }

      emit(state.copyWith(
        currentTextMenu: textMenu,
        currentMenuItem: event.selectedMenu,
      ));
    });
  }
}
