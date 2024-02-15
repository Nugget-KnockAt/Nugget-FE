import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
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
          child: eventDetailState.when(
            data: (eventDetail) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventDetailInfo(
                    label: 'Name: ',
                    value: eventDetail.memberName,
                  ),
                  Gaps.v32,
                  EventDetailInfo(
                    label: 'Location: ',
                    value: eventDetail.locationInfo,
                  ),
                  Gaps.v32,
                  EventDetailInfo(
                    label: 'Message: ',
                    value: eventDetail.text,
                  ),
                  Gaps.v32,
                  EventDetailInfo(
                    label: 'Date: ',
                    value: eventDetail.createdAt.toString(),
                  ),
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
          ),
        ),
      ),
    );
  }
}

class EventDetailInfo extends StatelessWidget {
  const EventDetailInfo({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            '$label ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
