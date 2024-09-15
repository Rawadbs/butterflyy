import 'package:butterfly/blocs/habbitbloc.dart';
import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:butterfly/pages/homepage.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => HabitBloc()..add(LoadHabits()),
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
      home: const Onboarding(),
    );
  }
}
