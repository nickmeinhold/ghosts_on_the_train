import 'package:ghosts_on_the_train/models/app_state.dart';
import 'package:ghosts_on_the_train/redux/actions.dart';
import 'package:ghosts_on_the_train/services/api_service.dart';
import 'package:ghosts_on_the_train/services/device_service.dart';
import 'package:ptv_api_client/model/v3_stop_geosearch.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMiddlewares(
    ApiService apiService, DeviceService deviceService) {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, ActionObserveLocation>(
      _getLocation(deviceService),
    ),
    TypedMiddleware<AppState, ActionStoreLocation>(
      _getStopsByLocation(apiService),
    ),
    TypedMiddleware<AppState, ActionGetStopDepartures>(
      _getStopDepartures(apiService),
    ),
  ];
}

void Function(Store<AppState> store, ActionObserveLocation action,
    NextDispatcher next) _getLocation(DeviceService deviceService) {
  return (Store<AppState> store, ActionObserveLocation action,
      NextDispatcher next) async {
    next(action);

    // deviceService.locationStream.listen(store.dispatch);

    Action locationAction = await deviceService.requestLocationAction();

    store.dispatch(locationAction);
  };
}

void Function(
        Store<AppState> store, ActionStoreLocation action, NextDispatcher next)
    _getStopsByLocation(ApiService apiService) {
  return (Store<AppState> store, ActionStoreLocation action,
      NextDispatcher next) async {
    next(action);

    final nearbyStopsResponse = await apiService.getStopsByGeolocation(
        latitude: action.location.latitude,
        longitude: action.location.longitude);

    // dispatch actions to get departures for each stop
    for (V3StopGeosearch stop in nearbyStopsResponse.stops) {
      store.dispatch(ActionGetStopDepartures(
          stopId: stop.stopId, routeType: stop.routeType));
    }

    store.dispatch(ActionStoreNearbyStops(nearbyStops: nearbyStopsResponse));
  };
}

void Function(Store<AppState> store, ActionGetStopDepartures action,
    NextDispatcher next) _getStopDepartures(ApiService apiService) {
  return (Store<AppState> store, ActionGetStopDepartures action,
      NextDispatcher next) async {
    next(action);

    var response = await apiService.getDeparturesForStop(
        stopId: action.stopId,
        routeType: action.routeType,
        maxResults: 5,
        expand: ['3']);

    store.dispatch(
        ActionStoreStopDepartures(stopId: action.stopId, response: response));
  };
}
