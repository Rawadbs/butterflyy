import 'package:butterfly/blocs/habbitbloc.dart';
import 'package:butterfly/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Make sure this import is present
import 'package:provider/provider.dart';  // Import provider package


void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => HabitBloc(),
        ),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
