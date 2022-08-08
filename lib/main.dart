import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/responsive/mobile_screen_layout.dart';
import 'package:social_media/responsive/responsive_layout_screen.dart';
import 'package:social_media/responsive/web_screen_layout.dart';
import 'package:social_media/screens/login_screen.dart';
import 'package:social_media/screens/signUp_screen.dart';
import 'package:social_media/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB9FMNyTIZ9gOn-jjPVYvyYLjU3sjshnQM",
        appId: "1:768039925012:web:d32ee60dafcbab991dfe01",
        messagingSenderId: "768039925012",
        projectId: "fartagram-60b0d",
        storageBucket: "fartagram-60b0d.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'fartagram',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: Scaffold(
        //   body: const ResponsiveLayout(
        //     mobilescreenLayout: MobileScreenLayout(),
        //     webscreenLayout: WebScreenLayout(),
        //   ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webscreenLayout: WebScreenLayout(),
                  mobilescreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
