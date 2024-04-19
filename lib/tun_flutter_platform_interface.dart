import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tun_flutter_method_channel.dart';

abstract class TunFlutterPlatform extends PlatformInterface {
  /// Constructs a TunFlutterPlatform.
  TunFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TunFlutterPlatform _instance = MethodChannelTunFlutter();

  /// The default instance of [TunFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTunFlutter].
  static TunFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TunFlutterPlatform] when
  /// they register themselves.
  static set instance(TunFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> startVpn(Map<String, String> configs) {
    throw UnimplementedError('startVpn() has not been implemented.');
  }

  Future<int?> getTunFD() {
    throw UnimplementedError('getTunFD() has not been implemented.');
  }
}
