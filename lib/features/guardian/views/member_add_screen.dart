import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';

class MemberAddScreen extends ConsumerStatefulWidget {
  const MemberAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MemberAddScreenState();
}

class _MemberAddScreenState extends ConsumerState<MemberAddScreen> {
  final TextEditingController _memberEmailController = TextEditingController();

  void _connectMember() async {
    // 멤버 연결 api 호출

    final Dio dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post(
        '$commonUrl/member/connect',
        options: Options(headers: {
          'Authorization': accessToken,
        }),
        data: {
          'email': _memberEmailController.text,
        },
      );

      if (response.statusCode == 200) {
        // 연결 성공
        if (!mounted) return;

        // 유효하지 않은 사용자 ID 일 때 에러 메시지를 표시합니다.
        if (response.data['is_success'] == false) {
          _showErrorDialog(response.data['message']);
        } else {
          // 유효한 사용자 ID라면,
          await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Success'),
                content: const Text('Member connected successfully'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuardianMapScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        _showErrorDialog(response.data['message']);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String meesage) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(meesage),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect Member'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size32,
            vertical: Sizes.size28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Member\nEmail to Connect',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Gaps.v52,
              TextField(
                controller: _memberEmailController,
                decoration: InputDecoration(
                  filled: false,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: Sizes.size2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: Sizes.size2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: 'Member Email',
                ),
              ),
              Gaps.v32,
              Center(
                child: ElevatedButton(
                  onPressed: _connectMember,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ),
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  child: const Text(
                    'Connect',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
