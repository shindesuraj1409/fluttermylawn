import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/rainfall_track_widget/lost_connection_widget.dart';
import 'package:my_lawn/widgets/rainfall_track_widget/rainfall_track_card_widget.dart';

class RainfallTrackWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RainfallTrackWidgetState();
}

class _RainfallTrackWidgetState extends State<RainfallTrackWidget> {
  final WaterBloc _WaterBloc = registry<WaterBloc>();
  String _customerId;
  String _zipCode;

  @override
  void initState() {
    super.initState();
    _customerId = registry<AuthenticationBloc>().state.user.customerId;
    _zipCode =
        registry<AuthenticationBloc>().state.lawnData?.lawnAddress?.zip ?? '';
    _getWeatherData();
  }

  void _getWeatherData() {
    _WaterBloc.add(GetWaterDataEvent(_customerId, _zipCode));
  }

  void _refreshWeatherData() {
    _WaterBloc.add(RefreshWaterDataEvent(_customerId, _zipCode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      cubit: _WaterBloc,
      builder: (context, state) {
        switch (state.status) {
          case WaterStatus.refreshing:
          case WaterStatus.loaded:
            return RainfallTrackCardWidget(
              key: Key('weather_data_loaded_widget'),
              getWeatherData: _refreshWeatherData,
              zipCode: _zipCode,
            );
          case WaterStatus.error:
            return LostConnectionWidget(retry: _getWeatherData);
          default:
            return SizedBox(
              height: 296.0,
              child: Center(
                child: ProgressSpinner(),
              ),
            );
        }
      },
    );
  }
}
