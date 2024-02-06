import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/guardian/views/member_add_screen.dart';

class MemberListScreen extends ConsumerWidget {
  const MemberListScreen(this.scrollController, {super.key});

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
        actions: [
          IconButton(
            iconSize: Sizes.size32,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MemberAddScreen()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 10; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Member $i'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
