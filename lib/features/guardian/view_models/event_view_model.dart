import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/data/data.dart';

import 'package:nugget/features/guardian/models/event_model.dart';

final eventViewModelProvider =
    StateNotifierProvider<EventViewModelNotifier, List<EventModel>>(
  (ref) => EventViewModelNotifier(),
);

class EventViewModelNotifier extends StateNotifier<List<EventModel>> {
  EventViewModelNotifier() : super([]);

  void fetchEvents(String email) async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();
    try {
      print('Request URL: $commonUrl/member/event');
      print('Authorization: $accessToken');

      final response = await dio.get(
        '$commonUrl/member/event',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data['result'];
        List<EventModel> events =
            jsonList.map((json) => EventModel.fromJson(json)).toList();

        print('events: $events');

        state = events;
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch events');
    }
  }
}
