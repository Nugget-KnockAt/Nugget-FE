import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/features/guardian/view_models/event_detail_view_model.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({
    super.key,
    required this.scrollController,
    required this.eventId,
  });

  final ScrollController scrollController;
  final int eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventDetailState = ref.watch(eventDetailModelProvider(eventId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Detail'),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size32,
            vertical: Sizes.size32,
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineSmall!,
              child: eventDetailState.when(
                data: (eventDetail) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Name: '),
                          Expanded(
                            child: Text(
                              eventDetail.memberName,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Location: '),
                          Expanded(
                            child: Text(
                              eventDetail.locationInfo,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Message: '),
                          Expanded(
                            child: Text(
                              eventDetail.text,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) {
                  return Center(
                    child: Text('Error: $error'),
                  );
                },
              )),
        ),
      ),
    );
  }
}
