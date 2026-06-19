import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapvina_gl/mapvina_gl.dart';
import 'mapvina_util.dart';

class MapvinaClusterSource {
  //================MAP CHART LAYER==============//
  Future<void>? addMapvinaClusterMap(
      {required MapvinaMapController? mapController, required String sourceId, required Map<String, dynamic> dataMap, required String keyChartName}) async {
    final keyChartImageCircleRate = keyChartName + "_chart_image_circle_rate";
    final keyChartCircleRate = keyChartName + "_chart_circle_rate";
    final keyChartChildren = keyChartName + "_chart_circle_children";
    final keyChartCircleCount = keyChartName + "_chart_circle_count";
    if (dataMap.isNotEmpty) {
      dataMap["type"] = "FeatureCollection";
      await addClusteredPointSource(mapController: mapController, sourceId: sourceId, data: dataMap);
      await addClusteredPointLayers(
          mapController: mapController,
          dataMap: dataMap,
          sourceId: sourceId,
          keyChartImageCircleRate: keyChartImageCircleRate,
          keyChartCircleRate: keyChartCircleRate,
          keyChartChildren: keyChartChildren,
          keyChartCircleCount: keyChartCircleCount);
    }
  }

  Future<void>? addClusteredPointSource({required MapvinaMapController? mapController, required String sourceId, required Map<String, dynamic>? data}) async {
    final sourceIds = await mapController?.getSourceIds();
    if (sourceIds?.contains(sourceId) == true) {
      if (data != null) {
        return mapController?.setGeoJsonSource(sourceId, data);
      }
    } else {
      return mapController?.addSource(
          sourceId,
          GeojsonSourceProperties(
            data: data,
            cluster: true,
          ));
    }
  }

  Future<void> addClusteredPointLayers(
      {required MapvinaMapController? mapController,
      required Map<String, dynamic> dataMap,
      required String sourceId,
      required String keyChartImageCircleRate,
      required String keyChartCircleRate,
      required String keyChartChildren,
      required String keyChartCircleCount}) async {
    await addImageCircleRate(mapController: mapController, keyLayer: keyChartImageCircleRate);
    await addChartCircleRate(mapController: mapController, sourceId: sourceId, keyLayer: keyChartCircleRate, keyImage: keyChartImageCircleRate);
    await addChartChildren(mapController: mapController, sourceId: sourceId, keyLayer: keyChartChildren);
    await addCircleCount(mapController: mapController, sourceId: sourceId, keyLayer: keyChartCircleCount);
  }

  //================MAP CHART LAYER==============//

  //================MAP CHART ADD==============//
  Future<void> addImageCircleRate({required MapvinaMapController? mapController, required String keyLayer}) async {
    final svgBytes = await MapvinaUtils.createDonutChartPng(MapvinaUtils.segments);
    if (svgBytes != null) {
      await removeLayer(mapController: mapController, keyLayer: keyLayer);
      await mapController?.addImage(keyLayer, svgBytes);
    }
  }

  Future<void> addChartCircleRate(
      {required MapvinaMapController? mapController, required String sourceId, required String keyLayer, required String keyImage}) async {
    const pointKey = "point_count";
    await removeLayer(mapController: mapController, keyLayer: keyLayer);
    await mapController?.addSymbolLayer(
        sourceId,
        keyLayer,
        SymbolLayerProperties(
          textHaloWidth: 1,
          textSize: 6,
          iconImage: keyImage,
          iconSize: [
            Expressions.step,
            [Expressions.get, pointKey],
            0.8,
            100,
            1.0,
            400,
            1.0,
            600,
            1.2,
            800,
            1.2,
            1000,
            1.4
          ],
          iconAllowOverlap: true,
        ),
        filter: [Expressions.has, pointKey]);
  }

  Future<void> addChangeChartCircleRate(
      {required MapvinaMapController? mapController,
      required String sourceId,
      required String keyLayer,
      required String keyImage,
      required String suggest}) async {
    await removeLayer(mapController: mapController, keyLayer: keyLayer);
    await mapController?.addLayer(
        sourceId,
        keyLayer,
        SymbolLayerProperties(
          iconImage: keyImage,
          iconAllowOverlap: true,
        ),
        filter: [
          '==',
          ['get', 'suggest'],
          suggest,
        ]);
  }

  Future<void> addCircleCount({required MapvinaMapController? mapController, required String sourceId, required String keyLayer}) async {
    const pointKey = "point_count";
    const pointAbbreviated = "point_count_abbreviated";
    const font = "Roboto Regular";
    await removeLayer(mapController: mapController, keyLayer: keyLayer);
    await mapController?.addSymbolLayer(sourceId, keyLayer, const SymbolLayerProperties(textField: [Expressions.get, pointAbbreviated], textFont: [font]),
        filter: [Expressions.has, pointKey]);
  }

  Future<void> addChartChildren({required MapvinaMapController? mapController, required String sourceId, required String keyLayer}) async {
    const pointKey = "point_count";
    await removeLayer(mapController: mapController, keyLayer: keyLayer);
    await mapController?.addCircleLayer(
        sourceId,
        keyLayer,
        CircleLayerProperties(circleColor: [
          'match',
          ['get', 'mag'],
          1,
          MapvinaUtils.colors[0],
          2,
          MapvinaUtils.colors[1],
          3,
          MapvinaUtils.colors[2],
          4,
          MapvinaUtils.colors[3],
          5,
          MapvinaUtils.colors[4],
          100,
          MapvinaUtils.colors[5],
          101,
          MapvinaUtils.colors[6],
          102,
          MapvinaUtils.colors[7],
          103,
          MapvinaUtils.colors[8],
          200,
          MapvinaUtils.colors[9],
          201,
          MapvinaUtils.colors[10],
          202,
          MapvinaUtils.colors[11],
          203,
          MapvinaUtils.colors[12],
          204,
          MapvinaUtils.colors[13],
          205,
          MapvinaUtils.colors[14],
          MapvinaUtils.colors[15],
        ], circleRadius: 10, circleStrokeWidth: 1, circleStrokeColor: "#FFA500"),
        filter: [
          "!",
          [Expressions.has, pointKey]
        ]);
  }

  Future<void> removeLayer({required MapvinaMapController? mapController, required String keyLayer}) async {
    final sourceIds = await mapController?.getLayerIds();
    if (sourceIds?.contains(keyLayer) == true) {
      await mapController?.removeLayer(keyLayer);
    }
  }

  // Map<String, List<Map<String, dynamic>>> groupChartCircleData({required List<dynamic> dataMap}) {
  //   Map<String, List<Map<String, dynamic>>> groupedFeatures = {};
  //   for (Map<String, dynamic> feature in dataMap) {
  //     String suggest = feature['properties']['suggest'];
  //     if (groupedFeatures.containsKey(suggest)) {
  //       groupedFeatures[suggest]?.add(feature);
  //     } else {
  //       groupedFeatures[suggest] = [feature];
  //     }
  //   }
  //   return groupedFeatures;
  // }

  Future<void> addChangeChartCircleData({required MapvinaMapController? mapController, required String sourceId, required List<dynamic> dataMap}) async {
    if (dataMap.isNotEmpty == true) {
      // final groupedFeatures = groupChartCircleData(dataMap: dataMap);
      // groupedFeatures.forEach((String suggest, List<Map<String, dynamic>> group) async {
      //   double percentage = (group.length / dataMap.length) * 100;
      //   Map<String, double> percentages = {};
      //   percentages[suggest] = percentage;
      //   for (String suggest in percentages.keys) {
      //     String keyLayer = createKeyLayer(suggest);
      //     String keyImage = createImageId(suggest);
      //     double percentage = percentages[suggest]!;
      //     var rnd = Random();
      //     Map<Color, double> segment = {MapvinaUtils.colors[rnd.nextInt(4)]: percentage / 100}; // Chỉ sử dụng một màu sắc cho mỗi biểu đồ
      //     Uint8List? chartPng = await MapvinaUtils.createDonutChartPng(segment);
      //     if (chartPng != null) {
      //       await mapController?.addImage(keyLayer, chartPng);
      //       addChangeChartCircleRate(sourceId: sourceId, mapController: mapController, keyLayer: keyLayer, keyImage: keyImage, suggest: suggest);
      //     }
      //   }
      // });
      for (Map<String, dynamic> feature in dataMap) {
        var rnd = Random();
        String id = feature['properties']['id'] ?? rnd.nextInt(1000);
        String keyLayer = createKeyLayer(id);
        // Map<Color, double> segment = {MapvinaUtils.colors[rnd.nextInt(4)]: percentage / 100};
      }
    }
  }

  String createKeyLayer(String id) {
    return 'pet_chart_keylayer_circle_rate$id';
  }

  String createImageId(String suggest) {
    return 'pet_chart_image_circle_rate$suggest';
  }

  //================MAP CHART ADD==============//
}
