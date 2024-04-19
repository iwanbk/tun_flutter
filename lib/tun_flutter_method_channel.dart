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
  Future<bool?> startVpn() async {
    final started = await methodChannel.invokeMethod<bool>('startVpn');
    return started;
  }

  @override
  Future<int?> getTunFD() async {
    final val = await methodChannel.invokeMethod<int>('getTunFD');
    return val;
  }
}
