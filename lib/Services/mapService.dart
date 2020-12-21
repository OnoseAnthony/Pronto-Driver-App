import 'package:fronto_rider/Models/directions.dart';
import 'package:fronto_rider/Services/requestAssistant.dart';
import 'package:fronto_rider/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantMethods {
  static Future<Directions> getDirections(
      LatLng pickUp, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}&destination=${destination.latitude},${destination.longitude}&key=$kMapKey";

    var _response = await RequestAssistant.getRequest(url);

    if (_response == 'Failed') return null;

    Directions directions = Directions(
      distanceValue: _response["routes"][0]["legs"][0]["distance"]["value"],
      durationValue: _response["routes"][0]["legs"][0]["duration"]["value"],
      distanceText: _response["routes"][0]["legs"][0]["distance"]["text"],
      durationText: _response["routes"][0]["legs"][0]["duration"]["text"],
      encodedPoints: _response["routes"][0]["overview_polyline"]["points"],
    );

    return directions;
  }
}
