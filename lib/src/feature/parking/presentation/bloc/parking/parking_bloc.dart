import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/parking_spot_status.dart';
import '../../../domain/entities/parking_spot_entity.dart';
import '../../../domain/usecases/interfaces/i_generate_parking_spot_usecase.dart';
import '../../../domain/usecases/interfaces/i_get_parking_spot_list_usecase.dart';
import '../../../domain/usecases/interfaces/i_save_to_history_usecase.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final IGetParkingSpotListUseCase _getParkingSpotListUseCase;
  final IGenerateParkingSpotUseCase _generateParkingSpotUseCase;
  final ISaveToHistoryUseCase _saveToHistory;

  ParkingBloc({
    required IGetParkingSpotListUseCase getParkingSpotListUseCase,
    required IGenerateParkingSpotUseCase generateParkingSpotUseCase,
    required ISaveToHistoryUseCase saveToHistory,
  })  : _getParkingSpotListUseCase = getParkingSpotListUseCase,
        _generateParkingSpotUseCase = generateParkingSpotUseCase,
        _saveToHistory = saveToHistory,
        super(ParkingState.inital()) {
    on<GetParkingSpotsEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingStatus.LOADING));
      final parkingSpots = await _getParkingSpotListUseCase();

      parkingSpots.fold(
        (failure) {
          emit(state.copyWith(status: ParkingStatus.FAILURE));
        },
        (parkingSpotListResult) {
          List<ParkingSpotEntity> currentList = [];
          final parkingSpotListAvailable = parkingSpotListResult
              .where((spot) =>
                  spot.parkingSpotStatus == ParkingSpotStatus.AVAILABLE)
              .toList();
          final parkingSpotListBusy = parkingSpotListResult
              .where((spot) => spot.parkingSpotStatus == ParkingSpotStatus.BUSY)
              .toList();

          switch (state.currentMenuItem) {
            case CurrentMenuItem.AVAILABLE:
              currentList = parkingSpotListAvailable;
              break;

            case CurrentMenuItem.BUSY:
              currentList = parkingSpotListBusy;
              break;

            case CurrentMenuItem.ALL:
            default:
              currentList = parkingSpotListResult;
          }

          emit(
            state.copyWith(
              status: ParkingStatus.SUCCESS,
              parkingSpotList: currentList,
              parkingSpotListAvailable: parkingSpotListAvailable,
              parkingSpotListBusy: parkingSpotListBusy,
              parkingSpotListAll: currentList,
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

    on<SaveToHistoryEvent>((event, emit) async {
      emit(state.copyWith(status: ParkingStatus.LOADING));

      final response = await _saveToHistory(parkingSpot: event.parkingSpot);

      response.fold(
        (failure) {
          emit(
            state.copyWith(
              status: ParkingStatus.FAILURE,
            ),
          );
        },
        (parkingSpotListResult) {
          emit(
            state.copyWith(
              status: ParkingStatus.SUCCESS,
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
          emit(state.copyWith(
            currentTextMenu: textMenu,
            currentMenuItem: event.selectedMenu,
            parkingSpotList: state.parkingSpotListAvailable,
          ));
          break;
        case CurrentMenuItem.BUSY:
          textMenu = 'Vagas Ocupadas (${event.busySpot})';
          emit(state.copyWith(
            currentTextMenu: textMenu,
            currentMenuItem: event.selectedMenu,
            parkingSpotList: state.parkingSpotListBusy,
          ));
          break;
        case CurrentMenuItem.ALL:
        default:
          textMenu = 'Todas as vagas (${event.allSpot})';
          emit(state.copyWith(
              currentTextMenu: textMenu,
              currentMenuItem: event.selectedMenu,
              parkingSpotList: state.parkingSpotListAll));
      }
    });
  }
}
