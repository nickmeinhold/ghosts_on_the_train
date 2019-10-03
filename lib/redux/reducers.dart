import 'package:ghosts_on_the_train/models/app_state.dart';
import 'package:ghosts_on_the_train/redux/actions.dart';
import 'package:redux/redux.dart';

/// Reducer
final AppState Function(AppState, dynamic) appStateReducer =
    combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, ActionStoreHome>(_storeHome),
  TypedReducer<AppState, ActionAddProblem>(_addProblem),
  TypedReducer<AppState, ActionStoreLocation>(_storeLocation),
  TypedReducer<AppState, ActionStoreNearbyStops>(_storeNearbyStops),
  TypedReducer<AppState, ActionStoreStopDepartures>(_storeStopDepartures),
]);

//
AppState _storeHome(AppState state, ActionStoreHome action) =>
    state.rebuild((b) => b..homeIndex = action.index);

AppState _addProblem(AppState state, ActionAddProblem action) =>
    state.rebuild((b) => b..problems.add(action.problem));

AppState _storeLocation(AppState state, ActionStoreLocation action) =>
    state.rebuild((b) => b
      ..location.latitude = action.location.latitude
      ..location.longitude = action.location.longitude
      ..location.timestamp = action.location.timestamp);

AppState _storeNearbyStops(AppState state, ActionStoreNearbyStops action) =>
    state.rebuild((b) => b..nearbyStops = action.nearbyStops.toBuilder());

AppState _storeStopDepartures(
        AppState state, ActionStoreStopDepartures action) =>
    state.rebuild((b) => b
      ..stopDepartures.updateValue(action.stopId, (response) => action.response,
          ifAbsent: () => action.response));
