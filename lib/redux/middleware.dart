import 'package:ghosts_on_the_train/models/app_state.dart';
import 'package:ghosts_on_the_train/redux/actions.dart';
import 'package:ghosts_on_the_train/services/api_service.dart';
import 'package:ghosts_on_the_train/services/device_service.dart';
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

    var nearbyStopsResponse = await apiService.getStopsByGeolocation(
        latitude: action.location.latitude,
        longitude: action.location.longitude);

    store.dispatch(ActionStoreNearbyStops(nearbyStops: nearbyStopsResponse));
  };
}
