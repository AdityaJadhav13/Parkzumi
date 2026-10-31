import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../domain/models.dart';

sealed class LocationResult {
  const LocationResult();
}

final class Located extends LocationResult {
  const Located(this.point, this.accuracyM, this.at);
  final GeoPoint point;
  final double accuracyM;
  final DateTime at;
}

enum LocationProblem {
  notAsked('See spots near you'),
  serviceOff('Location is turned off'),
  denied('Location permission is off'),
  timedOut('Couldn’t get a location fix'),
  failed('Location isn’t available');

  const LocationProblem(this.label);
  final String label;
}

final class LocationUnavailable extends LocationResult {
  const LocationUnavailable(this.problem);
  final LocationProblem problem;
}

/// A fresh, one-off fix when the rider asks for help. No background tracking.
class LocationService {
  Future<LocationResult> current({bool request = true}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return const LocationUnavailable(LocationProblem.serviceOff);
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Ask only when the rider asks for help, never at launch.
        if (!request) return const LocationUnavailable(LocationProblem.notAsked);
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return const LocationUnavailable(LocationProblem.denied);
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 8)),
      );
      return Located(GeoPoint(p.latitude, p.longitude), p.accuracy, p.timestamp);
    } on TimeoutException {
      return const LocationUnavailable(LocationProblem.timedOut);
    } catch (_) {
      return const LocationUnavailable(LocationProblem.failed);
    }
  }

  Future<void> openSettings() => Geolocator.openAppSettings();
}
