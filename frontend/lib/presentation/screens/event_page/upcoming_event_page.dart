import 'package:flutter/material.dart';

class UpcomingEventPage extends StatefulWidget {
  @override
  _UpcomingEventPageState createState() => _UpcomingEventPageState();
}

class _UpcomingEventPageState extends State<UpcomingEventPage> {
  int _currentMonthIndex = 9; // October (0-based index: January is 0)
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _previousMonth() {
    setState(() {
      _currentMonthIndex = (_currentMonthIndex - 1) % 12;
      if (_currentMonthIndex < 0) _currentMonthIndex += 12;
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonthIndex = (_currentMonthIndex + 1) % 12;
    });
  }

  void _showEventDetails(
    BuildContext context,
    String eventTitle,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            eventTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(description)]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          CircleAvatar(backgroundImage: AssetImage('assets/jon_doe.jpg')),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Event in ${_months[_currentMonthIndex]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: _previousMonth,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset('assets/alps_tour_image.jpg'),
                    title: Text('Oct 15, 2021'),
                    subtitle: Text('Tour of the Alps\n(~25 Joined)'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showEventDetails(
                          context,
                          'Tour of the Alps',
                          'Embark on an unforgettable journey through the stunning Alpine landscapes, featuring guided hikes, picturesque villages, and opportunities to experience local culture.',
                        );
                      },
                      child: Text('View Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset('assets/food_festival_image.jpg'),
                    title: Text('Oct 15, 2021'),
                    subtitle: Text('AASTU Food Festival\n(~30 Joined)'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showEventDetails(
                          context,
                          'AASTU Food Festival',
                          'Enjoy a rich tapestry of flavors with live cooking demos, food stalls featuring AASTU specialties, and a celebration of culinary innovation.',
                        );
                      },
                      child: Text('View Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('SEE ALL', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset('assets/car_meetup_image.jpg'),
                    title: Text('Oct 15, 2021'),
                    subtitle: Text(
                      'Car Freak Meetup\nBiggest Event in dhaka.join to see the excitemnt of the new car guy\n(~21 Joined)',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Join'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showEventDetails(
                              context,
                              'Car Freak Meetup',
                              'Dive into a car enthusiast’s paradise with showcases of the latest models, expert talks, and a chance to test drive cutting-edge vehicles.',
                            );
                          },
                          child: Text('View Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset('assets/capture_you_image1.jpg'),
                    title: Text('Oct 15, 2021'),
                    subtitle: Text(
                      "Let's Capture You\nBiggest Event in dhaka.join to see the excitemnt of the aesthetic guy\n(~32 Joined)",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Join'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showEventDetails(
                              context,
                              "Let's Capture You",
                              'Capture your best moments at this aesthetic event, featuring photo booths, stylish setups, and a vibrant community of creatives.',
                            );
                          },
                          child: Text('View Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
