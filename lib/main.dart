import 'package:flutter/material.dart';
import 'package:permissions/permissions/permission_type.dart';
import 'package:permissions/permissions/screen/permission_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: PermissionScreen(
        requestedPermissions: const [
          PermissionType.CAMERA,
          PermissionType.LOCATION,
          PermissionType.PHONE
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
