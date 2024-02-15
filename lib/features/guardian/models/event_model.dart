import 'package:intl/intl.dart';

class EventModel {
  final int eventId;
  final String memberEmail;
  final String memberName;
  final String locationInfo;
  final double latitude;
  final double longitude;
  final String createdAt;

  EventModel({
    required this.eventId,
    required this.memberEmail,
    required this.memberName,
    required this.locationInfo,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'],
      memberEmail: json['memberEmail'],
      memberName: json['memberName'],
      locationInfo: json['locationInfo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt:
          DateFormat('MM-dd, HH:mm').format(DateTime.parse(json['createdAt'])),
    );
  }
}
