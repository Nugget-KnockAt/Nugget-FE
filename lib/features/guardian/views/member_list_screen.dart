import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/guardian/models/user_detail_model.dart';
import 'package:nugget/features/guardian/view_models/user_detail_view_model.dart';
import 'package:nugget/features/guardian/views/member_add_screen.dart';

class MemberListScreen extends ConsumerWidget {
  const MemberListScreen({
    super.key,
    required this.scrollController,
    required this.mainScreenContext,
  });

  final ScrollController scrollController;
  final BuildContext mainScreenContext;

  Future<List<Map<String, dynamic>>> _fetchMembersInfo(
      List<String> emails) async {
    // 이메일 정보로 사용자 목록을 가져오는 api 호출.
    final Dio dio = Dio();
    final List<Map<String, dynamic>> members = [];

    for (final email in emails) {
      final response = await dio.get(
        '$commonUrl/member/info',
        queryParameters: {'emails': email},
      );
      if (response.statusCode == 200) {
        for (final member in response.data['result']) {
          members.add(member);
        }
      }
    }

    return members;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginedUserState = ref.watch(userInfoViewModelProvider);

    print(
        'loginedUserState.connectionList: ${loginedUserState.connectionList}');

    final userDetailsAsyncValue =
        ref.watch(userDetailsProvider(loginedUserState.connectionList));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
        actions: [
          IconButton(
            iconSize: Sizes.size32,
            onPressed: () {
              Navigator.of(mainScreenContext).push(
                // Use mainScreenContext here
                MaterialPageRoute(
                  builder: (context) => const MemberAddScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: userDetailsAsyncValue.when(
        data: (userDetails) {
          return ListView(
            controller: scrollController,
            children: userDetails.map((detail) {
              // Ensure each item is a Widget, like ListTile
              return ListTile(
                onTap: () {
                  // Do something when the ListTile is tapped
                  Navigator.pushNamed(context, '/events',
                      arguments: detail.email);
                },
                title: Text(
                  detail.name,
                ),
                subtitle: Text(
                  detail.phoneNumber,
                ), // Adjust according to your UserDetailModel
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                ),
              );
            }).toList(), // Convert the Iterable to a List
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}
