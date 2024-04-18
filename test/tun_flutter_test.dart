import 'package:flutter_test/flutter_test.dart';
import 'package:tun_flutter/tun_flutter.dart';
import 'package:tun_flutter/tun_flutter_platform_interface.dart';
import 'package:tun_flutter/tun_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTunFlutterPlatform
    with MockPlatformInterfaceMixin
    implements TunFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TunFlutterPlatform initialPlatform = TunFlutterPlatform.instance;

  test('$MethodChannelTunFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTunFlutter>());
  });

  test('getPlatformVersion', () async {
    TunFlutter tunFlutterPlugin = TunFlutter();
    MockTunFlutterPlatform fakePlatform = MockTunFlutterPlatform();
    TunFlutterPlatform.instance = fakePlatform;

    expect(await tunFlutterPlugin.getPlatformVersion(), '42');
  });
}
