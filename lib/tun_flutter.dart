import 'tun_flutter_platform_interface.dart';

class TunFlutter {
  Future<String?> getPlatformVersion() {
    return TunFlutterPlatform.instance.getPlatformVersion();
  }

  Future<bool?> startVpn(Map<String, String> configs) {
    return TunFlutterPlatform.instance.startVpn(configs);
  }

  Future<int?> getTunFD() {
    return TunFlutterPlatform.instance.getTunFD();
  }
}
