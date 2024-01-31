import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';

import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';

class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({super.key, required this.onNext});

  final Function onNext;

  @override
  EmailScreenState createState() => EmailScreenState();
}

class EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController emailController = TextEditingController();

  String _email = '';

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {
        _email = emailController.text;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  bool _validateEmail() {
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (_email.isEmpty) {
      return false;
    }

    if (regExp.hasMatch(_email)) {
      return true;
    }

    // 기타 조건에 부합하지 않을 경우
    return false;
  }

  String? validateEmail() {
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (_email.isEmpty) {
      return '이메일 주소를 입력해주세요.';
    }

    if (regExp.hasMatch(_email)) {
      return null;
    }

    return '이메일 주소를 확인해주세요.';
  }

  void _onNextTap() {
    ref.read(userInfoViewModelProvider.notifier).updateEmail(_email);

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v52,
            Text(
              '이메일 주소를',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '입력해주세요.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.v28,
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: validateEmail(),
                hintText: '이메일 주소 입력',
              ),
            ),
            Gaps.v52,
            GestureDetector(
              onTap: _validateEmail() ? _onNextTap : null,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _validateEmail()
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(Sizes.size4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size40,
                    vertical: Sizes.size16,
                  ),
                  child: Text(
                    '다음',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
