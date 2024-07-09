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

  @override
  Future<bool> isDriveKitConfigured() async {
    return await methodChannel.invokeMethod<bool>('isDriveKitConfigured') ?? false;
  }
  @override
  Future<bool> isUserConnected() async {
    return await methodChannel.invokeMethod<bool>('isUserConnected') ?? false;
  }

  @override
  Future<String?> getApiKey() async {
    final apiKey = await methodChannel.invokeMethod<String?>('getApiKey');
    return apiKey;
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await methodChannel.invokeMethod<void>('setApiKey', apiKey);
  }

  @override
  Future<String?> getUserId() async {
    final userId = await methodChannel.invokeMethod<String?>('getUserId');
    return userId;
  }

  @override
  Future<void> setUserId(String userId) async {
    await methodChannel.invokeMethod<void>('setUserId', userId);
  }

  @override
  Future<bool> isAutoStartEnabled() async {
    return await methodChannel.invokeMethod<bool>('isAutoStartEnabled') ?? false;
  }
  @override
  Future<void> enableAutoStart(bool enable) async {
    await methodChannel.invokeMethod<void>('enableAutoStart', enable);
  }
}
