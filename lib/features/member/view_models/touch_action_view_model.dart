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


/* 상속 관계를 이용한 리팩토링
// 공통 부모 클래스
abstract class TouchActionNotifier extends AsyncNotifier<TouchActionModel> {
  final TouchSettingRepository _touchSettingRepository;
  final TouchActionType actionType;

  TouchActionNotifier(this._touchSettingRepository, this.actionType);

  @override
  FutureOr<TouchActionModel> build() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async => await _touchSettingRepository
        .getTouchAction(actionType));

    return state.value!;
  }

  Future<void> saveTouchAction(String text) async {
    final action = TouchActionModel(
      action: actionType.name,
      text: text,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _touchSettingRepository.saveTouchAction(action);
      return action;
    });
  }
}

// 구체적인 액션 클래스
class DoubleTapActionNotifier extends TouchActionNotifier {
  DoubleTapActionNotifier(TouchSettingRepository touchSettingRepository)
      : super(touchSettingRepository, TouchActionType.doubleTap);
}

class LongPressActionNotifier extends TouchActionNotifier {
  LongPressActionNotifier(TouchSettingRepository touchSettingRepository)
      : super(touchSettingRepository, TouchActionType.longPress);
}

class DragUpActionNotifier extends TouchActionNotifier {
  DragUpActionNotifier(TouchSettingRepository touchSettingRepository)
      : super(touchSettingRepository, TouchActionType.dragUp);
}

class DragDownActionNotifier extends TouchActionNotifier {
  DragDownActionNotifier(TouchSettingRepository touchSettingRepository)
      : super(touchSettingRepository, TouchActionType.dragDown);
}
 */