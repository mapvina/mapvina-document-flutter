import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapvina/constants.dart';
import 'package:mapvina_gl/mapvina_gl.dart';
import 'package:mapvina/utils/map_utils.dart';

class FeatureViewPage extends StatefulWidget {
  @override
  State<FeatureViewPage> createState() => _FeatureViewPageState();
}

class _FeatureViewPageState extends State<FeatureViewPage> {
  final initialLocation = const LatLng(16.25658, 106.31679);

  final double defaultZoomRate = 4.8;

  MapVinaMapController? mapController;

  String countryId = "vn";

  @override
  void initState() {
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    countryId = prefs.getString('country') ?? 'vn';
  }

  @override
  Widget build(BuildContext context) {
    return MapVinaMap(
      styleString: MapHelper.getUrlStyle(countryId),
      compassEnabled: true,
      tiltGesturesEnabled: true,
      scrollGesturesEnabled: true,
      initialCameraPosition: const CameraPosition(target: LatLng(15.7146441, 106.401633), zoom: 4.8),
      onMapCreated: _onMapCreated,
      onMapClick: _onMapClick,
      onMapIdle: () {},
      onCameraIdle: _onCameraIdleCallback,
      trackCameraPosition: true,
    );
  }

  void _onMapCreated(MapVinaMapController controller) async {
    mapController = controller;
  }

  void _onMapClick(Point<double> point, LatLng coordinates) async {}

  Future<void> _onCameraIdleCallback() async {}
}
