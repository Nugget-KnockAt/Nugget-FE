import 'package:dio/dio.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/member/models/touch_action_model.dart';

enum TouchActionType {
  doubleTap,
  longPress,
  dragUp,
  dragDown,
}

class TouchSettingRepository {
  final Dio _dio = Dio();

  Future<TouchActionModel> getTouchAction(TouchActionType actionType) async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    print('$commonUrl/member/customTouch/${actionType.name.toString()}');

    try {
      final response = await _dio.get(
        '$commonUrl/member/customTouch/${actionType.name.toString()}',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      print('action data: ${response.data['result']}');
      final actionData = TouchActionModel.fromJson(response.data['result']);

      return actionData;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> saveTouchAction(TouchActionModel action) async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    try {
      final response = await _dio.post(
        '$commonUrl/member/customTouch',
        data: {
          'action': action.action,
          'text': action.text,
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      print('save action: ${response.data}');
    } catch (e) {
      print(e);

      rethrow;
    }
  }
}
