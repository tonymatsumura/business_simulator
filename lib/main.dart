import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'providers/game_state.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA8IytufarAxdkeTK03I26rDmnNcxtAIcQ",
        authDomain: "vorteix.firebaseapp.com",
        projectId: "vorteix",
        storageBucket: "vorteix.firebasestorage.app",
        messagingSenderId: "601863123234",
        appId: "1:601863123234:web:d2227f9e0aad8f97c6757b",
        measurementId: "G-8XWDXTB9J8",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Business Simulator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: GameScreen(),
      ),
    );
  }
}
