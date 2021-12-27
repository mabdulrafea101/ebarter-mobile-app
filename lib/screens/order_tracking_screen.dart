import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OrderTrackingScreen extends StatefulWidget {
  final double originLatitude;
  final double originLongitude;
  final double destLatitude;
  final double destLongitude;
  const OrderTrackingScreen({
    Key key,
    @required this.originLatitude,
    @required this.originLongitude,
    @required this.destLatitude,
    @required this.destLongitude,
  }) : super(key: key);

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   double _originLatitude = 6.5212402;
// // Starting point longitude
//   double _originLongitude = 3.3679965;
// // Destination latitude
//   double _destLatitude = 6.849660;
// // Destination Longitude
//   double _destLongitude = 3.648190;
// Markers to show points on the map
  Map<MarkerId, Marker> markers = {};

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  CameraPosition _kGooglePlex;

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.originLatitude, widget.originLongitude),
      zoom: 9.4746,
    );

    /// add origin marker origin marker
    _addMarker(
      LatLng(widget.destLatitude, widget.destLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(widget.originLatitude, widget.originLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Tracking Product',
            style: TextStyle(color: Colors.black45),
          ),
          backgroundColor: Colors.white,
        ),
        body: GoogleMap(
          // mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCpDGOMeGM7Ga0P3NEH7Asb97l5jBvJQgo",
      PointLatLng(widget.originLatitude, widget.originLongitude),
      PointLatLng(widget.destLatitude, widget.destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('${result.errorMessage};;;;;;;;;;;;;;;;;;');
    }
    _addPolyLine(polylineCoordinates);
  }
}
