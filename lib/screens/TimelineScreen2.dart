import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronology Timeline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const TimelineScreen(),
    );
  }
}

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollAmount = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHRONOLOGY'),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'timeline infographic',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Timeline(
                  events: generateTimelineEvents(),
                ),
                const SizedBox(height: 24),
                const Text('www.reallygreatsite.com',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset + _scrollAmount,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  List<TimelineEvent> generateTimelineEvents() {
    List<TimelineEvent> events = [];
    int startYear = 1950;
    for (int i = 0; i < 74; i++) {
      int year = startYear + i;
      events.add(TimelineEvent(
        year: year.toString(),
        eventName: 'Event $i',
        eventDescription:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Year: $year',
        color: _getColor(i),
      ));
    }
    return events;
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFFBCE6FF),
      Color(0xFFD0B4FF),
      Color(0xFFB9F6CA),
      Color(0xFFFFD54F),
      Color(0xFFFFB74D),
      Color(0xFFF48FB1),
    ];
    return colors[index % colors.length];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class Timeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const Timeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return TimelineItem(
            event: events[index],
            isFirst: index == 0,
            isLast: index == events.length - 1,
          );
        },
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (!isFirst)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.black38,
                  ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black38),
                ),
                child: Text(
                  event.year,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.black38,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.black38))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.eventDescription,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineEvent {
  final String year;
  final String eventName;
  final String eventDescription;
  final Color color;

  TimelineEvent({
    required this.year,
    required this.eventName,
    required this.eventDescription,
    required this.color,
  });
}
