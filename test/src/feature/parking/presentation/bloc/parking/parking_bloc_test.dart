import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/src/core/utils/enums/parking_spot_status.dart';
import 'package:parking_app/src/feature/parking/data/models/parking_spot_model.dart';
import 'package:parking_app/src/feature/parking/domain/entities/parking_spot_entity.dart';
import 'package:parking_app/src/feature/parking/domain/usecases/interfaces/i_generate_parking_spot_usecase.dart';
import 'package:parking_app/src/feature/parking/domain/usecases/interfaces/i_get_parking_spot_list_usecase.dart';
import 'package:parking_app/src/feature/parking/domain/usecases/interfaces/i_save_to_history_usecase.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking/parking_bloc.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking/parking_event.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking/parking_state.dart';

class MockGenerateParkingSpotUseCase extends Mock
    implements IGenerateParkingSpotUseCase {}

class MockGetParkingSpotListUseCase extends Mock
    implements IGetParkingSpotListUseCase {}

class MockSaveToHistoryUseCase extends Mock implements ISaveToHistoryUseCase {}

class FakeParkingSpotEntity extends Fake implements ParkingSpotEntity {}

void main() {
  late MockGetParkingSpotListUseCase getParkingSpotListUseCase;
  late MockGenerateParkingSpotUseCase generateParkingSpotUseCase;
  late MockSaveToHistoryUseCase saveToHistoryUseCase;
  late FakeParkingSpotEntity parkingSpotSaveToHistory;

  setUpAll(() {
    registerFallbackValue(FakeParkingSpotEntity());
    getParkingSpotListUseCase = MockGetParkingSpotListUseCase();
    generateParkingSpotUseCase = MockGenerateParkingSpotUseCase();
    saveToHistoryUseCase = MockSaveToHistoryUseCase();
    parkingSpotSaveToHistory = FakeParkingSpotEntity();
  });

  group('ParkingBloc Test', () {
    blocTest<ParkingBloc, ParkingState>(
      'He carried the list of vacancies successfully.',
      build: () => ParkingBloc(
        generateParkingSpotUseCase: generateParkingSpotUseCase,
        getParkingSpotListUseCase: getParkingSpotListUseCase,
        saveToHistory: saveToHistoryUseCase,
      ),
      setUp: () {
        when(getParkingSpotListUseCase.call)
            .thenAnswer((_) async => Right(returnParkingListModel(2)));
      },
      act: (bloc) => bloc.add(GetParkingSpotsEvent()),
      expect: () => [
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.LOADING),
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.SUCCESS)
            .having((p) => p.parkingSpotList.length, 'parkingSpotList',
                greaterThan(0)),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'He loaded the list of vacancies successfully but the list comes empty for not having vacancies in the register.',
      build: () => ParkingBloc(
        generateParkingSpotUseCase: generateParkingSpotUseCase,
        getParkingSpotListUseCase: getParkingSpotListUseCase,
        saveToHistory: saveToHistoryUseCase,
      ),
      setUp: () {
        when(getParkingSpotListUseCase.call).thenAnswer((_) async => Right([]));
      },
      act: (bloc) => bloc.add(GetParkingSpotsEvent()),
      expect: () => [
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.LOADING),
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.SUCCESS)
            .having(
              (p) => p.parkingSpotList.length,
              'parkingSpotList',
              equals(0),
            ),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'Generate vacancies successfully.',
      build: () => ParkingBloc(
        generateParkingSpotUseCase: generateParkingSpotUseCase,
        getParkingSpotListUseCase: getParkingSpotListUseCase,
        saveToHistory: saveToHistoryUseCase,
      ),
      setUp: () {
        final mockList = returnParkingListModel(30);
        when(() => generateParkingSpotUseCase.call(
                listGenerated: any(named: 'listGenerated')))
            .thenAnswer((_) async => Right(mockList));
      },
      act: (bloc) => bloc.add(GenerateParkingSpotsEvent()),
      expect: () => [
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.LOADING),
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.SUCCESS)
            .having(
              (p) => p.parkingSpotList.length,
              'parkingSpotList',
              greaterThanOrEqualTo(30),
            ),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'Save ParkingSpot to history.',
      build: () => ParkingBloc(
        generateParkingSpotUseCase: generateParkingSpotUseCase,
        getParkingSpotListUseCase: getParkingSpotListUseCase,
        saveToHistory: saveToHistoryUseCase,
      ),
      setUp: () {
        when(() => saveToHistoryUseCase.call(
                parkingSpot: any(named: 'parkingSpot')))
            .thenAnswer((_) async => Right(true));
      },
      act: (bloc) => bloc.add(
        SaveToHistoryEvent(
          parkingSpot: parkingSpotSaveToHistory,
        ),
      ),
      expect: () => [
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.LOADING),
        isA<ParkingState>()
            .having((p) => p.status, 'status', ParkingStatus.SUCCESS),
      ],
    );
  });
}

List<ParkingSpotModel> returnParkingListModel(int? length) {
  return List.generate(
    length ?? 2,
    (index) => ParkingSpotModel(
      id: "0${index + 1}",
      positionName: "A",
      positionNumber: index + 1,
      parkingSpotStatus: ParkingSpotStatus.AVAILABLE,
      nameOfCarOwner: "car_owner_name_test",
      vehiclePlate: "vehicle_plate_test",
      carBrand: "car_brand_test",
      entryDate: 1636890000,
      departureDate: 1636933200,
      createdAt: 1636933200,
      updatedAt: 1636933200,
    ),
  );
}
