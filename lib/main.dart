import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendance_app/screen/splash_screen.dart';
import 'package:attendance_app/providers/firebase_auth_provider.dart';
import 'package:attendance_app/providers/attendance_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // Add your own Firebase project configuration from google-services.json
        apiKey: 'AIzaSyD7MK6qfBlQL4Bvv22Gfg_yzDd5XAE3GmY', // api_key
        appId:
            '1:602723955945:android:9943b135bccecab85d6c78', // mobilesdk_app_id
        messagingSenderId: '602723955945', // project_number
        projectId: 'attendance-app-afcb3', // project_id
      ),
    );
    // Firebase connection success
    print("Firebase Terhubung ke:");
    print("API Key: ${Firebase.app().options.apiKey}");
    print("Project ID: ${Firebase.app().options.projectId}");
  } catch (e) {
    // Firebase connection failed
    print("Firebase gagal terhubung: $e");
  }
  // runApp(const HomeScreen());
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  // Main App
  const TestApp({super.key}); // Constructor of TestApp clas

  @override // can give information about about your missing override code
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // remove debug banner
        home: const SplashScreen(), // SplashScreen class
      ),
    );
  }
}