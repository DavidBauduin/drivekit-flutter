
import 'package:drivekit/data/drivekit_data.dart';

import 'drivekit_platform_interface.dart';

class Drivekit {
  Future<String?> getPlatformVersion() {
    return DrivekitPlatform.instance.getPlatformVersion();
  }

  Future<void> setDriveKitListener(DriveKitListener driveKitListener) {
    return DrivekitPlatform.instance.setDriveKitListener(driveKitListener);
  }

  Future<bool> isDriveKitConfigured() {
    return DrivekitPlatform.instance.isDriveKitConfigured();
  }
  Future<bool> isUserConnected() {
    return DrivekitPlatform.instance.isUserConnected();
  }

  Future<String?> getApiKey() {
    return DrivekitPlatform.instance.getApiKey();
  }
  Future<void> setApiKey(String apiKey) {
    return DrivekitPlatform.instance.setApiKey(apiKey);
  }

  Future<String?> getUserId() {
    return DrivekitPlatform.instance.getUserId();
  }
  Future<void> setUserId(String userId) {
    return DrivekitPlatform.instance.setUserId(userId);
  }

  Future<bool> isAutoStartEnabled() {
    return DrivekitPlatform.instance.isAutoStartEnabled();
  }
  Future<void> enableAutoStart(bool enable) {
    return DrivekitPlatform.instance.enableAutoStart(enable);
  }

  Future<void> requestPermissions() {
    return DrivekitPlatform.instance.requestPermissions();
  }
}
