import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'starprinter_platform_interface.dart';

/// An implementation of [StarprinterPlatform] that uses method channels.
class MethodChannelStarprinter extends StarprinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('starprinter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
