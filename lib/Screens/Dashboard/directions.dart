import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fronto_rider/Models/directions.dart';
import 'package:fronto_rider/Services/mapService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionScreen extends StatefulWidget {
  var pickUpLat, pickUpLong, pickUpPlaceName;
  var destinationLat, destinationLong, destinationPlaceName;

  DirectionScreen(
      {@required this.pickUpLat,
      @required this.pickUpLong,
      @required this.pickUpPlaceName,
      @required this.destinationLat,
      @required this.destinationLong,
      @required this.destinationPlaceName});

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController _newGoogleMapController;
  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  LatLngBounds directionBounds;
  Set<Marker> mapMarkers = {};
  Set<Circle> mapMarkerCircles = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  @override
  void initState() {
    _displayDirectionsOnMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        trafficEnabled: true,
        zoomGesturesEnabled: true,
        polylines: polyLineSet,
        markers: mapMarkers,
        circles: mapMarkerCircles,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController.complete(controller);
          _newGoogleMapController = controller;
        },
      ),
    );
  }

  _displayDirectionsOnMap() async {
    var pickUpLatLng =
        LatLng(double.parse(widget.pickUpLat), double.parse(widget.pickUpLong));
    var destinationLatLng = LatLng(double.parse(widget.destinationLat),
        double.parse(widget.destinationLong));

    Directions directionInfo =
        await AssistantMethods.getDirections(pickUpLatLng, destinationLatLng);

    //convert encoded points to polyLine

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePoints =
        polylinePoints.decodePolyline(directionInfo.encodedPoints);

    polyLineCoordinates.clear();
    if (decodedPolyLinePoints.isNotEmpty) {
      decodedPolyLinePoints.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyLine = Polyline(
        color: Colors.black,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLineCoordinates,
        width: 3,
        startCap: Cap.squareCap,
        endCap: Cap.buttCap,
        geodesic: true,
      );

      polyLineSet.add(polyLine);
    });

    if (pickUpLatLng.latitude > destinationLatLng.latitude &&
        pickUpLatLng.longitude > destinationLatLng.longitude)
      directionBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickUpLatLng);
    else if (pickUpLatLng.longitude > destinationLatLng.longitude)
      directionBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickUpLatLng.longitude));
    else if (pickUpLatLng.latitude > destinationLatLng.latitude)
      directionBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
          northeast:
              LatLng(pickUpLatLng.latitude, destinationLatLng.longitude));
    else
      directionBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: destinationLatLng);

    _newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(directionBounds, 70));

    Marker pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(
          title: '${widget.pickUpPlaceName} ${directionInfo.durationText}',
          snippet: "pickUp Location ${directionInfo.distanceText}"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker destinationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: '${widget.destinationPlaceName} ${directionInfo.durationText}',
          snippet: "Destination Location ${directionInfo.distanceText}"),
      position: destinationLatLng,
      markerId: MarkerId("destinationId"),
    );

    Circle pickUpMarkerCircle = Circle(
      fillColor: Colors.white,
      center: pickUpLatLng,
      radius: 10,
      strokeWidth: 3,
      strokeColor: Colors.white,
      circleId: CircleId("pickUpId"),
    );

    Circle destinationMarkerCircle = Circle(
      fillColor: Colors.white,
      center: destinationLatLng,
      radius: 10,
      strokeWidth: 3,
      strokeColor: Colors.white,
      circleId: CircleId("destinationId"),
    );

    setState(() {
      mapMarkers.add(pickUpMarker);
      mapMarkers.add(destinationMarker);
      mapMarkerCircles.add(pickUpMarkerCircle);
      mapMarkerCircles.add(destinationMarkerCircle);
    });
  }
}
