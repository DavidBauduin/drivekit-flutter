
import 'drivekit_platform_interface.dart';

class Drivekit {
  Future<String?> getPlatformVersion() {
    return DrivekitPlatform.instance.getPlatformVersion();
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
}
