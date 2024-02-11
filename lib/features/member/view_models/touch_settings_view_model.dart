import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/member/models/touch_settings_model.dart';

final doubleTapSettingProvider = FutureProvider<DoubleTapSettingModel>(
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

final longPressSettingProvider = FutureProvider<LongPressSettingModel>(
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

final dragUpSettingProvider = FutureProvider<DragUpSettingModel>(
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

final dragDownSettingProvider = FutureProvider<DragDownSettingModel>(
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
