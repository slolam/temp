
import 'starprinter_platform_interface.dart';

class Starprinter {
  Future<String?> getPlatformVersion() {
    return StarprinterPlatform.instance.getPlatformVersion();
  }
}
