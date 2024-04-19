import 'tun_flutter_platform_interface.dart';

class TunFlutter {
  Future<String?> getPlatformVersion() {
    return TunFlutterPlatform.instance.getPlatformVersion();
  }

  Future<bool?> startVpn() {
    return TunFlutterPlatform.instance.startVpn();
  }

  Future<int?> getTunFD() {
    return TunFlutterPlatform.instance.getTunFD();
  }
}
