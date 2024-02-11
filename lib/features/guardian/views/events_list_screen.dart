import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events List'),
      ),
      body: ListView.builder(
        itemCount: 10, // 여기서 목록의 항목 수를 설정하세요.
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Event $index'),
            onTap: () {
              // 클릭하면 해당 사용자의 일주일 동안의 이벤트를 받는 api 호출.
            },
            onLongPress: () {
              // 길게 누르면 삭제함.
            },
          );
        },
      ),
    );
  }
}
