import 'package:intl/intl.dart';

class EventDetailModel {
  final int eventId;
  final String locationInfo;
  final String memberName;
  final String memberEmail;
  final String createdAt;
  final double latitude;
  final double longitude;
  final String text;

  EventDetailModel({
    required this.eventId,
    required this.locationInfo,
    required this.memberName,
    required this.memberEmail,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.text,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      eventId: json['eventId'] as int,
      locationInfo: json['locationInfo'] as String,
      memberName: json['memberName'] as String,
      memberEmail: json['memberEmail'] as String,
      createdAt:
          DateFormat('MM-dd, HH:mm').format(DateTime.parse(json['createdAt'])),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      text: json['text'] as String,
    );
  }
}
