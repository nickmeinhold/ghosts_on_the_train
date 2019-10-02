import 'package:flutter/foundation.dart';
import 'package:ghosts_on_the_train/models/location.dart';
import 'package:ghosts_on_the_train/models/problem.dart';
import 'package:ptv_api_client/api.dart';
import 'package:ptv_api_client/model/v3_stops_by_distance_response.dart';

class Action {
  const Action(this.propsMap);
  Action.fromJson(Map<String, dynamic> json) : propsMap = json;
  final Map<String, dynamic> propsMap;
  Map<String, dynamic> toJson() => propsMap;
}

class ActionStoreNamedRoute extends Action {
  ActionStoreNamedRoute({@required this.routeName})
      : super(<String, Object>{'routeName': routeName});
  final String routeName;
}

class ActionStoreHome extends Action {
  ActionStoreHome({@required this.index})
      : super(<String, Object>{'index': index});
  final int index;
}

class ActionAddProblem extends Action {
  ActionAddProblem({@required this.problem})
      : super(<String, Object>{'problem': problem});
  final Problem problem;
}

class ActionObserveLocation extends Action {
  const ActionObserveLocation() : super(const <String, Object>{});
}

class ActionStoreLocation extends Action {
  ActionStoreLocation({@required this.location})
      : super(<String, Object>{'latitude': location});
  final Location location;
}

class ActionStoreNearbyStops extends Action {
  ActionStoreNearbyStops({@required this.nearbyStops})
      : super(<String, Object>{'nearbyStops': nearbyStops});
  final V3StopsByDistanceResponse nearbyStops;
}
