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
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;

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
      ) /*Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "channel id"),
            ),
            const SizedBox(
              height: 20,
            ),
            RadioListTile(
              title: const Text("clientRoleBroadcaster"),
              onChanged: (ClientRoleType? value) {
                setState(() {
                  _role = value!;
                });
              },
              value: ClientRoleType.clientRoleBroadcaster,
              groupValue: _role,
            ),
            RadioListTile(
              title: const Text("clientRoleAudience"),
              onChanged: (ClientRoleType? value) {
                setState(() {
                  _role = value!;
                });
              },
              value: ClientRoleType.clientRoleAudience,
              groupValue: _role,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                elevation: 0.0,
              ),
              child: const Text("join"),
            ),
          ],
        ),
      )*/
      ,
    );
  }

  Future onJoin() async {
    if (_channelController.text.isNotEmpty) {
      await [Permission.microphone, Permission.camera].request();

      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => VideoScreen()));
    }
  }
}
