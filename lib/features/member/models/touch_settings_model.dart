class TouchSettingsModel {
  TouchSettingsModel({
    required this.doubleTap,
    required this.longPress,
    required this.dragUp,
    required this.dragDown,
  });

  final DoubleTapSettingModel doubleTap;
  final LongPressSettingModel longPress;
  final DragUpSettingModel dragUp;
  final DragDownSettingModel dragDown;

  TouchSettingsModel copyWith({
    DoubleTapSettingModel? doubleTap,
    LongPressSettingModel? longPress,
    DragUpSettingModel? dragUp,
    DragDownSettingModel? dragDown,
  }) {
    return TouchSettingsModel(
      doubleTap: doubleTap ?? this.doubleTap,
      longPress: longPress ?? this.longPress,
      dragUp: dragUp ?? this.dragUp,
      dragDown: dragDown ?? this.dragDown,
    );
  }

  TouchSettingsModel.fromJson(Map<String, dynamic> json)
      : doubleTap = DoubleTapSettingModel.fromJson(json['doubleTap'] ?? {}),
        longPress = LongPressSettingModel.fromJson(json['longPress'] ?? {}),
        dragUp = DragUpSettingModel.fromJson(json['dragUp'] ?? {}),
        dragDown = DragDownSettingModel.fromJson(json['dragDown'] ?? {});
}

class DoubleTapSettingModel {
  DoubleTapSettingModel({
    required this.text,
  });

  final String action = 'doubleTap';
  final String text;

  DoubleTapSettingModel copyWith({
    String? text,
  }) {
    return DoubleTapSettingModel(
      text: text ?? this.text,
    );
  }

  DoubleTapSettingModel.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '';
}

class LongPressSettingModel {
  LongPressSettingModel({
    required this.text,
  });

  final String action = 'longPress';
  final String text;

  LongPressSettingModel copyWith({
    String? text,
  }) {
    return LongPressSettingModel(
      text: text ?? this.text,
    );
  }

  LongPressSettingModel.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '';
}

class DragUpSettingModel {
  DragUpSettingModel({
    required this.text,
  });

  final String action = 'dragUp';
  final String text;

  DragUpSettingModel copyWith({
    String? text,
  }) {
    return DragUpSettingModel(
      text: text ?? this.text,
    );
  }

  DragUpSettingModel.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '';
}

class DragDownSettingModel {
  DragDownSettingModel({
    required this.text,
  });

  final String action = 'dragDown';
  final String text;

  DragDownSettingModel copyWith({
    String? text,
  }) {
    return DragDownSettingModel(
      text: text ?? this.text,
    );
  }

  DragDownSettingModel.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '';
}
