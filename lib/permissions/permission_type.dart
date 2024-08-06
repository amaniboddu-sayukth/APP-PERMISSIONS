enum PermissionType { CAMERA, LOCATION, SMS, STORAGE, PHONE }

extension PermissionTypeExtension on PermissionType {
  // Convert enum to string
  String enumToString() {
    return this.toString().split('.').last;
  }

  // Convert string to enum
  static PermissionType stringToEnum(String value) {
    return PermissionType.values.firstWhere(
      (e) => e.toString().split('.').last.toUpperCase() == value.toUpperCase(),
      orElse: () => throw ArgumentError('Invalid permission type: $value'),
    );
  }
}
