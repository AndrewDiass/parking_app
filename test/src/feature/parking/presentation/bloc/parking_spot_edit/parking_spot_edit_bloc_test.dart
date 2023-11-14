import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/src/core/errors/failures.dart';
import 'package:parking_app/src/feature/parking/domain/entities/parking_spot_entity.dart';
import 'package:parking_app/src/feature/parking/domain/usecases/interfaces/i_check_in_the_vehicle_usecase.dart';
import 'package:parking_app/src/feature/parking/domain/usecases/interfaces/i_check_out_the_vehicle_usecase.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking_spot_edit/parking_spot_edit_bloc.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking_spot_edit/parking_spot_edit_event.dart';
import 'package:parking_app/src/feature/parking/presentation/bloc/parking_spot_edit/parking_spot_edit_state.dart';

class MockCheckInTheVehicleUseCase extends Mock
    implements ICheckInTheVehicleUseCase {}

class MockCheckOutTheVehicleUseCase extends Mock
    implements ICheckOutTheVehicleUseCase {}

class FakeParkingSpotEntity extends Fake implements ParkingSpotEntity {}

void main() {
  late MockCheckInTheVehicleUseCase checkInTheVehicleUseCase;
  late MockCheckOutTheVehicleUseCase checkOutTheVehicleUseCase;
  late FakeParkingSpotEntity checkInSpotEntity;

  setUpAll(() {
    registerFallbackValue(FakeParkingSpotEntity());
    checkInTheVehicleUseCase = MockCheckInTheVehicleUseCase();
    checkOutTheVehicleUseCase = MockCheckOutTheVehicleUseCase();
    checkInSpotEntity = FakeParkingSpotEntity();
  });

  group('ParkingSpotEditBloc Test', () {
    blocTest<ParkingSpotEditBloc, ParkingSpotEditState>(
      'Entrance of the vehicle with success.',
      build: () => ParkingSpotEditBloc(
        checkInTheVehicleUseCase: checkInTheVehicleUseCase,
        checkOutTheVehicleUseCase: checkOutTheVehicleUseCase,
      ),
      setUp: () {
        when(() => checkInTheVehicleUseCase.call(
                parkingSpot: any(named: 'parkingSpot')))
            .thenAnswer((_) async => Right(checkInSpotEntity));
      },
      act: (bloc) => bloc.add(
        CheckInTheVehicleEvent(parkingSpot: checkInSpotEntity),
      ),
      expect: () => [
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.LOADING),
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.SUCCESS)
      ],
    );

    blocTest<ParkingSpotEditBloc, ParkingSpotEditState>(
      'Failure at the entrance of the vehicle.',
      build: () => ParkingSpotEditBloc(
        checkInTheVehicleUseCase: checkInTheVehicleUseCase,
        checkOutTheVehicleUseCase: checkOutTheVehicleUseCase,
      ),
      setUp: () {
        when(() => checkInTheVehicleUseCase.call(
                parkingSpot: any(named: 'parkingSpot')))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) => bloc.add(
        CheckInTheVehicleEvent(
          parkingSpot: checkInSpotEntity,
        ),
      ),
      expect: () => [
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.LOADING),
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.FAILURE)
      ],
    );

    blocTest<ParkingSpotEditBloc, ParkingSpotEditState>(
      'Exit of the vehicle with success.',
      build: () => ParkingSpotEditBloc(
        checkInTheVehicleUseCase: checkInTheVehicleUseCase,
        checkOutTheVehicleUseCase: checkOutTheVehicleUseCase,
      ),
      setUp: () {
        when(() => checkOutTheVehicleUseCase.call(
                parkingSpotId: any(named: 'parkingSpotId')))
            .thenAnswer((_) async => Right(null));
      },
      act: (bloc) => bloc.add(
        CheckOutTheVehicleEvent(
          parkingSpotId: "01",
        ),
      ),
      expect: () => [
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.LOADING),
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.SUCCESS)
      ],
    );

    blocTest<ParkingSpotEditBloc, ParkingSpotEditState>(
      'Failure to exit the vehicle.',
      build: () => ParkingSpotEditBloc(
        checkInTheVehicleUseCase: checkInTheVehicleUseCase,
        checkOutTheVehicleUseCase: checkOutTheVehicleUseCase,
      ),
      setUp: () {
        when(() => checkOutTheVehicleUseCase.call(
                parkingSpotId: any(named: 'parkingSpotId')))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) => bloc.add(
        CheckOutTheVehicleEvent(parkingSpotId: "01"),
      ),
      expect: () => [
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.LOADING),
        isA<ParkingSpotEditState>()
            .having((p) => p.status, 'status', ParkingSpotEditStatus.FAILURE)
      ],
    );
  });
}
