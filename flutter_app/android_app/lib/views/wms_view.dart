import 'package:flutter_map/flutter_map.dart';

class WmsView {
  static final WMSTileLayerOptions wmsLayer1 = WMSTileLayerOptions(
    baseUrl: 'https://ows.terrestris.de/osm/service?',
    layers: ['OSM-WMS'],
    format: 'image/png',
    transparent: true,
  );

  static final WMSTileLayerOptions wmsLayer2 = WMSTileLayerOptions(
    baseUrl: 'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi?',
    layers: ['MODIS_Terra_CorrectedReflectance_TrueColor'],
    format: 'image/png',
    transparent: true,
  );
}
