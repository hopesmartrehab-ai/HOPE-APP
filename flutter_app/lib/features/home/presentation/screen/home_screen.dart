import 'package:flutter/material.dart';
import 'package:hope_app/core/shared_widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const GradientBackground(
        child: Center(child: Text('Welcome to the Home Screen!')),
      ),
    );
  }
}
