import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> askForStorage() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    switch (status) {
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
      case PermissionStatus.denied:
        Fluttertoast.showToast(
            msg: "Kindly give permission for accessing storage");
        await Permission.manageExternalStorage.request();
        break;
      default:
    }

    return (await Permission.manageExternalStorage.status).isGranted;
  }
}
