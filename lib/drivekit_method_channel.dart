import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'drivekit_platform_interface.dart';

/// An implementation of [DrivekitPlatform] that uses method channels.
class MethodChannelDrivekit extends DrivekitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('drivekit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
