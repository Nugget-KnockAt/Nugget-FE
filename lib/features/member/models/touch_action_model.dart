class TouchActionModel {
  static const String doubleTap = "doubleTap";
  static const String longPress = "longPress";
  static const String dragUp = "dragUp";
  static const String dragDown = "dragDown";

  final String action;
  final String text;

  TouchActionModel({
    required this.action,
    required this.text,
  });

  TouchActionModel copyWith({
    String? text,
  }) {
    return TouchActionModel(
      action: action,
      text: text ?? this.text,
    );
  }

  factory TouchActionModel.fromJson(Map<String, dynamic> json) {
    return TouchActionModel(
      action: json['action'] as String,
      text: json['text'] ?? "",
    );
  }
}
