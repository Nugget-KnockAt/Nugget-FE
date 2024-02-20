import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    // print('''
    // [Provider Updated]
    // Provider: $provider
    // Previous: $previousValue
    // New: $newValue
    // ''');
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    // print('''
    // [New Provider Added]
    // Provider: $provider
    // Value: $value
    // ''');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    print('''
    [Provider Disposed]
    Provider: $provider
    ''');
  }
}
