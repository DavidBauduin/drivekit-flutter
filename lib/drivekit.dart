
import 'drivekit_platform_interface.dart';

class Drivekit {
  Future<String?> getPlatformVersion() {
    return DrivekitPlatform.instance.getPlatformVersion();
  }
}
