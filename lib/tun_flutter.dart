
import 'tun_flutter_platform_interface.dart';

class TunFlutter {
  Future<String?> getPlatformVersion() {
    return TunFlutterPlatform.instance.getPlatformVersion();
  }
}
