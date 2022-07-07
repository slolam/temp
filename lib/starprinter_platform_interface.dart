import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'starprinter_method_channel.dart';

abstract class StarprinterPlatform extends PlatformInterface {
  /// Constructs a StarprinterPlatform.
  StarprinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static StarprinterPlatform _instance = MethodChannelStarprinter();

  /// The default instance of [StarprinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelStarprinter].
  static StarprinterPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StarprinterPlatform] when
  /// they register themselves.
  static set instance(StarprinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
