import 'package:flutter/material.dart';
import 'package:heatstroke_app/screens/screens.dart';
import 'package:heatstroke_app/providers/providers.dart';
import 'package:heatstroke_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const AppState());
  initializeDateFormatting('es-MX');
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DayProvider(),
          lazy: false,
        ),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      title: 'Heatstroke App',
      routes: {
        'ScrollDesign': (_) => ScrollDesignScreen(),
        'Home': (_) => const HomeScreen(),
        'Welcome': (_) => const WelcomeScreen(),
        'Settings': (_) => const SettingsScreen(),
        'Notification': (_) => const NotificationScreen(),
      },
      initialRoute: 'Home',
    );
  }
}
