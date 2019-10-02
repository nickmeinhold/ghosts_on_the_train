import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghosts_on_the_train/models/app_state.dart';
import 'package:ghosts_on_the_train/redux/actions.dart';
import 'package:ghosts_on_the_train/redux/middleware.dart';
import 'package:ghosts_on_the_train/redux/reducers.dart';
import 'package:ghosts_on_the_train/services/api_service.dart';
import 'package:ghosts_on_the_train/services/device_service.dart';
import 'package:ghosts_on_the_train/utilities/mocks.dart';
import 'package:ghosts_on_the_train/widgets/app.dart';
import 'package:ptv_api_client/api.dart';
import 'package:ptv_api_client/api/routes_api.dart';
import 'package:ptv_api_client/api/stops_api.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

void main() async {
  final RemoteDevToolsMiddleware remoteDevtools =
      RemoteDevToolsMiddleware(iphone_ip);
  await remoteDevtools.connect();

  final departuresApi = DeparturesApi();
  final directionsApi = DirectionsApi();
  final disruptionsApi = DisruptionsApi();
  final outletsApi = OutletsApi();
  final patternsApi = PatternsApi();
  final routesApi = RoutesApi();
  final routeTypesApi = RouteTypesApi();
  final runsApi = RunsApi();
  final searchApi = SearchApi();
  final stopsApi = StopsApi();

  final ApiService apiService = ApiService(
    departuresApi,
    directionsApi,
    disruptionsApi,
    outletsApi,
    patternsApi,
    routesApi,
    routeTypesApi,
    runsApi,
    searchApi,
    stopsApi,
  );
  final DeviceService deviceService = DeviceService(Geolocator());

  final store = DevToolsStore<AppState>(
    appStateReducer,
    middleware: [
      remoteDevtools,
      ...createMiddlewares(apiService, deviceService)
    ],
    initialState: AppState.initialState(),
  );

  remoteDevtools.store = store;

  store.dispatch(const ActionObserveLocation());

  runApp(MyApp(store));
}
