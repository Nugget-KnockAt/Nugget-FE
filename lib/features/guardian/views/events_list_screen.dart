import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nugget/features/guardian/view_models/event_view_model.dart';
import 'package:nugget/features/guardian/views/event_detail_screen.dart';

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
                  title: Text(event.memberName),
                  subtitle: Text(event.locationInfo),
                  trailing: Text(event.createdAt.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          eventId: event.eventId,
                          scrollController: widget.scrollController,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const ListTile(
              title: Text('No events'),
            ),
    );
  }
}
