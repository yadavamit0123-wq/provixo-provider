import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

import '../../app/generalImports.dart';
import '../screens/map/appMap/appMapTypes.dart';
import '../screens/map/appMap/appMapView.dart';

class MiniMapWidget extends StatefulWidget {
  const MiniMapWidget({
    super.key,
    required this.orderId,
    required this.handymanLat,
    required this.handymanLng,
    this.orderLat,
    this.orderLng,
    this.isHandymanMode = false,
  });

  final String orderId;
  final double handymanLat;
  final double handymanLng;
  final double? orderLat;
  final double? orderLng;
  final bool isHandymanMode;

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {
  BitmapDescriptor? _handymanIcon;
  BitmapDescriptor? _orderIcon;
  bool _iconsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconsLoaded) {
      _iconsLoaded = true;
      _loadIcons();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadIcons() async {
    final results = await Future.wait([
      _svgToMarker(AppAssets.handyman, size: 36),
      _svgToMarker(AppAssets.customerPin, size: 36),
    ]);
    if (!mounted) return;
    setState(() {
      _handymanIcon = results[0];
      _orderIcon = results[1];
    });
  }

  Future<BitmapDescriptor> _svgToMarker(
    String assetPath, {
    double size = 36,
  }) async {
    final accentColor = Theme.of(context).colorScheme.accentColor;
    final data = await rootBundle.load(assetPath);
    final loader = SvgStringLoader(utf8.decode(data.buffer.asUint8List()));
    final pictureInfo = await vg.loadPicture(loader, null);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(size / pictureInfo.size.width, size / pictureInfo.size.height);
    canvas.drawPicture(pictureInfo.picture);
    canvas.drawColor(accentColor, BlendMode.srcATop);
    pictureInfo.picture.dispose();
    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  static Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        decoration: BoxDecoration(
          color: Theme.of(fromHeroContext).colorScheme.secondaryColor,
          borderRadius: BorderRadius.lerp(
            BorderRadius.circular(12),
            BorderRadius.zero,
            direction == HeroFlightDirection.push
                ? animation.value
                : 1 - animation.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final handymanPos = AppLatLng(widget.handymanLat, widget.handymanLng);
    final hasOrder = widget.orderLat != null && widget.orderLng != null;
    final orderPos = hasOrder
        ? AppLatLng(widget.orderLat!, widget.orderLng!)
        : null;

    final initialCenter = hasOrder
        ? AppLatLng(
            (handymanPos.latitude + orderPos!.latitude) / 2,
            (handymanPos.longitude + orderPos.longitude) / 2,
          )
        : handymanPos;
    final initialZoom = hasOrder ? 12.0 : 14.0;

    final markers = <AppMapMarker>[
      AppMapMarker(
        id: 'mini_handyman',
        position: handymanPos,
        anchor: const Offset(0.5, 0.5),
        googleIcon:
            _handymanIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        osmChild: CustomSvgPicture(
          svgImage: AppAssets.handyman,
          color: Theme.of(context).colorScheme.accentColor,
          height: 36,
          width: 36,
        ),
      ),
      if (orderPos != null)
        AppMapMarker(
          id: 'mini_order',
          position: orderPos,
          googleIcon:
              _orderIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          osmChild: CustomSvgPicture(
            svgImage: AppAssets.customerPin,
            color: Theme.of(context).colorScheme.accentColor,
            height: 36,
            width: 36,
          ),
        ),
    ];

    final polylines = orderPos != null
        ? [
            AppMapPolyline(
              id: 'mini_track',
              points: [handymanPos, orderPos],
              color: Colors.blue,
              width: 3,
            ),
          ]
        : const <AppMapPolyline>[];

    return Hero(
      tag: 'live-tracking-map-${widget.orderId}',
      flightShuttleBuilder: _flightShuttle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: AppMapView(
                    liteMode: true,
                    initialCenter: initialCenter,
                    initialZoom: initialZoom,
                    markers: markers,
                    polylines: polylines,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    showOsmAttribution: false,
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.liveTracking,
                    arguments: widget.isHandymanMode
                        ? {
                            'orderId': widget.orderId,
                            'orderLat': widget.orderLat,
                            'orderLng': widget.orderLng,
                          }
                        : widget.orderId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
