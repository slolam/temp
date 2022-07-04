import 'package:flutter_test/flutter_test.dart';
import 'package:starprinter/starprinter.dart';
import 'package:starprinter/starprinter_platform_interface.dart';
import 'package:starprinter/starprinter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockStarprinterPlatform 
    with MockPlatformInterfaceMixin
    implements StarprinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final StarprinterPlatform initialPlatform = StarprinterPlatform.instance;

  test('$MethodChannelStarprinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStarprinter>());
  });

  test('getPlatformVersion', () async {
    Starprinter starprinterPlugin = Starprinter();
    MockStarprinterPlatform fakePlatform = MockStarprinterPlatform();
    StarprinterPlatform.instance = fakePlatform;
  
    expect(await starprinterPlugin.getPlatformVersion(), '42');
  });
}
