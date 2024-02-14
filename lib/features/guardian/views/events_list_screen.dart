import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/guardian/models/user_detail_model.dart';
import 'package:nugget/features/guardian/view_models/event_view_model.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({
    super.key,
    required this.memberEmail,
    required this.scrollController,
  });

  final String memberEmail;
  final ScrollController scrollController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(eventViewModelProvider.notifier).fetchEvents(widget.memberEmail);
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events List'),
      ),
      body: eventsState.isNotEmpty
          ? ListView.builder(
              controller: widget.scrollController,
              itemCount: eventsState.length,
              itemBuilder: (context, index) {
                final event = eventsState[index];
                return ListTile(
                  title: Text(event.memberEmail),
                  subtitle: Text(event.locationInfo),
                  // 기타 필요한 UI 요소 추가
                );
              },
            )
          : const ListTile(
              title: Text('No events'),
            ),
    );
  }
}
