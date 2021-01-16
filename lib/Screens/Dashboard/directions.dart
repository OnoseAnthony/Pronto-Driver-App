import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fronto_rider/Models/directions.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/Services/mapService.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/customListTile.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionScreen extends StatefulWidget {
  var pickUpLat, pickUpLong, pickUpPlaceName;
  var destinationLat, destinationLong, destinationPlaceName;
  String docID,
      orderID,
      userID,
      receiverName,
      receiverPhone,
      receiverImage,
      itemName,
      itemImage;

  DirectionScreen({
    @required this.pickUpLat,
    @required this.pickUpLong,
    @required this.pickUpPlaceName,
    @required this.destinationLat,
    @required this.destinationLong,
    @required this.destinationPlaceName,
    @required this.docID,
    @required this.orderID,
    @required this.userID,
    @required this.receiverName,
    @required this.receiverPhone,
    @required this.receiverImage,
    @required this.itemName,
    @required this.itemImage,
  });

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
  BitmapDescriptor markerIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.072264, 7.491302),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/images/truck1.png')
        .then((onValue) {
      markerIcon = onValue;
    });

    _displayDirectionsOnMap();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          trafficEnabled: false,
          zoomGesturesEnabled: true,
          polylines: polyLineSet,
          markers: mapMarkers,
          circles: mapMarkerCircles,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
            _newGoogleMapController = controller;
          },
        ),
        Positioned(
          top: 0.0,
          left: 8,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: kWhiteColor),
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  getIcon(Icons.arrow_back, 25, Colors.black),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
            padding: EdgeInsets.only(
                top: size * 0.02, left: 40, right: 40, bottom: size * 0.01),
            height: size * 0.42,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.25,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCustomListTile(
                    buildContainerImage(widget.receiverImage),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitlenSubtitleText(
                              widget.receiverName,
                              Colors.black,
                              16,
                              FontWeight.normal,
                              TextAlign.start,
                              null),
                          SizedBox(
                            height: 8,
                          ),
                          buildTitlenSubtitleText(
                              widget.destinationPlaceName,
                              Colors.grey[500],
                              12,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.visible),
                        ],
                      ),
                    ),
                    null,
                    20,
                    false),
                InkWell(
                  onTap: () {
                    launch("tel://${widget.receiverPhone}");
                  },
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xFF27AE60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getIcon(Icons.phone, 25.0, kWhiteColor),
                        Text(
                          'CALL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: kWhiteColor,
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(),
                buildCustomListTile(
                    buildContainerImage(widget.itemImage),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitlenSubtitleText(widget.itemName, Colors.black,
                              16, FontWeight.normal, TextAlign.start, null),
                          SizedBox(
                            height: 8,
                          ),
                          buildTitlenSubtitleText(
                              widget.pickUpPlaceName,
                              Colors.grey[500],
                              12,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.visible),
                        ],
                      ),
                    ),
                    null,
                    20,
                    false),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => NavigationLoader(context),
                    );

                    bool isUpdated = await DatabaseService(
                            firebaseUser: AuthService().getCurrentUser(),
                            context: context)
                        .updateOrderInfo('PENDING', widget.docID, widget.userID,
                            widget.orderID);

                    if (isUpdated) {
                      Navigator.pop(context);

                      showToast(
                          context,
                          'Delivery confirmation completed successfully',
                          kPrimaryColor,
                          false);
                    } else {
                      Navigator.pop(context);

                      showToast(context, 'Error occurred!!', kErrorColor, true);
                    }
                  },
                  child: buildSubmitButton(
                    'CONFIRM DELIVERY',
                    5.0,
                    false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        color: kPrimaryColor,
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
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: '${widget.pickUpPlaceName} ${directionInfo.durationText}',
          snippet: "pickUp Location ${directionInfo.distanceText}"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker destinationMarker = Marker(
      icon: markerIcon,
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
