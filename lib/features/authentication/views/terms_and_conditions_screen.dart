import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knock_at/constants/gaps.dart';
import 'package:knock_at/constants/sizes.dart';

class TermsAndConditionsScreen extends ConsumerStatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState
    extends ConsumerState<TermsAndConditionsScreen> {
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
              value: true,
              onChanged: (value) {},
              title: Text(
                '모두 동의 (선택 정보 포함)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (value) {},
              title: Text(
                '[필수] 만 14세 이상',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (value) {},
              title: Text(
                '[필수] 이용약관 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (value) {},
              title: Text(
                '[필수] 개인정보 처리방침 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (value) {},
              title: Text(
                '[필수] 위치기반 서비스 이용약관 동의',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
    );
  }
}
