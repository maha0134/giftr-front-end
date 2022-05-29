import 'package:flutter/material.dart';
import 'package:GIFTR/utils/my_theme.dart';
import 'dart:async'; //for Future
import './data/http_helper.dart'; //our fetch call here
import 'package:GIFTR/screens/add_person_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//screens
import './screens/login_screen.dart';
import './screens/people_screen.dart';
import './screens/gifts_screen.dart';
import './screens/add_person_screen.dart';
import './screens/add_gift_screen.dart';
import 'data/gift.dart';
//data and api classes

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //put the things that are the same on every page here...
    return MaterialApp(
      theme: MyTheme.buildDark(),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  //stateful widget for the main page container for all pages
  // we do this to keep track of current page at the top level
  // the state information can be passed to the BottomNav()
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentScreen = Screen.LOGIN;
  int currentPerson = 0; //use for selecting person for gifts pages.

  DateTime personDOB = DateTime.now(); //right now as default
  var prefs;
  String personID = '';
  String personNAME = '';
  String giftId = '';
  Gift? currentGIFT;
  String actionCalled = '';
  String? token;
  bool isLoggedIn = false;

  @override
  void initState() {
    () async {
      super.initState();
      prefs = await SharedPreferences.getInstance();
      setState(() => {currentScreen = Screen.LOGIN});
    }();
  }

  // to access variables from MainPage use `widget.`
  @override
  Widget build(BuildContext context) {
    return loadBody(currentScreen);
  }

  Widget loadBody(Enum screen) {
    switch (screen) {
      case Screen.LOGIN:
        return LoginScreen(
            prefs: prefs,
            nav: (String nextScreen) {
              print('from login to people ');
              setState(() => {currentScreen = Screen.PEOPLE});
            });
        break;
      case Screen.PEOPLE:
        return PeopleScreen(
          prefs: prefs,
          nav: (
            String nextScreen,
            String id,
            String personName,
            DateTime dob,
          ) async {
            setState(() {
              personDOB = dob;
              personID = id;
              personNAME = personName;
              if (nextScreen == 'add_person') {
                currentScreen = Screen.ADDPERSON;
              } else if (nextScreen == 'gifts') {
                currentScreen = Screen.GIFTS;
              }
            });
          },
          logout: (String nextScreen) async {
            //back to login page
            await prefs.remove('JWT');
            setState(() => currentScreen = Screen.LOGIN);
          },
        );
      case Screen.GIFTS:
        return GiftsScreen(
            prefs: prefs,
            personId: personID,
            personName: personNAME,
            nav: (String nextScreen, String id, String personName,
                Gift? currentGift) {
              switch (nextScreen) {
                case 'add_gift':
                  setState(() {
                    currentGIFT = currentGift;
                    currentScreen = Screen.ADDGIFT;
                  });
                  break;
                case 'people':
                  setState(() {
                    currentScreen = Screen.PEOPLE;
                  });
                  break;
              }
            },
            logout: (String nextScreen) async {
              //back to login page
              await prefs.remove('JWT');
              setState(() => currentScreen = Screen.LOGIN);
            });

      case Screen.ADDPERSON:
        return AddPersonScreen(
          prefs: prefs,
          personID: personID,
          personName: personNAME,
          personDOB: personDOB,
          nav: (String nextScreen) {
            //back to people
            setState(() => currentScreen = Screen.PEOPLE);
          },
          logout: (String nextScreen) async {
            //back to login page
            await prefs.remove('JWT');
            setState(() => currentScreen = Screen.LOGIN);
          },
        );
      case Screen.ADDGIFT:
        return AddGiftScreen(
          prefs: prefs,
          personId: personID,
          personName: personNAME,
          currentGift: currentGIFT,
          nav: (String screen) {
            //go back to list of gifts
            setState(() => currentScreen = Screen.GIFTS);
          },
          logout: (String nextScreen) async {
            //back to login page
            await prefs.remove('JWT');
            setState(() => currentScreen = Screen.LOGIN);
          },
        );
      default:
        return LoginScreen(
            prefs: prefs,
            nav: () {
              setState(() => currentScreen = Screen.LOGIN);
            });
    }
  }
}
