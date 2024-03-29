import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

/// config file to hold our apiKey and hos url
@freezed
class Config with _$Config {
  const factory Config({
    required String apiKey,
    required String apiHost,
  }) = _Config;
}
