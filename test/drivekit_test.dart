import 'package:flutter_test/flutter_test.dart';
import 'package:drivekit/drivekit.dart';
import 'package:drivekit/drivekit_platform_interface.dart';
import 'package:drivekit/drivekit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDrivekitPlatform
    with MockPlatformInterfaceMixin
    implements DrivekitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
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
