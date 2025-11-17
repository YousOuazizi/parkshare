import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_theme.dart';

class GoogleMapWidget extends StatefulWidget {
  final List<ParkingMarker> parkings;
  final Function(String)? onParkingTap;
  final LatLng? initialPosition;

  const GoogleMapWidget({
    super.key,
    required this.parkings,
    this.onParkingTap,
    this.initialPosition,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Paris par défaut
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _createMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Déplacer la caméra vers la position actuelle
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _createMarkers() {
    _markers = widget.parkings.map((parking) {
      return Marker(
        markerId: MarkerId(parking.id),
        position: parking.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          parking.isAvailable
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: parking.name,
          snippet: '€${parking.price}/h - ${parking.distance}',
          onTap: () {
            if (widget.onParkingTap != null) {
              widget.onParkingTap!(parking.id);
            }
          },
        ),
      );
    }).toSet();
  }

  @override
  void didUpdateWidget(GoogleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parkings != widget.parkings) {
      _createMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition ?? _currentPosition,
            zoom: 14.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: (CameraPosition position) {
            // TODO: Charger les parkings dans la zone visible
          },
        ),

        // Bouton ma position
        Positioned(
          bottom: 100,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: _goToCurrentLocation,
            child: _isLoadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  )
                : const Icon(
                    Icons.my_location_rounded,
                    color: AppTheme.primaryColor,
                  ),
          ),
        ),

        // Bouton zoom +
        Positioned(
          bottom: 160,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.zoomIn());
            },
            child: const Icon(
              Icons.add_rounded,
              color: AppTheme.primaryColor,
            ),
          ),
        ),

        // Bouton zoom -
        Positioned(
          bottom: 220,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.zoomOut());
            },
            child: const Icon(
              Icons.remove_rounded,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _goToCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() => _isLoadingLocation = true);
    await _getCurrentLocation();
    setState(() => _isLoadingLocation = false);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ParkingMarker {
  final String id;
  final String name;
  final LatLng position;
  final double price;
  final String distance;
  final bool isAvailable;

  ParkingMarker({
    required this.id,
    required this.name,
    required this.position,
    required this.price,
    required this.distance,
    this.isAvailable = true,
  });
}
