//하단바의 달력버튼을 누르면 나오는 화면
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TabCalender extends StatefulWidget{
  @override
  State<TabCalender> createState() => _TabCalenderState();
}

class _TabCalenderState extends State<TabCalender> {
  // Define a variable to store the selected date
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    // update the selectedDay variable with the selected date
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;

    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    var url = Uri.parse('http://34.66.37.198/getData');
    var data = {'ID': id, 'date': formattedDate};
    var body = json.encode(data);
    var response = await http.post(url,headers: {"Content-Type": "application/json"},body: body);

    if(response.statusCode == 200) {
      var responseData = json.decode(response.body);
      String emotion = responseData['emotion'];
      String placeName = responseData['placeName'];
      List<String> outfitUrls = List<String>.from(responseData['outfitUrls']);

      Widget emotionBox = Text('Emotion: $emotion');
      Widget placeBox = Text('Place Name: $placeName');
      Widget viewOutfitButton = ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return buildRecommendationDialog(context, outfitUrls);
            },
          );
        },
        child: Text('View Outfit'),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Selected date data'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                emotionBox,
                placeBox,
                viewOutfitButton,
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle errors in case the server request fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to get selected date data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildRecommendationDialog(BuildContext context, List<String> recommendationSet) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: const Color.fromARGB(255, 6, 67, 117),
              title: Text('Attire recommendations'),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Column(
              children: [
                for (int i = 0; i < recommendationSet.length; i++)
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          recommendationSet[i],
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            getRecommendationTitle(i),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getRecommendationTitle(int index) {
    // Return the recommendation title based on the index
    switch (index) {
      case 0:
        return 'Outer';
      case 1:
        return 'Top';
      case 2:
        return 'Bottom';
      case 3:
        return 'Shoes';
      case 4:
        return 'Acc';
      default:
        return '';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('달력'),
      ),
      endDrawer: SafeArea(child: Menu()),
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2021, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        onDaySelected: _onDaySelected, // Call the _onDaySelected function when a day is selected
        selectedDayPredicate: (DateTime day) {
          return isSameDay(selectedDay, day);
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.blue,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            size: 40.0,
          ),
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            size: 40.0,
          ),
        ),
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          todayTextStyle: TextStyle(
            color: Colors.black,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.amber,
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}