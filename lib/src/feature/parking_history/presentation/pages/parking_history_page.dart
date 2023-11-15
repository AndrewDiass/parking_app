import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../shared/utils/toast_util.dart';
import '../../../../shared/widgets/buttons/pk_button_text_widget.dart';
import '../../../parking/presentation/pages/parking_page.dart';
import '../bloc/parking_history/parking_history_bloc.dart';
import '../bloc/parking_history/parking_history_event.dart';
import '../bloc/parking_history/parking_history_state.dart';

const HISTORY_ROUTE_NAME = 'history_page';

class ParkingHistoryPage extends StatefulWidget {
  ParkingHistoryPage({
    Key? key,
    required this.parkingHistoryBloc,
  }) : super(key: key);

  final ParkingHistoryBloc parkingHistoryBloc;

  @override
  State<ParkingHistoryPage> createState() => _ParkingHistoryPageState();
}

class _ParkingHistoryPageState extends State<ParkingHistoryPage> {
  @override
  void initState() {
    widget.parkingHistoryBloc.add(GetParkingHistoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('Estacionamento'),
      ),
      body: BlocConsumer(
        bloc: widget.parkingHistoryBloc,
        listener: _listener,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, ParkingHistoryState state) {
    if ((state.status == ParkingHistoryStatus.SUCCESS &&
            state.parkingSpotList.isEmpty) ||
        state.status == ParkingHistoryStatus.FAILURE) {
      return _buildEmptySpot(context, state);
    }

    return ListView.separated(
      itemCount: state.parkingSpotList.length,
      separatorBuilder: (context, _) => Divider(
        height: 2,
      ),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
        color: Colors.white,
        child: Row(
          children: [
            Icon(
              Icons.directions_car_filled_outlined,
              size: 34,
              color: Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  richTextWidget(
                    firstText: 'Cliente: ',
                    secondText:
                        '${state.parkingSpotList[index].nameOfCarOwner}',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  richTextWidget(
                    firstText: 'Placa: ',
                    secondText: '${state.parkingSpotList[index].vehiclePlate}',
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextWidget(
                  firstText: 'Entrada: ',
                  secondText:
                      '${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(state.parkingSpotList[index].entryDate!))}h',
                ),
                SizedBox(
                  height: 5,
                ),
                richTextWidget(
                  firstText: 'Saída: ',
                  secondText:
                      '${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(state.parkingSpotList[index].departureDate!))}h',
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget richTextWidget({
    required String firstText,
    required String secondText,
  }) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          TextSpan(
            text: secondText,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 15, color: Color(0xff13333f)),
          ),
        ],
      ),
    );
  }

  void _listener(BuildContext context, ParkingHistoryState state) {
    if (state.status == ParkingHistoryStatus.FAILURE) {
      ToastUtil.showToast(
        'Ops...',
        state.messageFailure ?? '',
        backgroundColor: Colors.white,
      );
    }
  }

  Widget _buildEmptySpot(BuildContext context, ParkingHistoryState state) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Parece que você ainda não tem histórico.',
            style: theme.textTheme.displayMedium?.copyWith(color: Colors.white),
          ),
          PKButtonTextWidget(
            onPressed: () => Modular.to.pushNamed('/$PARKING_ROUTE_NAME'),
            child: Text(
              'Comece a usar agora',
            ),
          )
        ],
      ),
    );
  }
}
