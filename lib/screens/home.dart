import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agorastreaming/screens/video.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channelController = TextEditingController();

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora Call"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Join"),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const VideoScreen()));
          },
        ),
      ),
    );
  }
}
