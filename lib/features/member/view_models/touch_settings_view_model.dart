import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/member/models/touch_settings_model.dart';

final touchSettingsNotifierProvider =
    StateNotifierProvider<TouchSettingsNotifier, TouchSettingsModel>((ref) {
  return TouchSettingsNotifier();
});

class TouchSettingsNotifier extends StateNotifier<TouchSettingsModel> {
  TouchSettingsNotifier()
      : super(
          TouchSettingsModel(
            doubleTap: DoubleTapSettingModel(text: ''),
            longPress: LongPressSettingModel(text: ''),
            dragUp: DragUpSettingModel(text: ''),
            dragDown: DragDownSettingModel(text: ''),
          ),
        );

  final Dio dio = Dio();

  Future<void> saveDoubleTapSetting(String text) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post(
        '$commonUrl/member/customTouch',
        data: {
          'action': 'doubleTap',
          'text': text,
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          doubleTap: state.doubleTap.copyWith(text: text),
        );
        print('Double Tap Setting Saved');
      } else {
        throw Exception('Failed to save double tap setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);

      print('Access Token Expired');

      print(e);
    }
  }

  Future<void> saveLongPressSetting(String text) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post(
        '$commonUrl/member/customTouch',
        data: {
          'action': 'longPress',
          'text': text,
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          longPress: state.longPress.copyWith(text: text),
        );
        print('Long Press Setting Saved');
      } else {
        throw Exception('Failed to save long press setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);

      print('Access Token Expired');

      print(e);
    }
  }

  Future<void> saveDragUpSetting(String text) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post(
        '$commonUrl/member/customTouch',
        data: {
          'action': 'dragUp',
          'text': text,
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          dragUp: state.dragUp.copyWith(text: text),
        );
        print('Drag Up Setting Saved');
      } else {
        throw Exception('Failed to save drag up setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);

      print('Access Token Expired');

      print(e);
    }
  }

  Future<void> saveDragDownSetting(String text) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post(
        '$commonUrl/member/customTouch',
        data: {
          'action': 'dragDown',
          'text': text,
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          dragDown: state.dragDown.copyWith(text: text),
        );
        print('Drag Down Setting Saved');
      } else {
        throw Exception('Failed to save drag down setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);

      print('Access Token Expired');

      print(e);
    }
  }
}

final doubleTapSettingProvider =
    FutureProvider.autoDispose<DoubleTapSettingModel>(
  (ref) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();

    try {
      final response = await dio.get(
        '$commonUrl/member/customTouch/doubleTap',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        DoubleTapSettingModel doubleTapSettingModel =
            DoubleTapSettingModel.fromJson(response.data['result']);

        print(doubleTapSettingModel.text);
        return doubleTapSettingModel;
      } else {
        throw Exception('Failed to load double tap setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);
      ref.read(userInfoViewModelProvider.notifier).clearUserInfo();
      print('Access Token Expired');
      print(e);
      return DoubleTapSettingModel(text: '');
    }
  },
);

final longPressSettingProvider =
    FutureProvider.autoDispose<LongPressSettingModel>(
  (ref) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();

    try {
      final response = await dio.get(
        '$commonUrl/member/customTouch/longPress',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        LongPressSettingModel longPressSettingModel =
            LongPressSettingModel.fromJson(response.data['result']);

        print(longPressSettingModel.text);
        return longPressSettingModel;
      } else {
        throw Exception('Failed to load long press setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);
      ref.read(userInfoViewModelProvider.notifier).clearUserInfo();
      print('Access Token Expired');
      print(e);
      return LongPressSettingModel(text: '');
    }
  },
);

final dragUpSettingProvider = FutureProvider.autoDispose<DragUpSettingModel>(
  (ref) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();

    try {
      final response = await dio.get(
        '$commonUrl/member/customTouch/dragUp',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        DragUpSettingModel dragUpSettingModel =
            DragUpSettingModel.fromJson(response.data['result']);

        print(dragUpSettingModel.text);
        return dragUpSettingModel;
      } else {
        throw Exception('Failed to load drag up setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);
      ref.read(userInfoViewModelProvider.notifier).clearUserInfo();
      print('Access Token Expired');
      print(e);
      return DragUpSettingModel(text: '');
    }
  },
);

final dragDownSettingProvider =
    FutureProvider.autoDispose<DragDownSettingModel>(
  (ref) async {
    final String? accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();

    try {
      final response = await dio.get(
        '$commonUrl/member/customTouch/dragDown',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        DragDownSettingModel dragDownSettingModel =
            DragDownSettingModel.fromJson(response.data['result']);

        print(dragDownSettingModel.text);
        return dragDownSettingModel;
      } else {
        throw Exception('Failed to load drag down setting');
      }
    } catch (e) {
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);
      ref.read(userInfoViewModelProvider.notifier).clearUserInfo();
      print('Access Token Expired');
      print(e);
      return DragDownSettingModel(text: '');
    }
  },
);
