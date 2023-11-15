import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums/parking_spot_status.dart';

class ParkingSpotEntity extends Equatable {
  const ParkingSpotEntity({
    required this.id,
    required this.positionName,
    required this.positionNumber,
    required this.parkingSpotStatus,
    this.nameOfCarOwner,
    this.vehiclePlate,
    this.carBrand,
    this.entryDate,
    this.departureDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String positionName;
  final int positionNumber;
  final ParkingSpotStatus parkingSpotStatus;
  final String? nameOfCarOwner;
  final String? vehiclePlate;
  final String? carBrand;
  final int? entryDate;
  final int? departureDate;
  final int createdAt;
  final int updatedAt;

  @override
  List<Object?> get props => [
        id,
        positionName,
        positionNumber,
        parkingSpotStatus,
        nameOfCarOwner,
        vehiclePlate,
        carBrand,
        entryDate,
        departureDate,
        createdAt,
        updatedAt,
      ];
}
