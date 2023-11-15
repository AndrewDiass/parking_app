import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/enums/parking_spot_status.dart';
import '../../domain/entities/parking_spot_entity.dart';
import '../bloc/parking/parking_bloc.dart';
import '../bloc/parking_spot_edit/parking_spot_edit_bloc.dart';
import 'parking_spot_editing/parking_spot_editing_widget.dart';

class ParkingCardItemWidget extends StatelessWidget {
  const ParkingCardItemWidget({
    super.key,
    required this.spot,
    required this.parkingSpotEditBloc,
    required this.parkingBloc,
  });

  final ParkingSpotEntity spot;
  final ParkingSpotEditBloc parkingSpotEditBloc;
  final ParkingBloc parkingBloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => editingParkingSpot(context),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Container(
                color: const Color(0xff82b3c5),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (spot.parkingSpotStatus ==
                        ParkingSpotStatus.AVAILABLE) ...[
                      Text(
                        'Disponível',
                        style: theme.textTheme.displayMedium,
                      )
                    ],
                    if (spot.parkingSpotStatus == ParkingSpotStatus.BUSY &&
                        spot.entryDate != null) ...[
                      const Icon(Icons.input_rounded),
                      const SizedBox(width: 10),
                      Text(
                        '${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(spot.entryDate!))}h',
                        style: theme.textTheme.displayMedium,
                      ),
                    ]
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xffeaf7fb),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_filled_outlined,
                            size: 34,
                            color:
                                spot.parkingSpotStatus == ParkingSpotStatus.BUSY
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ],
                      ),
                      if (spot.parkingSpotStatus == ParkingSpotStatus.BUSY &&
                          spot.nameOfCarOwner != null &&
                          spot.vehiclePlate != null) ...[
                        Text(
                          'Dono:',
                          style: theme.textTheme.displayMedium,
                        ),
                        Text(
                          spot.nameOfCarOwner!,
                          style: theme.textTheme.displaySmall,
                        ),
                        Text(
                          'Placa:',
                          style: theme.textTheme.displayMedium,
                        ),
                        Text(
                          spot.vehiclePlate!,
                          style: theme.textTheme.displaySmall,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              Container(
                color: const Color(0xffeaf7fb),
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '${spot.positionName}${spot.positionNumber}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color:
                              spot.parkingSpotStatus == ParkingSpotStatus.BUSY
                                  ? Colors.red
                                  : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editingParkingSpot(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      backgroundColor: Color(0xffafd8e3),
      builder: (BuildContext context) {
        return ParkingSpotEditingWidget(
          parkingSpotEditBloc: parkingSpotEditBloc,
          spotEditing: spot,
          parkingBloc: parkingBloc,
        );
      },
    );
  }
}
