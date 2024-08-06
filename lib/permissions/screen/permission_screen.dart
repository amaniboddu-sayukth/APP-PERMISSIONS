import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permissions/permissions/all_permission_status.dart';
import 'package:permissions/permissions/common_widgets/permission_card_widget.dart';
import 'package:permissions/permissions/controller/permission_controller.dart';
import 'package:permissions/permissions/permission_type.dart';
import 'package:quickalert/quickalert.dart';

// ignore: must_be_immutable
class PermissionScreen extends StatefulWidget {
  List<PermissionType> requestedPermissions;

  PermissionScreen({required this.requestedPermissions, super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  PermissionController permissionController = PermissionController();
  late List<PermissionType> parameters;

  @override
  void initState() {
    super.initState();
    parameters = widget.requestedPermissions;
    permissionController.updatePermissionStatus(parameters);
    permissionController.checkAnyPermissionDenied(parameters);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Permissions',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF16558F),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Observer(builder: (context) {
            return Column(
              children: [
                Visibility(
                  visible: parameters.contains(PermissionType.CAMERA),
                  child: permissionCardWithImage(
                    permissionName: 'Camera',
                    permissionIcon: Icons.camera_alt,
                    permissionStatusIcon: permissionStatusIcon(permissionController
                        .cameraStatus), // Use your logic to determine the icon
                    permissionStatus: permissionController.permissionStatusName(
                        permissionController
                            .cameraStatus), // Use your logic to determine the status
                    color: permissionStatusColor(
                        permissionController.cameraStatus),
                    onTap: () async {
                      permissionController.requestCameraPermission();
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Visibility(
                  visible: parameters.contains(PermissionType.LOCATION),
                  child: permissionCardWithImage(
                    permissionName: 'Location',
                    permissionIcon: Icons.location_on,
                    permissionStatusIcon: permissionStatusIcon(permissionController
                        .locationStatus), // Use your logic to determine the icon
                    permissionStatus: permissionController.permissionStatusName(
                        permissionController
                            .locationStatus), // Use your logic to determine the status
                    color: permissionStatusColor(
                        permissionController.locationStatus),
                    onTap: () async {
                      permissionController.requestLocationPermission();
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Visibility(
                  visible: parameters.contains(PermissionType.SMS),
                  child: permissionCardWithImage(
                    permissionName: 'SMS',
                    permissionIcon: Icons.sms,
                    permissionStatusIcon: permissionStatusIcon(
                        permissionController
                            .smsStatus), // Use your logic to determine the icon
                    permissionStatus: permissionController.permissionStatusName(
                        permissionController
                            .smsStatus), // Use your logic to determine the status
                    color:
                        permissionStatusColor(permissionController.smsStatus),
                    onTap: () async {
                      permissionController.requestSmsPermission();
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Visibility(
                  visible: parameters.contains(PermissionType.PHONE),
                  child: permissionCardWithImage(
                    permissionName: 'Phone',
                    permissionIcon: Icons.phone,
                    permissionStatusIcon: permissionStatusIcon(
                        permissionController
                            .phoneStatus), // Use your logic to determine the icon
                    permissionStatus: permissionController.permissionStatusName(
                        permissionController
                            .phoneStatus), // Use your logic to determine the status
                    color:
                        permissionStatusColor(permissionController.phoneStatus),
                    onTap: () async {
                      permissionController.requestPhonePermission();
                    },
                  ),
                ),
                const SizedBox(height: 14),
                // permissionCardWithImage(
                //   permissionName: 'Storage',
                //   permissionIcon: Icons.storage,
                //   permissionStatusIcon: permissionStatusIcon(permissionController
                //       .storageStatus), // Use your logic to determine the icon
                //   permissionStatus: permissionController.permissionStatusName(
                //       permissionController
                //           .storageStatus), // Use your logic to determine the status
                //   color:
                //       permissionStatusColor(permissionController.storageStatus),
                // ),
                const SizedBox(height: 20),
                allowPermissionsButton(context)
              ],
            );
          }),
        ),
      );
    });
  }

  allowPermissionsButton(BuildContext context) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () {
          setState(() {
            permissionController.checkAnyPermissionDenied(parameters);
            displayAllPermissionStatus(context);
          });
        },
        child: Container(
          // width: MediaQuery.of(context).size.width * 2,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xff16558F),
          ),
          alignment: Alignment.center,
          child: Text(
            // "${AppLocalizations.of(context)!.allow_permissions}",
            "Continue",
            style: boldTextStyle(size: 18, color: Colors.white),
          ),
        ),
      );
    });
  }

  @action
  void displayAllPermissionStatus(BuildContext context) async {
    if (permissionController.allPermissionStatus ==
            AllPermissionsStatus.SOME_PERMISSIONS_DENIED ||
        permissionController.allPermissionStatus ==
            AllPermissionsStatus.ALL_PERMISSIONS_DENIED) {
      // print("Inside why...");
      // print(">>>${permissionController.allPermissionStatus}");
      QuickAlert.show(
        borderRadius: 24,
        context: context,
        confirmBtnColor: const Color(0xff16558F),
        type: QuickAlertType.error,
        // title: '${AppLocalizations.of(context)!.sorry}',
        title: "Sorry",
        // text: '${AppLocalizations.of(context)!.permissions_denied_msg}',
        text: "Some Permissions are denied please Allow All the permissions",
        // animType: QuickAlertAnimType.rotate,
        // widget: Container(child: Text("Failed"),)
      );
    } else if (permissionController.allPermissionStatus ==
            AllPermissionsStatus.SOME_PERMISSIONS_PERMANENTLY_DENIED ||
        permissionController.allPermissionStatus ==
            AllPermissionsStatus.ALL_PERMISSIONS_PERMANENTLY_DENIED) {
      QuickAlert.show(
          borderRadius: 24,
          context: context,
          confirmBtnColor: const Color(0xff16558F),
          type: QuickAlertType.error,
          // confirmBtnText: "${AppLocalizations.of(context)!.open_settings}",
          confirmBtnText: "Open Settings",
          // title: '${AppLocalizations.of(context)!.sorry}',
          title: "Sorry",
          // text: '${AppLocalizations.of(context)!.permissions_perm_denied_msg} ',
          text:
              "Some  Permissions are perminantely denied please open settings to allow the remaining permissions",
          onConfirmBtnTap: () => {
                openAppSettings(),
                Navigator.pop(context),
                permissionController.updatePermissionStatus(parameters)
              });
    } else if (permissionController.allPermissionStatus ==
        AllPermissionsStatus.ALL_PERMISSIONS_GRANTED) {
      QuickAlert.show(
        borderRadius: 24,
        context: context,
        confirmBtnColor: const Color(0xff16558F),
        type: QuickAlertType.success,
        // title: '${AppLocalizations.of(context)!.thank_you}',
        title: "Thank you",
        // text: '${AppLocalizations.of(context)!.permission_success_msg}',
        text:
            "All Permissions are granted, we will provide you great functionality !",
        // onConfirmBtnTap: () => {
        //       permissionController.init(context,
        //           callback: (String authorization) {
        //         callback!(authorization);
        //         print("HELLO:${authorization}");
        //       })
        //     }
      );
    } else {
      return null;
    }
  }
}
