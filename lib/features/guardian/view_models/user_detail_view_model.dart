import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/guardian/models/user_detail_model.dart';

final userDetailsProvider =
    FutureProvider.family<List<UserDetailModel>, List<String>>(
        (ref, emails) async {
  final Dio dio = Dio();
  List<UserDetailModel> userDetails = [];

  for (final email in emails) {
    final response = await dio
        .get('$commonUrl/member/info', queryParameters: {'email': email});
    if (response.statusCode == 200) {
      userDetails.add(UserDetailModel.fromJson(response.data['result']));
    }
  }

  print('userDetails: $userDetails');
  return userDetails;
});
