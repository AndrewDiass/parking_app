import 'dart:convert';

import '../../../../core/utils/enums/parking_spot_status.dart';
import '../../domain/entities/parking_spot_entity.dart';

class ParkingSpotModel extends ParkingSpotEntity {
  const ParkingSpotModel({
    required super.id,
    required super.positionName,
    required super.positionNumber,
    required super.parkingSpotStatus,
    super.nameOfCarOwner,
    super.vehiclePlate,
    super.carBrand,
    super.entryDate,
    super.departureDate,
    required super.createdAt,
    required super.updatedAt,
  });

  ParkingSpotModel copyWith({
    String? id,
    String? positionName,
    int? positionNumber,
    ParkingSpotStatus? parkingSpotStatus,
    String? nameOfCarOwner,
    String? vehiclePlate,
    String? carBrand,
    int? entryDate,
    int? departureDate,
    int? createdAt,
    int? updatedAt,
  }) =>
      ParkingSpotModel(
        id: id ?? this.id,
        positionName: positionName ?? this.positionName,
        positionNumber: positionNumber ?? this.positionNumber,
        parkingSpotStatus: parkingSpotStatus ?? this.parkingSpotStatus,
        nameOfCarOwner: nameOfCarOwner ?? this.nameOfCarOwner,
        vehiclePlate: vehiclePlate ?? this.vehiclePlate,
        carBrand: carBrand ?? this.carBrand,
        entryDate: entryDate ?? this.entryDate,
        departureDate: departureDate ?? this.departureDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'positionName': positionName,
        'positionNumber': positionNumber,
        'parkingSpotStatus': parkingSpotStatus.name,
        'nameOfCarOwner': nameOfCarOwner,
        'vehiclePlate': vehiclePlate,
        'carBrand': carBrand,
        'entryDate': entryDate,
        'departureDate': departureDate,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) =>
      ParkingSpotModel(
        id: map['id'] as String,
        positionName: map['positionName'] as String,
        positionNumber: map['positionNumber'] as int,
        parkingSpotStatus:
            ParkingSpotStatus.values.byName(map['parkingSpotStatus']),
        nameOfCarOwner: map['nameOfCarOwner'] as String?,
        vehiclePlate: map['vehiclePlate'] as String?,
        carBrand: map['carBrand'] as String?,
        entryDate: map['entryDate'] as int?,
        departureDate: map['departureDate'] as int?,
        createdAt: map['createdAt'] as int,
        updatedAt: map['updatedAt'] as int,
      );

  String toJson() => json.encode(toMap());

  factory ParkingSpotModel.fromJson(String source) => ParkingSpotModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
