import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agorastreaming/screens/call.dart';
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
        child: GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CallScreen()));
          },
          child: Container(
            width: 200,
            height: 50,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 32,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              color: Colors.white.withOpacity(0.3),
            ),
            child: const Center(
              child: Text('Join', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}
