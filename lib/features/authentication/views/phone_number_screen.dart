import 'package:flutter/material.dart';
import 'package:knock_at/constants/gaps.dart';
import 'package:knock_at/constants/sizes.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key, required this.onNext});

  final Function onNext;

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(() {
      setState(() {
        _phoneNumber = _phoneNumberController.text;
      });
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();

    super.dispose();
  }

  bool _validateNumber() {
    RegExp phoneNumberRegex = RegExp(r"^[0-9]+$");

    if (_phoneNumber.isEmpty) {
      return false;
    }

    if (phoneNumberRegex.hasMatch(_phoneNumber)) {
      return _phoneNumber.length == 11;
    }

    // 기타 조건에 부합하지 않을 경우
    return false;
  }

  String? validateNumber() {
    RegExp phoneNumberRegex = RegExp(r"^[0-9]+$");

    if (_phoneNumber.isEmpty) {
      return '휴대폰 번호를 입력해주세요.';
    }

    if (phoneNumberRegex.hasMatch(_phoneNumber)) {
      if (_phoneNumber.length != 11) {
        return '휴대폰 번호는 11자리입니다.';
      }
    }
    return null;
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
              '휴대폰 번호를',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '입력해주세요.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.v28,
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorText: validateNumber(),
                hintText: '휴대폰 번호 입력 (숫자만 입력) (ex. 01012345678)',
              ),
            ),
            Gaps.v52,
            GestureDetector(
              onTap: _validateNumber() ? () => widget.onNext() : null,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _validateNumber()
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
