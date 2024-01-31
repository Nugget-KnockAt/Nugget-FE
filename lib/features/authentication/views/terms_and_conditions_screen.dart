import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';

import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';

class TermsAndConditionsScreen extends ConsumerStatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState
    extends ConsumerState<TermsAndConditionsScreen> {
  void _onTapSignUp() {
    if (ref.read(userInfoViewModelProvider).agreedToAll) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Container();
          },
        ),
      );
    }
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
              'Nugget 서비스 이용약관에',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '동의해주세요',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.v28,
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: ref.watch(userInfoViewModelProvider).agreedToAll,
              onChanged: (value) {
                ref
                    .read(userInfoViewModelProvider.notifier)
                    .updateAgreedToAll(value!);
              },
              title: Text(
                '모두 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: ref.watch(userInfoViewModelProvider).isOverFourteen,
              onChanged: (value) {
                ref
                    .read(userInfoViewModelProvider.notifier)
                    .updateIsOverFourteen(value!);
              },
              title: Text(
                '[필수] 만 14세 이상',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: ref.watch(userInfoViewModelProvider).ageedToTermsOfUse,
              onChanged: (value) {
                ref
                    .read(userInfoViewModelProvider.notifier)
                    .updateAgreedToTermsOfUse(value!);
              },
              title: Text(
                '[필수] 이용약관 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: ref.watch(userInfoViewModelProvider).agreedToPrivacyPolicy,
              onChanged: (value) {
                ref
                    .read(userInfoViewModelProvider.notifier)
                    .updateAgreedToPrivacyPolicy(value!);
              },
              title: Text(
                '[필수] 개인정보 처리방침 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value:
                  ref.watch(userInfoViewModelProvider).agreedToLocationService,
              onChanged: (value) {
                ref
                    .read(userInfoViewModelProvider.notifier)
                    .updateAgreedToLocationService(value!);
              },
              title: Text(
                '[필수] 위치기반 서비스 이용약관 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: _onTapSignUp,
        child: BottomAppBar(
          color: ref.watch(userInfoViewModelProvider).agreedToAll
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.only(
            top: Sizes.size32,
          ),
          child: Text(
            '동의하고 가입하기',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
