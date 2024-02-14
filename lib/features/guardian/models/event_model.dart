class EventModel {
  final int eventId;
  final String memberEmail;
  final String locationInfo;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  EventModel({
    required this.eventId,
    required this.memberEmail,
    required this.locationInfo,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      memberEmail: json['memberEmail'],
      locationInfo: json['locationInfo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
