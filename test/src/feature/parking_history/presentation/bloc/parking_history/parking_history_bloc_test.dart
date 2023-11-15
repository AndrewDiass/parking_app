import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/src/core/errors/failures.dart';
import 'package:parking_app/src/core/utils/enums/parking_spot_status.dart';
import 'package:parking_app/src/feature/parking_history/data/models/parking_spot_model.dart';
import 'package:parking_app/src/feature/parking_history/domain/usecases/interfaces/i_get_parking_history_usecase.dart';
import 'package:parking_app/src/feature/parking_history/presentation/bloc/parking_history/parking_history_bloc.dart';
import 'package:parking_app/src/feature/parking_history/presentation/bloc/parking_history/parking_history_event.dart';
import 'package:parking_app/src/feature/parking_history/presentation/bloc/parking_history/parking_history_state.dart';

class MockGetParkingHistoryUseCase extends Mock
    implements IGetParkingHistoryUseCase {}

void main() {
  late MockGetParkingHistoryUseCase getParkingHistoryUseCase;

  setUpAll(() {
    getParkingHistoryUseCase = MockGetParkingHistoryUseCase();
  });

  group('ParkingHistoryBloc Test', () {
    blocTest<ParkingHistoryBloc, ParkingHistoryState>(
      'Get history list success.',
      build: () => ParkingHistoryBloc(
        getParkingHistoryUseCase: getParkingHistoryUseCase,
      ),
      setUp: () {
        when(() => getParkingHistoryUseCase.call())
            .thenAnswer((_) async => Right(returnParkingListModel(5)));
      },
      act: (bloc) => bloc.add(
        GetParkingHistoryEvent(),
      ),
      expect: () => [
        isA<ParkingHistoryState>()
            .having((p) => p.status, 'status', ParkingHistoryStatus.LOADING),
        isA<ParkingHistoryState>()
            .having((p) => p.status, 'status', ParkingHistoryStatus.SUCCESS)
            .having((p) => p.parkingSpotList.length, 'parkingSpotList',
                greaterThan(0))
      ],
    );

    blocTest<ParkingHistoryBloc, ParkingHistoryState>(
      'Get history list failure.',
      build: () => ParkingHistoryBloc(
        getParkingHistoryUseCase: getParkingHistoryUseCase,
      ),
      setUp: () {
        when(() => getParkingHistoryUseCase.call())
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) => bloc.add(
        GetParkingHistoryEvent(),
      ),
      expect: () => [
        isA<ParkingHistoryState>()
            .having((p) => p.status, 'status', ParkingHistoryStatus.LOADING),
        isA<ParkingHistoryState>()
            .having((p) => p.status, 'status', ParkingHistoryStatus.FAILURE),
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
