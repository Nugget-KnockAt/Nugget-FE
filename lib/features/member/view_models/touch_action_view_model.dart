import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/member/models/touch_action_model.dart';
import 'package:nugget/features/member/repository/touch_setting_repository.dart';

// Providers

final doubleTapActionProvider =
    AsyncNotifierProvider<DoubleTapActionNotifier, TouchActionModel>(
  () => DoubleTapActionNotifier(
    TouchSettingRepository(),
  ),
);

final longPressActionProvider =
    AsyncNotifierProvider<LongPressActionNotifier, TouchActionModel>(
  () => LongPressActionNotifier(
    TouchSettingRepository(),
  ),
);

final dragUpActionProvider =
    AsyncNotifierProvider<DragUpActionNotifier, TouchActionModel>(
  () => DragUpActionNotifier(
    TouchSettingRepository(),
  ),
);

final dragDownActionProvider =
    AsyncNotifierProvider<DragDownActionNotifier, TouchActionModel>(
  () => DragDownActionNotifier(
    TouchSettingRepository(),
  ),
);

// Notifiers

class DoubleTapActionNotifier extends AsyncNotifier<TouchActionModel> {
  final TouchSettingRepository _touchSettingRepository;

  DoubleTapActionNotifier(this._touchSettingRepository);

  @override
  FutureOr<TouchActionModel> build() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async => await _touchSettingRepository
        .getTouchAction(TouchActionType.doubleTap));

    return state.value!;
  }

  Future<void> saveTouchAction(String text) async {
    final action = TouchActionModel(
      action: TouchActionModel.doubleTap,
      text: text,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _touchSettingRepository.saveTouchAction(action);
      return action;
    });
  }
}

class LongPressActionNotifier extends AsyncNotifier<TouchActionModel> {
  final TouchSettingRepository _touchSettingRepository;

  LongPressActionNotifier(this._touchSettingRepository);
  @override
  FutureOr<TouchActionModel> build() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async => await _touchSettingRepository
        .getTouchAction(TouchActionType.longPress));

    return state.value!;
  }

  Future<void> saveTouchAction(String text) async {
    final action = TouchActionModel(
      action: TouchActionModel.longPress,
      text: text,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _touchSettingRepository.saveTouchAction(action);
      return action;
    });
  }
}

class DragUpActionNotifier extends AsyncNotifier<TouchActionModel> {
  final TouchSettingRepository _touchSettingRepository;

  DragUpActionNotifier(this._touchSettingRepository);

  @override
  FutureOr<TouchActionModel> build() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async =>
        await _touchSettingRepository.getTouchAction(TouchActionType.dragUp));

    return state.value!;
  }

  Future<void> saveTouchAction(String text) async {
    final action = TouchActionModel(
      action: TouchActionModel.dragUp,
      text: text,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _touchSettingRepository.saveTouchAction(action);
      return action;
    });
  }
}

class DragDownActionNotifier extends AsyncNotifier<TouchActionModel> {
  final TouchSettingRepository _touchSettingRepository;

  DragDownActionNotifier(this._touchSettingRepository);

  @override
  FutureOr<TouchActionModel> build() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async =>
        await _touchSettingRepository.getTouchAction(TouchActionType.dragDown));

    return state.value!;
  }

  Future<void> saveTouchAction(String text) async {
    final action = TouchActionModel(
      action: TouchActionModel.dragDown,
      text: text,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _touchSettingRepository.saveTouchAction(action);
      return action;
    });
  }
}
