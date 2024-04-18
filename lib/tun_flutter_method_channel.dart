import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tun_flutter_platform_interface.dart';

/// An implementation of [TunFlutterPlatform] that uses method channels.
class MethodChannelTunFlutter extends TunFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tun_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> startVpn() async {
    final startedStr = await methodChannel.invokeMethod<String>('startVpn');
    return startedStr;
  }
}
