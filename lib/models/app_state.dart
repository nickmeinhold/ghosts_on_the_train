library built_app_state;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ghosts_on_the_train/models/location.dart';
import 'package:ghosts_on_the_train/models/problem.dart';
import 'package:ghosts_on_the_train/models/serializers.dart';
import 'package:ptv_api_client/api.dart';
import 'package:ptv_api_client/model/v3_stops_by_distance_response.dart';

part 'app_state.g.dart';

/// [AppState] holds the state of the entire app.
///
/// [homeIndex] is an index for the current home page.
/// [problems] is a list of [Problem] objects that the app can observe and
/// deal with in whatever way is appropriate.
abstract class AppState implements Built<AppState, AppStateBuilder> {
  int get homeIndex;
  BuiltList<Problem> get problems;
  Location get location;
  V3StopsByDistanceResponse get nearbyStops;

  static AppState initialState() => AppState((b) => b
    ..homeIndex = 0
    ..problems = ListBuilder<Problem>()
    ..location.latitude = 0
    ..location.longitude = 0
    ..location.timestamp = DateTime.now().toUtc()
    ..nearbyStops.disruptions = MapBuilder<String, V3Disruption>()
    ..nearbyStops.status.health = 0
    ..nearbyStops.status.version = ''
    ..nearbyStops.stops = ListBuilder<V3StopGeosearch>());

  AppState._();

  factory AppState([void updates(AppStateBuilder b)]) = _$AppState;

  Object toJson() => serializers.serializeWith(AppState.serializer, this);

  static AppState fromJson(String jsonString) =>
      serializers.deserializeWith(AppState.serializer, json.decode(jsonString));

  static Serializer<AppState> get serializer => _$appStateSerializer;
}
