import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starprinter/starprinter_method_channel.dart';

void main() {
  MethodChannelStarprinter platform = MethodChannelStarprinter();
  const MethodChannel channel = MethodChannel('starprinter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
