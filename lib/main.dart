import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'notifiers/BookQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:splashscreen/splashscreen.dart' as s;
//import 'package:flare_splash_screen/flare_splash_screen.dart' as s;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Widgets/dynamic_links_service.dart';
// ignore: unused_import
import 'globals.dart' as globals;
import 'Payment/paymentDetailsaPage.dart';
import 'Config/config.dart';
import 'Config/config2.dart';
import 'notifiers/cartitemcounter.dart';
// ignore: unused_import
import 'Store/myOrders.dart';
import 'package:flutter/services.dart';
import 'notifiers/changeAddresss.dart';
import 'notifiers/totalMoney.dart';
import 'Store/storehome.dart';

double ht;
double wt;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CharityApp.sharedPreferences = await SharedPreferences.getInstance();
  CharityApp.auth = FirebaseAuth.instance;
  CharityApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartItemCounter()),
          ChangeNotifierProvider(create: (_) => BookQuantity()),
          ChangeNotifierProvider(create: (_) => AddressChanger()),
          ChangeNotifierProvider(create: (_) => TotalAmount()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xFFFFD56D), brightness: Brightness.light
              //Colors.deepPurple,
              ),
          home: s.SplashScreen(
            seconds: 5,
            navigateAfterSeconds: FirstTime(),
            //  (context) {

            //   return
            // },
            title: Text(
              'charité',
              textScaleFactor: 3,
            ),
            image: new Image.asset('assets/images/logo2.jpg'),
            loadingText: Text(
              "Have faith in humanity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            photoSize: 160.0,
            loaderColor: Colors.blue,
          ),
          //  s.SplashScreen.navigate(
          //   name: 'assets/flare/splashIntro.flr',
          //   next: (context) {
          //     ht = MediaQuery.of(context).size.height;
          //     dynamic wt = MediaQuery.of(context).size.width;
          //     // ht = ht;
          //     // wt = wt;
          //     return FirstTime();
          //   }, //HomePage(),
          //   startAnimation: 'intro',
          //   backgroundColor: Color(0xff181818),
          //   until: () => Future.delayed(Duration(seconds: 5)),
          // ),
          //SplashScreen()
        ));
  }
}

class FirstTime extends StatefulWidget {
  @override
  FirstTimeState createState() => new FirstTimeState();
}

class FirstTimeState extends State<FirstTime> with AfterLayoutMixin<FirstTime> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) =>
              //OnboardingScreen()));
              SplashScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wt = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: new Center(
        child: SpinKitRotatingCircle(
          color: Colors.amber,
          size: 50.0,
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;
  final fbm = FirebaseMessaging();
  String _message = '';

  _registerOnFirebase() {
    fbm.subscribeToTopic('all');
    fbm.subscribeToTopic('users');
    fbm.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
          print('Link isCalled');
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  startTimer() {
    Timer(Duration(seconds: 2), () async {
      if (await CharityApp.auth.currentUser() != null) {
        Route newRoute = MaterialPageRoute(
            builder: (_) => StoreHome(
                  currentIndex: 2,
                ));
        Navigator.pushReplacement(context, newRoute);
      } else {
        /// Not SignedIn
        Route newRoute = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, newRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: SpinKitRotatingCircle(
            color: Colors.amber,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var pages = [
    PageViewModel(
      titleWidget: Container(
          padding: EdgeInsets.fromLTRB(10, 60, 10, 20),
          child: Text(
            'WELCOME TO charité',
            style: TextStyle(
                fontSize: 20,
                height: 1.5,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          )),
      bodyWidget: Container(
          height: ht - 230,
          width: wt,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            color: Color(0xFFFFD56D),
          ),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'I always wondered why somebody doesn’t do something about that. Then I realized I was somebody.',
                style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
              Image.asset('assets/images/ngo/1.jpg',
                  height: 120,
                  fit: BoxFit.cover,
                  color: Color(0xFFFFD56D),
                  colorBlendMode: BlendMode.darken),
              Text(
                'Whether you’re dedicating your days and nights to the betterment of humanity, or finding some time in your busy schedule to lend a hand, keep it up.',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
      decoration: const PageDecoration(
        boxDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
          padding: EdgeInsets.fromLTRB(10, 60, 10, 20),
          child: Text(
            'WELCOME TO charité',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          )),
      bodyWidget: Container(
          height: ht - 230,
          width: wt,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            color: Color(0xFFFFD56D),
          ),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'It is one of the most beautiful compensations of life, that you cannot sincerely try to help another person without actually helping yourself.',
                style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset('assets/images/child/1.jpg',
                    height: 120,
                    width: 120,
                    color: Color(0xFFFFD56D),
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.cover),
              ),
              Text(
                'At this very moment, there are individuals only you can reach, and differences only you can make in their lives..',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
      decoration: const PageDecoration(
        boxDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    PageViewModel(
      titleWidget: Container(
          padding: EdgeInsets.fromLTRB(10, 60, 10, 20),
          child: Text(
            'WELCOME TO charité',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          )),
      bodyWidget: Container(
          height: ht - 230,
          width: wt,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            color: Color(0xFFFFD56D),
          ),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'You are personally responsible for becoming more ethical than the society you grew up in.',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image.asset('assets/images/oldagehome/11.jpg',
                    color: Color(0xFFFFD56D),
                    colorBlendMode: BlendMode.darken,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover),
              ),
              Text(
                'There are no great people in this world, only great challenges which ordinary people rise to meet.',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'EastSeaDokdo',
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
      decoration: const PageDecoration(
        boxDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFF3F0));
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/new.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: IntroductionScreen(
          pages: pages,
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          },
          showSkipButton: true,
          skip: Icon(
            Icons.skip_next,
            color: Colors.black,
          ),
          next: Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
          done: const Text(
            "Done",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Colors.deepOrange,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ),
      ),
    );
  }
}
