import 'package:flutter_test/flutter_test.dart';
import 'package:drivekit/drivekit.dart';
import 'package:drivekit/drivekit_platform_interface.dart';
import 'package:drivekit/drivekit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDrivekitPlatform
    with MockPlatformInterfaceMixin
    implements DrivekitPlatform {
  String apiKey = 'abcdef123456';
  String userId = 'toto';
  bool _isAutoStartEnabled = false;

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isDriveKitConfigured() => Future.value(false);

  @override
  Future<bool> isUserConnected() => Future.value(false);

  @override
  Future<String?> getApiKey() => Future.value(apiKey);

  @override
  Future<void> setApiKey(String apiKey) async {
    this.apiKey = apiKey;
  }

  @override
  Future<String?> getUserId() => Future.value(userId);

  @override
  Future<void> setUserId(String userId) async {
    this.userId = userId;
  }

  @override
  Future<bool> isAutoStartEnabled() => Future.value(_isAutoStartEnabled);

  @override
  Future<void> enableAutoStart(bool enable) async {
    _isAutoStartEnabled = enable;
  }
}

void main() {
  final DrivekitPlatform initialPlatform = DrivekitPlatform.instance;

  test('$MethodChannelDrivekit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDrivekit>());
  });

  test('getPlatformVersion', () async {
    Drivekit drivekitPlugin = Drivekit();
    MockDrivekitPlatform fakePlatform = MockDrivekitPlatform();
    DrivekitPlatform.instance = fakePlatform;

    expect(await drivekitPlugin.getPlatformVersion(), '42');
  });
}
