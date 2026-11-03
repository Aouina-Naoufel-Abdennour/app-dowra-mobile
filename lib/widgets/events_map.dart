import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/colors.dart';

class MapPin {
  const MapPin({required this.lat, required this.lng, required this.label, this.onTap});

  final double lat;
  final double lng;
  final String label;
  final VoidCallback? onTap;
}

/// Carte OpenStreetMap avec des pastilles de prix (maquette 5) ; cadrée sur les points.
class EventsMap extends StatelessWidget {
  const EventsMap({super.key, required this.pins, this.interactive = true});

  final List<MapPin> pins;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final points = [for (final pin in pins) LatLng(pin.lat, pin.lng)];
    final options = points.length > 1
        ? MapOptions(initialCameraFit: CameraFit.coordinates(coordinates: points, padding: const EdgeInsets.all(48), maxZoom: 13))
        : MapOptions(initialCenter: points.isEmpty ? const LatLng(36.2, 3.5) : points.first, initialZoom: points.isEmpty ? 6 : 14);

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: options.initialCameraFit,
        initialCenter: options.initialCenter,
        initialZoom: options.initialZoom,
        interactionOptions: InteractionOptions(flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none),
      ),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dz.dowra.app'),
        MarkerLayer(markers: [
          for (final pin in pins)
            Marker(
              point: LatLng(pin.lat, pin.lng),
              width: 120,
              height: 36,
              child: Center(
                child: GestureDetector(
                  onTap: pin.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: DowraColors.gradient,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [BoxShadow(color: Color(0x591A0833), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Text(pin.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ),
            ),
        ]),
        const RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap')]),
      ],
    );
  }
}
