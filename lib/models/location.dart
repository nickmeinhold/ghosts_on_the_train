library built_location;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ghosts_on_the_train/models/serializers.dart';

part 'location.g.dart';

abstract class Location implements Built<Location, LocationBuilder> {
  double get latitude;
  double get longitude;
  DateTime get timestamp;

  Location._();

  factory Location([void updates(LocationBuilder b)]) = _$Location;

  Object toJson() {
    return json.encode(serializers.serializeWith(Location.serializer, this));
  }

  static Location fromJson(String jsonString) {
    return serializers.deserializeWith(
        Location.serializer, json.decode(jsonString));
  }

  static Serializer<Location> get serializer => _$locationSerializer;
}
