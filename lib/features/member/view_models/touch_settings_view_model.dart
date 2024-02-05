import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/member/models/touch_settings_model.dart';
import 'package:nugget/features/member/repositories/touch_setting_repository.dart';

final touchSettingsViewModelProvider =
    StateNotifierProvider<TouchSettingsViewModel, TouchSettingsModel>((ref) {
  return TouchSettingsViewModel(TouchSettingsRepository());
});

class TouchSettingsViewModel extends StateNotifier<TouchSettingsModel> {
  TouchSettingsViewModel(this._repository) : super(TouchSettingsModel());

  final TouchSettingsRepository _repository;

  Future<void> loadSettings() async {
    final threeTouches = await _repository.getThreeTouchesMessage();
    final fourTouches = await _repository.getFourTouchesMessage();
    final fiveTouches = await _repository.getFiveTouchesMessage();
    final sixTouches = await _repository.getSixTouchesMessage();

    state = state.copyWith(
      threeTouches: threeTouches,
      fourTouches: fourTouches,
      fiveTouches: fiveTouches,
      sixTouches: sixTouches,
    );
  }

  void updateThreeTouches(String message) {
    state = state.copyWith(threeTouches: message);
  }

  void updateFourTouches(String message) {
    state = state.copyWith(fourTouches: message);
  }

  void updateFiveTouches(String message) {
    state = state.copyWith(fiveTouches: message);
  }

  void updateSixTouches(String message) {
    state = state.copyWith(sixTouches: message);
  }

  Future<void> saveAllSettings() async {
    await _repository.saveThreeTouchesMessage(state.threeTouches ?? '');
    await _repository.saveFourTouchesMessage(state.fourTouches ?? '');
    await _repository.saveFiveTouchesMessage(state.fiveTouches ?? '');
    await _repository.saveSixTouchesMessage(state.sixTouches ?? '');
  }

  // Similar methods for saving fourTouches, fiveTouches, and sixTouches
}
