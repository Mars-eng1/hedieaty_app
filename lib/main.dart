import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/about_page.dart';
import 'views/account_page.dart';
import 'views/add_friend_page.dart';
import 'views/friend_events_page.dart';
import 'views/friend_gift_list_page.dart';
import 'views/gift_details_page.dart';
import 'views/my_gifts_page.dart';
import 'views/notification_page.dart';
import 'views/profile_page.dart';
import 'views/welcome_page.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'views/home_page.dart';
import 'views/event_list_page.dart';
import 'views/event_details_page.dart';
import 'views/gift_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hedieaty',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(),
          '/friend_events': (context) => FriendEventsPage(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          '/friend_gift_list': (context) => FriendGiftListPage(
            arguments: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
          ),
          '/notifications': (context) => NotificationPage(),
          '/profile': (context) => ProfilePage(),
          '/account': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return AccountPage(arguments: args);
          },
          '/my_gifts': (context) => MyGiftsPage(),
          '/about': (context) => AboutPage(),
          '/add_friend': (context) => AddFriendPage(),
          '/event_list': (context) => EventListPage(),
          '/event_details': (context) {
            final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>? ??
                {};
            return EventDetailsPage(arguments: args);
          },
          '/gift_list': (context) {
            final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>? ??
                {};
            return GiftListPage(arguments: args);
          },
          '/gift_details': (context) {
            final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>? ??
                {};
            return GiftDetailsPage(arguments: args);
          },
        });
  }
}
