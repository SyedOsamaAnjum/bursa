import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AAArticle.dart';
import 'package:bursa_app/Screens/AATeamEvent.dart';
import 'package:bursa_app/Screens/AdminPanel/AdminNavigationBar.dart';
import 'package:bursa_app/Screens/AdminPanel/AgentAssignScreen.dart';
import 'package:bursa_app/Screens/AdminPanel/UpdateCaseStudy.dart';
import 'package:bursa_app/Screens/AdminPanel/EventUpdate.dart';
import 'package:bursa_app/Screens/AdminPanel/UpdatePoster.dart';
import 'package:bursa_app/Screens/AdminPanel/UserList.dart';
import 'package:bursa_app/Screens/AgentPanel/AgentBottomNavigationBar.dart';
import 'package:bursa_app/Screens/AgentPanel/AgentDashboard.dart';
import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/AnnouncementGlobal.dart';
import 'package:bursa_app/Screens/AnnouncementMalaysia.dart';
import 'package:bursa_app/Screens/Announcements.dart';
import 'package:bursa_app/Screens/BottomNavigation/BottomNavigationScreen.dart';
import 'package:bursa_app/Screens/BottomNavigation/EtfCharts.dart';
import 'package:bursa_app/Screens/BottomNavigation/FutureChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/LeapChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/MarketPlace.dart';
import 'package:bursa_app/Screens/BottomNavigation/MyEvents.dart';
import 'package:bursa_app/Screens/BottomNavigation/ReitChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/StockList.dart';
import 'package:bursa_app/Screens/BottomNavigation/WarrantChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/WatchList.dart';
import 'package:bursa_app/Screens/BottomNavigation/stripePayment.dart';
import 'package:bursa_app/Screens/CaseStudyList.dart';
import 'package:bursa_app/Screens/CaseStudyScreen.dart';
import 'package:bursa_app/Screens/Entitlement.dart';
import 'package:bursa_app/Screens/EventVideoPlayer.dart';
import 'package:bursa_app/Screens/FutureReportScreen.dart';
import 'package:bursa_app/Screens/LearnScreen.dart';
import 'package:bursa_app/Screens/LogReg/ForgetPasswordScreen.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Screens/LogReg/RegisterationScreen.dart';
import 'package:bursa_app/Screens/LogReg/RegistrationOTP.dart';
import 'package:bursa_app/Screens/LogReg/ResetPasswordScreen.dart';
import 'package:bursa_app/Screens/NewsDetailScreen.dart';
import 'package:bursa_app/Screens/NewsFeedScreen.dart';
import 'package:bursa_app/Screens/Profile.dart';
import 'package:bursa_app/Screens/ResearchScreen.dart';
import 'package:bursa_app/Screens/Screener.dart';
import 'package:bursa_app/Screens/SplashScreen.dart';
import 'package:bursa_app/Screens/StockDetailScreen.dart';
import 'package:bursa_app/Screens/VideoPlayerScreen.dart';
import 'package:bursa_app/model/StockData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Screens/EventDetailScreen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Firebase.initializeApp();
  runApp(
    // DevicePreview(
    //   // enabled: !kReleaseMode,
    //   builder: (context) => MyApp(),
    // ),
      MyApp()
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => StockData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
          scaffoldBackgroundColor: black
        ),
        initialRoute: SplashScreen.id,

        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          RegistrationOTP.id: (context) => RegistrationOTP(),
          ForgetPasswordScreen.id: (context) => ForgetPasswordScreen(),
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          BottomNavigationScreen.id: (context) => BottomNavigationScreen(),
          StockDetailScreen.id: (context) => StockDetailScreen(),
          NewsFeedScreen.id: (context) => NewsFeedScreen(),
          NewsDetailScreen.id: (context) => NewsDetailScreen(),
          ResearchScreen.id: (context) => ResearchScreen(),
          AnnouncementGlobal.id: (context) => AnnouncementGlobal(),
          AnnouncementMalaysia.id: (context) => AnnouncementMalaysia(),
          Announcement.id: (context) => Announcement(),
          Entitlement.id: (context) => Entitlement(),
          Screener.id: (context) => Screener(),
          AdminNavigationBar.id: (context) => AdminNavigationBar(),
          UserList.id: (context) => UserList(),
          AgentAssignScreen.id: (context) => AgentAssignScreen(),
          AgentDashboard.id: (context) => AgentDashboard(),
          ChatScreen.id: (context) => ChatScreen(),
          LearnScreen.id: (context) => LearnScreen(),
          VideoPlayerScreen.id: (context) => VideoPlayerScreen(),
          AAArticle.id: (context) => AAArticle(),
          AATeamEvent.id: (context) => AATeamEvent(),
          ProfileScreen.id: (context) => ProfileScreen(),
          AgentBottomNavigation.id: (context) => AgentBottomNavigation(),
          MarketPlace.id:(context) => MarketPlace(),
          StockList.id:(context) => StockList(),
          WatchList.id: (context) => WatchList(),
          FutureChart.id: (context) => FutureChart(),
          WarrantChart.id: (context) => WarrantChart(),
          ReitChart.id: (context) => ReitChart(),
          EtfChart.id: (context) => EtfChart(),
          LeapChart.id: (context) => LeapChart(),
          EventUpdate.id: (context) => EventUpdate(),
          FutureReportScreen.id: (context) => FutureReportScreen(),
          EventDetailScreen.id: (context) => EventDetailScreen(),
          EventVideoPlayer.id: (context) => EventVideoPlayer(),
          UpdatePoster.id: (context) => UpdatePoster(),
          Payment.id: (context) => Payment(),
          CaseStudyScreen.id: (context) => CaseStudyScreen(),
          AACaseStudy.id: (context) => AACaseStudy(),
          UpdateCaseStudy.id: (context) => UpdateCaseStudy(),
          MyEvents.id: (context) => MyEvents()
        },
      ),
    );
  }
}

