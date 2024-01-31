import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key, required this.onNext});

  final Function onNext;
  @override
  NameScreenState createState() => NameScreenState();
}

class NameScreenState extends ConsumerState<NameScreen> {
  final TextEditingController _nameController = TextEditingController();

  String _name = '';

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  bool _validateName() {
    RegExp koreanRegex = RegExp(r"^[가-힣]+$");
    RegExp englishRegex = RegExp(r"^[a-zA-Z]+$");

    if (_name.isEmpty) {
      return false;
    }

    if (koreanRegex.hasMatch(_name)) {
      return _name.length >= 2 && _name.length <= 12;
    }

    // 영어 이름 검사: 2글자 이상 12글자 이하
    if (englishRegex.hasMatch(_name)) {
      return _name.length >= 2 && _name.length <= 12;
    }

    // 기타 조건에 부합하지 않을 경우
    return false;
  }

  String? validateName() {
    RegExp koreanRegex = RegExp(r"^[가-힣]+$");
    RegExp englishRegex = RegExp(r"^[a-zA-Z]+$");

    if (_name.isEmpty) {
      return '이름을 입력해주세요.';
    }

    if (koreanRegex.hasMatch(_name)) {
      if (_name.length < 2) {
        return '이름은 2글자 이상 입력해주세요.';
      } else if (_name.length > 12) {
        return '이름은 12글자 이하로 입력해주세요.';
      }
    }

    // 영어 이름 검사: 2글자 이상 12글자 이하
    if (englishRegex.hasMatch(_name)) {
      if (_name.length < 2) {
        return '이름은 2글자 이상 입력해주세요.';
      } else if (_name.length > 12) {
        return '이름은 12글자 이하로 입력해주세요.';
      }
    }

    // 기타 조건에 부합하지 않을 경우
    return null;
  }

  void _onNextTap() {
    ref.read(userInfoViewModelProvider.notifier).updateUsername(_name);

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
              '로그인에 사용할',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '이름을 입력해주세요.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.v28,
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                errorText: validateName(),
                hintText: '이름(본명) 입력',
              ),
            ),
            Gaps.v52,
            GestureDetector(
              onTap: _validateName() ? _onNextTap : null,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _validateName()
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
