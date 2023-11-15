// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums/parking_spot_status.dart';
import '../../../../shared/utils/toast_util.dart';
import '../../../../shared/widgets/buttons/pk_button_text_widget.dart';
import '../bloc/parking/parking_bloc.dart';
import '../bloc/parking/parking_event.dart';
import '../bloc/parking/parking_state.dart';
import '../bloc/parking_spot_edit/parking_spot_edit_bloc.dart';
import '../widgets/parking_card_item_widget.dart';

const PARKING_ROUTE_NAME = 'parking_page';

class ParkingPage extends StatefulWidget {
  ParkingPage({
    Key? key,
    required this.parkingBloc,
    required this.parkingSpotEditBloc,
  }) : super(key: key);

  final ParkingBloc parkingBloc;
  final ParkingSpotEditBloc parkingSpotEditBloc;

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  @override
  void initState() {
    widget.parkingBloc.add(GetParkingSpotsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff13333f),
      appBar: AppBar(
        title: const Text('Estacionamento'),
      ),
      body: BlocConsumer(
        bloc: widget.parkingBloc,
        listener: _listener,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, ParkingState state) {
    // final theme = Theme.of(context);

    if (state.status == ParkingStatus.SUCCESS &&
        state.parkingSpotList.isEmpty) {
      return _buildEmptySpot(context, state);
    }

    final busySpot = state.parkingSpotList
        .where((spot) => spot.parkingSpotStatus == ParkingSpotStatus.BUSY);

    final availableSpot = state.parkingSpotList
        .where((spot) => spot.parkingSpotStatus == ParkingSpotStatus.AVAILABLE);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xffeaf7fb),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PopupMenuButton<CurrentMenuItem>(
                initialValue: state.currentMenuItem,
                child: Text(
                  state.currentTextMenu ??
                      'Todas as vagas (${state.parkingSpotList.length})',
                ),
                onSelected: (CurrentMenuItem selectedMenu) => handleSetMenuItem(
                  selectedMenu: selectedMenu,
                  allSpot: state.parkingSpotList.length,
                  busySpot: busySpot.length,
                  availableSpot: availableSpot.length,
                ),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<CurrentMenuItem>>[
                  PopupMenuItem<CurrentMenuItem>(
                    value: CurrentMenuItem.ALL,
                    child: Text(
                      'Todas as vagas (${state.parkingSpotList.length})',
                    ),
                  ),
                  PopupMenuItem<CurrentMenuItem>(
                    value: CurrentMenuItem.BUSY,
                    child: Text(
                      'Vagas Ocupadas (${busySpot.length})',
                    ),
                  ),
                  PopupMenuItem<CurrentMenuItem>(
                    value: CurrentMenuItem.AVAILABLE,
                    child: Text(
                      'Vagas Disponíveis (${availableSpot.length})',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 210,
            ),
            padding: const EdgeInsets.all(15),
            itemCount: state.parkingSpotList.length,
            itemBuilder: (context, index) {
              return ParkingCardItemWidget(
                spot: state.parkingSpotList[index],
                parkingSpotEditBloc: widget.parkingSpotEditBloc,
                parkingBloc: widget.parkingBloc,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySpot(BuildContext context, ParkingState state) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Você ainda não tem vagas',
            style: theme.textTheme.displayMedium?.copyWith(color: Colors.white),
          ),
          PKButtonTextWidget(
            onPressed: () =>
                widget.parkingBloc.add(GenerateParkingSpotsEvent()),
            child: Text(
              'Gerar vagas',
            ),
          )
        ],
      ),
    );
  }

  void _listener(BuildContext context, ParkingState state) {
    if (state.status == ParkingStatus.FAILURE) {
      ToastUtil.showToast(
        'Ops...',
        state.messageFailure ?? '',
        backgroundColor: Colors.white,
      );
    }
  }

  void handleSetMenuItem({
    required CurrentMenuItem selectedMenu,
    required int availableSpot,
    required int busySpot,
    required int allSpot,
  }) {
    widget.parkingBloc.add(SetCurrentFilterMenuEvent(
      selectedMenu: selectedMenu,
      allSpot: allSpot,
      busySpot: busySpot,
      availableSpot: availableSpot,
    ));
  }
}
