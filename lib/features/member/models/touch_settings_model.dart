class TouchSettingsModel {
  TouchSettingsModel({
    this.threeTouches,
    this.fourTouches,
    this.fiveTouches,
    this.sixTouches,
  });

  String? threeTouches;
  String? fourTouches;
  String? fiveTouches;
  String? sixTouches;

  TouchSettingsModel copyWith({
    String? threeTouches,
    String? fourTouches,
    String? fiveTouches,
    String? sixTouches,
  }) {
    return TouchSettingsModel(
      threeTouches: threeTouches ?? this.threeTouches,
      fourTouches: fourTouches ?? this.fourTouches,
      fiveTouches: fiveTouches ?? this.fiveTouches,
      sixTouches: sixTouches ?? this.sixTouches,
    );
  }
}
