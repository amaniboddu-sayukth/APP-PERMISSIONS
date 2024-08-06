import 'package:mobx/mobx.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permissions/permissions/all_permission_status.dart';
import 'package:permissions/permissions/permission_type.dart';
part 'permission_controller.g.dart';

class PermissionController = PermissionControllerBase
    with _$PermissionController;

abstract class PermissionControllerBase with Store {
  @observable
  PermissionStatus cameraStatus = PermissionStatus.denied;

  @observable
  PermissionStatus locationStatus = PermissionStatus.denied;

  @observable
  PermissionStatus smsStatus = PermissionStatus.denied;

  @observable
  PermissionStatus phoneStatus = PermissionStatus.denied;

  @observable
  PermissionStatus storageStatus = PermissionStatus.denied;

  @observable
  String allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_DENIED;

  @action
  Future<PermissionStatus> requestCameraPermission() async {
    await Permission.camera.request();
    cameraStatus = await Permission.camera.status;
    // print("camera:${cameraStatus}");
    return cameraStatus;
  }

  @action
  Future<PermissionStatus> requestLocationPermission() async {
    await Permission.location.request();
    locationStatus = await Permission.location.status;
    // print("location:${locationStatus}");
    return locationStatus;
  }

  @action
  Future<PermissionStatus> requestSmsPermission() async {
    await Permission.sms.request();
    smsStatus = await Permission.sms.status;
    // print("sms:${smsStatus}");
    return smsStatus;
  }

  @action
  Future<PermissionStatus> requestPhonePermission() async {
    await Permission.phone.request();
    phoneStatus = await Permission.phone.status;
    // print("phone:${phoneStatus}");
    return phoneStatus;
  }

  @action
  Future<PermissionStatus> requestStoragePermission() async {
    await Permission.storage.request();
    storageStatus = await Permission.storage.status;
    // print("Storage:${storageStatus}");
    return storageStatus;
  }

  String permissionStatusName(PermissionStatus permissionStatus) {
    try {
      if (permissionStatus.isGranted) {
        return "Granted";
      } else if (permissionStatus.isDenied) {
        return "Denied";
      } else if (permissionStatus.isPermanentlyDenied) {
        return "Permanently Denied";
      } else if (permissionStatus.isRestricted) {
        return "Restricted";
      } else {
        return "Limited";
      }
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> updatePermissionStatus(
      List<PermissionType> requestedPermissions) async {
    cameraStatus = await Permission.camera.status;
    locationStatus = await Permission.location.status;
    smsStatus = await Permission.sms.status;
    phoneStatus = await Permission.phone.status;
    checkAnyPermissionDenied(requestedPermissions);
  }

  // @action
  // Future<void> checkAnyPermissionDenied() async {
  //   await updatePermissionStatus();
  //   if (!isIOS) {
  //     if (cameraStatus == PermissionStatus.granted &&
  //             locationStatus == PermissionStatus.granted
  //         // &&
  //         // smsStatus == PermissionStatus.granted &&
  //         // phoneStatus == PermissionStatus.granted
  //         ) {
  //       allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_GRANTED;
  //     } else if (cameraStatus == PermissionStatus.denied &&
  //             locationStatus == PermissionStatus.denied
  //         // &&
  //         // smsStatus == PermissionStatus.denied &&
  //         // phoneStatus == PermissionStatus.denied
  //         ) {
  //       allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_DENIED;
  //     } else if (cameraStatus == PermissionStatus.permanentlyDenied &&
  //             locationStatus == PermissionStatus.permanentlyDenied
  //         // &&
  //         // smsStatus == PermissionStatus.permanentlyDenied &&
  //         // phoneStatus == PermissionStatus.permanentlyDenied
  //         ) {
  //       allPermissionStatus =
  //           AllPermissionsStatus.ALL_PERMISSIONS_PERMANENTLY_DENIED;
  //     } else if (cameraStatus == PermissionStatus.denied ||
  //             locationStatus == PermissionStatus.denied
  //         // ||
  //         // smsStatus == PermissionStatus.denied ||
  //         // phoneStatus == PermissionStatus.denied
  //         ) {
  //       // print("Aamani");
  //       allPermissionStatus = AllPermissionsStatus.SOME_PERMISSIONS_DENIED;
  //     } else if (cameraStatus == PermissionStatus.permanentlyDenied ||
  //             locationStatus == PermissionStatus.permanentlyDenied
  //         // ||
  //         // smsStatus == PermissionStatus.permanentlyDenied ||
  //         // phoneStatus == PermissionStatus.permanentlyDenied
  //         ) {
  //       // print("Inside...");
  //       allPermissionStatus =
  //           AllPermissionsStatus.SOME_PERMISSIONS_PERMANENTLY_DENIED;
  //     }
  //   } else {
  //     allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_GRANTED;
  //   }
  // }

  @action
  Future<void> checkAnyPermissionDenied(
      List<PermissionType> requestedPermissions) async {
    await updatePermissionStatus(requestedPermissions);

    bool allGranted = true;
    bool allDenied = true;
    bool allPermanentlyDenied = true;
    bool someDenied = false;
    bool somePermanentlyDenied = false;

    for (var permission in requestedPermissions) {
      PermissionStatus status;

      switch (permission) {
        case PermissionType.CAMERA:
          status = cameraStatus;
          break;
        case PermissionType.LOCATION:
          status = locationStatus;
          break;
        case PermissionType.SMS:
          status = smsStatus;
          break;
        case PermissionType.PHONE:
          status = phoneStatus;
          break;
        default:
          status = PermissionStatus.denied;
      }

      if (status != PermissionStatus.granted) {
        allGranted = false;
      }

      if (status != PermissionStatus.denied) {
        allDenied = false;
      } else {
        someDenied = true;
      }

      if (status != PermissionStatus.permanentlyDenied) {
        allPermanentlyDenied = false;
      } else {
        somePermanentlyDenied = true;
      }
    }

    if (allGranted) {
      allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_GRANTED;
    } else if (allDenied) {
      allPermissionStatus = AllPermissionsStatus.ALL_PERMISSIONS_DENIED;
    } else if (allPermanentlyDenied) {
      allPermissionStatus =
          AllPermissionsStatus.ALL_PERMISSIONS_PERMANENTLY_DENIED;
    } else if (someDenied) {
      allPermissionStatus = AllPermissionsStatus.SOME_PERMISSIONS_DENIED;
    } else if (somePermanentlyDenied) {
      allPermissionStatus =
          AllPermissionsStatus.SOME_PERMISSIONS_PERMANENTLY_DENIED;
    }
  }
}
