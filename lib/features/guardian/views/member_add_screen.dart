import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/features/authentication/views/home_screen.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';

class MemberAddScreen extends ConsumerStatefulWidget {
  const MemberAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MemberAddScreenState();
}

class _MemberAddScreenState extends ConsumerState<MemberAddScreen> {
  final TextEditingController _memberEmailController = TextEditingController();

  void _connectMember() async {}

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
