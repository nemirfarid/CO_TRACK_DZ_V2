import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoTrackApp());
}

class CoTrackApp extends StatelessWidget {
  const CoTrackApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CO TRACK DZ', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087E8B)), useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF3F6F8), appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF075B68), foregroundColor: Colors.white)),
    home: const LoginScreen(),
  );
}
