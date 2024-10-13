/// Key of APP ID
const keyAppId = 'TEST_APP_ID';

/// Key of Channel ID
const keyChannelId = 'TEST_CHANNEL_ID';

/// Key of token
const keyToken = 'TEST_TOKEN';


/// Key of APP ID
const valueAppId = '9e1b7f9aab1a4801a84b10d720538e2f';

/// Key of Channel ID
const valueChannelId = 'agora_channel_12oct';

/// Key of token
const valueToken = '007eJxTYJh0sM2nuF95xaLbjn+O7eFLYzDi2bpe2uy9oEZlVAlv3xMFBstUwyTzNMvExCTDRBMLA8NEC5MkQ4MUcyMDU2OLVKO0gB+c6Q2BjAwudrdZGRkgEMQXZkhMzy9KjE/OSMzLS82JNzTKTy5hYAAA874jlw==';

ExampleConfigOverride? _gConfigOverride;

/// This class allow override the config(appId/channelId/token) in the example.
class ExampleConfigOverride {
  ExampleConfigOverride._();

  factory ExampleConfigOverride() {
    _gConfigOverride = _gConfigOverride ?? ExampleConfigOverride._();
    return _gConfigOverride!;
  }
  final Map<String, String> _overridedConfig = {};

  /// Get the expected APP ID
  String getAppId() {
    return _overridedConfig[keyAppId] ??
        // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
        const String.fromEnvironment(keyAppId, defaultValue: valueAppId);
  }

  /// Get the expected Channel ID
  String getChannelId() {
    return _overridedConfig[keyChannelId] ??
        // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
        const String.fromEnvironment(keyChannelId,
            defaultValue: valueChannelId);
  }

  /// Get the expected Token
  String getToken() {
    return _overridedConfig[keyToken] ??
        // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
        const String.fromEnvironment(keyToken, defaultValue: valueToken);
  }

  /// Override the config(appId/channelId/token)
  void set(String name, String value) {
    _overridedConfig[name] = value;
  }

  /// Internal testing flag
  bool get isInternalTesting =>
      const bool.fromEnvironment('INTERNAL_TESTING', defaultValue: false);
}
