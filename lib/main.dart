import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat_flutter/screens/login_screen.dart';
import 'package:fast_chat_flutter/screens/registration_screen.dart';
import 'package:fast_chat_flutter/screens/welcome_screen.dart';
import 'package:fast_chat_flutter/screens/chat_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAKWSCVoixP7YR5kOpqGfD2FTDc6V2ey5I",
      appId: "1:1005981973316:android:71658a03c3056d51967511",
      messagingSenderId: "Messaging sender id here",
      projectId: "chat-flutter-472e5",
    ),
  );
  
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
    
  }
}
