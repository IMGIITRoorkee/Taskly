import 'package:geolocator/geolocator.dart';
import 'package:taskly/service/permission_service.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool granted = await PermissionService.askForLocation();
    if (!granted) return null;

    return Geolocator.getCurrentPosition();
  }

  static double getDistance(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}
