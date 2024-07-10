import 'dart:ffi';

import 'package:drivekit/data/drivekit_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'drivekit_method_channel.dart';

abstract class DrivekitPlatform extends PlatformInterface {
  /// Constructs a DrivekitPlatform.
  DrivekitPlatform() : super(token: _token);

  static final Object _token = Object();

  static DrivekitPlatform _instance = MethodChannelDrivekit();

  /// The default instance of [DrivekitPlatform] to use.
  ///
  /// Defaults to [MethodChannelDrivekit].
  static DrivekitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DrivekitPlatform] when
  /// they register themselves.
  static set instance(DrivekitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setDriveKitListener(DriveKitListener? driveKitListener);

  Future<bool> isDriveKitConfigured();
  Future<bool> isUserConnected();

  Future<String?> getApiKey();
  Future<void> setApiKey(String apiKey);

  Future<String?> getUserId();
  Future<void> setUserId(String userId);

  Future<bool> isAutoStartEnabled();
  Future<void> enableAutoStart(bool enable);
}
