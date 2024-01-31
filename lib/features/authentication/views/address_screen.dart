import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';

import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:kpostal/kpostal.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key, required this.onNext});

  final Function onNext;

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends ConsumerState<AddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();

  String _address = '';
  String _detailAddress = '';

  @override
  void initState() {
    super.initState();

    _addressController.addListener(() {
      setState(() {
        _address = _addressController.text;
      });
    });

    _detailAddressController.addListener(() {
      setState(() {
        _detailAddress = _detailAddressController.text;
      });
    });
  }

  String? validateNumber() {
    if (_address.isEmpty) {
      return '주소를 입력해주세요.';
    }

    return null;
  }

  bool _validateNumber() {
    return validateNumber() == null;
  }

  void _onTapAddressSearch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KpostalView(
          callback: (Kpostal result) {
            setState(
              () {
                _addressController.text = result.address;
              },
            );
          },
        ),
      ),
    );
  }

  void _onNextTap() {
    final address = '$_address $_detailAddress';

    ref.read(userInfoViewModelProvider.notifier).updateAddress(address);
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
              '주소를',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '입력해주세요.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _onTapAddressSearch,
              child: TextField(
                controller: _addressController,
                enabled: false,
                decoration: InputDecoration(
                  errorText: validateNumber(),
                  hintText: '주소 검색',
                ),
              ),
            ),
            Gaps.v20,
            TextField(
              controller: _detailAddressController,
              decoration: const InputDecoration(
                hintText: '상세 주소 입력',
              ),
            ),
            Gaps.v52,
            GestureDetector(
              onTap: _validateNumber() ? _onNextTap : null,
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
