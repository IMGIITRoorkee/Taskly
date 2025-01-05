import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  static Future<bool> askForLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Enable location services.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Grant location permission to use this feature");
        return false;
      }
    } else if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Enable location permissions by going to Settings/Apps/Taskly");
      return false;
    }

    return true;
  }
}
