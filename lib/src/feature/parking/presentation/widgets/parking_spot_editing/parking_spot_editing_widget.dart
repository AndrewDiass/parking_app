import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/parking_spot_status.dart';
import '../../../../../shared/utils/toast_util.dart';
import '../../../../../shared/widgets/textFormField/pk_text_form_field_widget.dart';
import '../../../domain/entities/parking_spot_entity.dart';
import '../../bloc/parking/parking_bloc.dart';
import '../../bloc/parking/parking_event.dart';
import '../../bloc/parking_spot_edit/parking_spot_edit_bloc.dart';
import '../../bloc/parking_spot_edit/parking_spot_edit_event.dart';
import '../../bloc/parking_spot_edit/parking_spot_edit_state.dart';

class ParkingSpotEditingWidget extends StatefulWidget {
  const ParkingSpotEditingWidget({
    super.key,
    required this.spotEditing,
    required this.parkingSpotEditBloc,
    required this.parkingBloc,
  });

  final ParkingSpotEntity spotEditing;
  final ParkingSpotEditBloc parkingSpotEditBloc;
  final ParkingBloc parkingBloc;

  @override
  State<ParkingSpotEditingWidget> createState() =>
      _ParkingSpotEditingWidgetState();
}

class _ParkingSpotEditingWidgetState extends State<ParkingSpotEditingWidget> {
  final _formKey = GlobalKey<FormState>();
  final nameOfCarOwnerTextController = TextEditingController();
  final vehiclePlateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.spotEditing.nameOfCarOwner != null &&
        widget.spotEditing.vehiclePlate != null) {
      nameOfCarOwnerTextController.text = widget.spotEditing.nameOfCarOwner!;
      vehiclePlateTextController.text = widget.spotEditing.vehiclePlate!;
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    nameOfCarOwnerTextController.dispose();
    vehiclePlateTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener(
      bloc: widget.parkingSpotEditBloc,
      listener: _listener,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Editar vaga',
                        style: theme.textTheme.displayMedium
                            ?.copyWith(color: Color(0xff13333f)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Dono do veiculo',
                        style: theme.textTheme.displaySmall
                            ?.copyWith(color: Color(0xff13333f)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PKTextFormFieldWidget(
                        controller: nameOfCarOwnerTextController,
                        validatorText: 'Preencha o nome do dono do veículo',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Placa do veiculo',
                        style: theme.textTheme.displaySmall
                            ?.copyWith(color: Color(0xff13333f)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PKTextFormFieldWidget(
                        controller: vehiclePlateTextController,
                        validatorText: 'Preencha placa do veículo',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Estado da vaga',
                        style: theme.textTheme.displayMedium
                            ?.copyWith(color: Color(0xff13333f)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: const Text('Cancelar'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: Text(
                              widget.spotEditing.parkingSpotStatus ==
                                      ParkingSpotStatus.AVAILABLE
                                  ? 'Dar entrada'
                                  : 'Dar saída',
                            ),
                            onPressed: handleSubmit,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, ParkingSpotEditState state) {
    if (state.status == ParkingSpotEditStatus.ENTRY_SUCCESS) {
      widget.parkingBloc.add(GetParkingSpotsEvent());
      Navigator.pop(context);
    }

    if (state.status == ParkingSpotEditStatus.EXIT_SUCCESS) {
      widget.parkingBloc.add(GetParkingSpotsEvent());
      if (state.parkignSpotToSave != null) {
        widget.parkingBloc
            .add(SaveToHistoryEvent(parkingSpot: state.parkignSpotToSave!));
      }
      Navigator.pop(context);
    }

    if (state.status == ParkingSpotEditStatus.FAILURE) {
      ToastUtil.showToast(
        'Ops...',
        'Desculpe, não conseguimos executar essa ação.',
        backgroundColor: Colors.white,
      );
      Navigator.pop(context);
    }
  }

  void handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return ToastUtil.showToast(
        'Ops...',
        'Preencha os campos corretamente',
        backgroundColor: Colors.white,
      );
    }

    if (widget.spotEditing.parkingSpotStatus == ParkingSpotStatus.AVAILABLE) {
      handleCheckInTheVehicle();
    } else if (widget.spotEditing.parkingSpotStatus == ParkingSpotStatus.BUSY) {
      handleCheckOutTheVehicle();
    }
  }

  void handleCheckInTheVehicle() {
    widget.parkingSpotEditBloc.add(
      CheckInTheVehicleEvent(
        parkingSpot: ParkingSpotEntity(
          id: widget.spotEditing.id,
          positionName: widget.spotEditing.positionName,
          positionNumber: widget.spotEditing.positionNumber,
          nameOfCarOwner: nameOfCarOwnerTextController.text,
          vehiclePlate: vehiclePlateTextController.text,
          parkingSpotStatus: ParkingSpotStatus.BUSY,
          entryDate: DateTime.now().millisecondsSinceEpoch,
          createdAt: widget.spotEditing.createdAt,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  void handleCheckOutTheVehicle() {
    widget.parkingSpotEditBloc.add(
      CheckOutTheVehicleEvent(
        parkingSpotId: widget.spotEditing.id,
      ),
    );
  }
}
