import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/guardian/models/event_detail_model.dart';

final eventDetailModelProvider =
    FutureProvider.family<EventDetailModel, int>((ref, eventId) async {
  final Dio dio = Dio();

  final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

  try {
    final response = await dio.get(
      '$commonUrl/member/event/$eventId',
      options: Options(
        headers: {
          'Authorization': accessToken ?? '',
        },
      ),
    );

    if (response.statusCode == 200) {
      final eventDetail = EventDetailModel.fromJson(response.data['result']);

      return eventDetail;
    }

    throw Exception('Failed to load event detail');
  } catch (e) {
    print('error: $e');

    throw Exception('Failed to load event detail');
  }
});
