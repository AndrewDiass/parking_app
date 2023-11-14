import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/src/core/errors/exceptions.dart';
import 'package:parking_app/src/core/utils/enums/parking_spot_status.dart';
import 'package:parking_app/src/core/utils/services/interfaces/i_storage_service.dart';
import 'package:parking_app/src/feature/parking/data/datasources/implementations/storage_parking_datasource_impl.dart';
import 'package:parking_app/src/feature/parking/data/datasources/interfaces/i_parking_datasource.dart';
import 'package:parking_app/src/feature/parking/data/models/parking_spot_model.dart';

class MockParkingDataSource extends Mock implements IParkingDataSource {}

class MockMemoryStorageService extends Mock implements IMemoryStorageService {}

void main() {
  late MockMemoryStorageService mockMemoryStorageService;
  late StorageParkingDataSourceImpl dataSource;

  setUp(() {
    mockMemoryStorageService = MockMemoryStorageService();
    dataSource =
        StorageParkingDataSourceImpl(storageService: mockMemoryStorageService);
  });

  group('Parking DataSource getParkingSpotList', () {
    test('You must return a list of ParkingPotmodel in success', () async {
      final encodedList = returnEncodedList();

      when(() => mockMemoryStorageService.read(keyName: PARKING_SPOT_LIST))
          .thenAnswer((_) async => encodedList);

      final result = await dataSource.getParkingSpotList();

      expect(result, isA<List<ParkingSpotModel>>());
      expect(result.length, greaterThan(0));
      expect(result[0].id, '01');
      expect('${result[0].positionName}${result[0].positionNumber}', 'A1');
      expect(result[1].id, '02');
      expect('${result[1].positionName}${result[1].positionNumber}', 'A2');
    });

    test('Must launch an exception in error', () async {
      when(() => mockMemoryStorageService.read(keyName: PARKING_SPOT_LIST))
          .thenThrow(Exception("Erro de Leitura"));

      expect(
          dataSource.getParkingSpotList(), throwsA(isA<DataSourceException>()));
    });
  });

  group('Parking DataSource generateParkingSpot', () {
    test("You must return to ParkingPotmodel's list in success", () async {
      final mockList = returnParkingListModel();
      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => true);

      final result =
          await dataSource.generateParkingSpot(listGenereted: mockList);
      expect(result, isA<List<ParkingSpotModel>>());
      expect(result.length, greaterThan(0));
    });

    test('Must launch a datasourceexception in case of exception', () async {
      final mockList = returnParkingListModel();
      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenThrow(Exception());

      expect(dataSource.generateParkingSpot(listGenereted: mockList),
          throwsA(isA<DataSourceException>()));
    });
  });

  group('Parking DataSource checkInTheVehicle', () {
    test('You must update the list with the new vehicle input.', () async {
      final mockParkingSpot = ParkingSpotModel(
        id: "01",
        positionName: "A",
        positionNumber: 1,
        parkingSpotStatus: ParkingSpotStatus.BUSY,
        nameOfCarOwner: "car_owner_name_test",
        vehiclePlate: "vehicle_plate_test",
        carBrand: "car_brand_test",
        entryDate: 1636890000,
        departureDate: 1636933200,
        createdAt: 1636933200,
        updatedAt: 1636933200,
      );

      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenAnswer((_) async => returnEncodedList());

      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => true);

      final result =
          await dataSource.checkInTheVehicle(parkingSpot: mockParkingSpot);
      expect(result, isA<ParkingSpotModel>());
      expect(result.parkingSpotStatus, ParkingSpotStatus.BUSY);
    });

    test('Return DatasArceexception when trying to recover the storage list',
        () async {
      final mockParkingSpot = ParkingSpotModel(
        id: "01",
        positionName: "A",
        positionNumber: 1,
        parkingSpotStatus: ParkingSpotStatus.BUSY,
        nameOfCarOwner: "car_owner_name_test",
        vehiclePlate: "vehicle_plate_test",
        carBrand: "car_brand_test",
        entryDate: 1636890000,
        departureDate: 1636933200,
        createdAt: 1636933200,
        updatedAt: 1636933200,
      );

      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenThrow(Exception());

      expect(dataSource.checkInTheVehicle(parkingSpot: mockParkingSpot),
          throwsA(isA<DataSourceException>()));
    });

    test('Return DatasArceexception by trying to save the list on Storage',
        () async {
      final mockParkingSpot = ParkingSpotModel(
        id: "01",
        positionName: "A",
        positionNumber: 1,
        parkingSpotStatus: ParkingSpotStatus.BUSY,
        nameOfCarOwner: "car_owner_name_test",
        vehiclePlate: "vehicle_plate_test",
        carBrand: "car_brand_test",
        entryDate: 1636890000,
        departureDate: 1636933200,
        createdAt: 1636933200,
        updatedAt: 1636933200,
      );

      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenAnswer((_) async => returnEncodedList());

      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => false);

      expect(dataSource.checkInTheVehicle(parkingSpot: mockParkingSpot),
          throwsA(isA<DataSourceException>()));
    });
  });

  group('Parking DataSource checkOutTheVehicle', () {
    test('You must update the list with the vehicle output.', () async {
      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenAnswer((_) async => returnEncodedList());

      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => true);

      await dataSource.checkOutTheVehicle(parkingSpotId: "01");
      verify(() =>
              mockMemoryStorageService.read(keyName: any(named: 'keyName')))
          .called(1);
      verify(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).called(1);
    });

    test('Return DatasArceexception when trying to recover the storage list',
        () async {
      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenThrow(Exception());

      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => true);

      expect(dataSource.checkOutTheVehicle(parkingSpotId: "01"),
          throwsA(isA<DataSourceException>()));
    });

    test('Return DatasArceexception by trying to save the list on Storage',
        () async {
      when(() => mockMemoryStorageService.read(
            keyName: any(named: 'keyName'),
          )).thenAnswer((_) async => returnEncodedList());

      when(() => mockMemoryStorageService.write(
            keyName: any(named: 'keyName'),
            value: any(named: 'value'),
          )).thenThrow(Exception());

      expect(dataSource.checkOutTheVehicle(parkingSpotId: "01"),
          throwsA(isA<DataSourceException>()));
    });
  });

  group('Parking DataSource readParkingSpotListStorage', () {
    test('You should return a list of parkingspotmodel when there is data',
        () async {
      final encodedList = returnEncodedList();

      when(() => mockMemoryStorageService.read(keyName: PARKING_SPOT_LIST))
          .thenAnswer((_) async => encodedList);

      final result = await dataSource.readParkingSpotListStorage();

      expect(result, isA<List<ParkingSpotModel>>());
      expect(result.length, greaterThan(0));
      expect(result[0].id, '01');
      expect('${result[0].positionName}${result[0].positionNumber}', 'A1');
      expect(result[1].id, '02');
      expect('${result[1].positionName}${result[1].positionNumber}', 'A2');
    });

    test('You should return an empty list when there is no data', () async {
      final parkingListExample = [];

      final listGeneretedMap =
          parkingListExample.map((spot) => spot.toJson()).toList();

      final encodedEmptyList = jsonEncode(listGeneretedMap);

      when(() => mockMemoryStorageService.read(keyName: PARKING_SPOT_LIST))
          .thenAnswer((_) async => encodedEmptyList);

      final result = await dataSource.readParkingSpotListStorage();

      expect(result, isA<List<ParkingSpotModel>>());
      expect(result.length, equals(0));
    });
  });

  group('Parking DataSource writeParkingSpotListStorageMethod', () {
    test('You must return True when the list is successfully saved', () async {
      when(
        () => mockMemoryStorageService.write(
          keyName: any(named: 'keyName'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => true);
      final result = await dataSource.writeParkingSpotListStorage([]);

      expect(result, isTrue);
    });

    test('You must return false in failure', () async {
      when(
        () => mockMemoryStorageService.write(
          keyName: any(named: 'keyName'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => false);
      final result = await dataSource.writeParkingSpotListStorage([]);

      expect(result, isFalse);
    });
  });
}

List<ParkingSpotModel> returnParkingListModel() {
  return List.generate(
    2,
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

String returnEncodedList() {
  final parkingListExample = returnParkingListModel();

  final listGeneretedMap =
      parkingListExample.map((spot) => spot.toJson()).toList();

  return jsonEncode(listGeneretedMap);
}
