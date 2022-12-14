import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agorastreaming/main.dart';
import 'package:agorastreaming/widgets/duration_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/constants.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool frontCamera = true;
  bool localMuted = false;
  bool remoteMuted = false;
  bool remoteVideoEnabled = true;
  bool localVideoEnabled = true;
  ConnectionStateType connectionState =
      ConnectionStateType.connectionStateConnecting;

  QualityType localQuality = QualityType.qualityDetecting;
  QualityType remoteQuality = QualityType.qualityDetecting;

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    //_engine.leaveChannel();
    _engine.release(sync: true);
    super.dispose();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, int uid, int elapsed) {
          print("elapsedonUserJoined : $elapsed");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Remote user joined the call")));
          setState(() {
            _remoteUid = uid;
          });
        },
        onUserOffline: (connection, int uid, UserOfflineReasonType reasonType) {
          print("leave reason${reasonType.name}");
          setState(() {
            _remoteUid = null;
          });
          _engine.leaveChannel();
        },
        onConnectionLost: (connection) {
          print("connection lost");
        },
        onLeaveChannel: (connection, stats) {
          print("connectionduration : ${stats.duration}");
          Navigator.of(context).pop();

          showDialog(
              context: navKey.currentContext!,
              builder: (context) => DurationDialog(
                    duration: stats.duration!,
                  ));
        },
        onConnectionStateChanged: (RtcConnection connection,
            ConnectionStateType stateType,
            ConnectionChangedReasonType reasonType) {
          print("onConnectionStateChanged");
          print(stateType.name);
          print(reasonType.name);
          setState(() {
            connectionState = stateType;
          });
          if (reasonType == ConnectionChangedReasonType.connectionChangedLost) {
            _engine.leaveChannel();
          }
        },
        onNetworkQuality: (RtcConnection connection, int uid,
            QualityType txQuality, QualityType rxQuality) {
          print("onNetworkQuality");
          print(uid);
          print(txQuality.name);
          print(rxQuality.name);
          if (uid == 0) {
            localQuality = txQuality;
            if (txQuality == QualityType.qualityPoor ||
                txQuality == QualityType.qualityBad ||
                txQuality == QualityType.qualityVbad) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Poor connection")));
            }
          } else {
            remoteQuality = txQuality;
          }
          setState(() {});
        },
        onRemoteVideoStateChanged: (RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed) {
          print("onRemoteVideoStateChanged");
          print(state.name);
          setState(() {
            if (state == RemoteVideoState.remoteVideoStateStopped) {
              remoteVideoEnabled = false;
            } else {
              remoteVideoEnabled = true;
            }
          });
        },
        onRejoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("onRejoinChannelSuccess");
        },
      ),
    );

    await _engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions());
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          _localVideo(),
        ],
      ),
    );
  }

  //call button bar
  Widget _buttonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Icon(localMuted ? Icons.mic_off : Icons.mic),
          ),
          onTap: () {
            setState(() {
              localMuted = !localMuted;
            });
            _engine.muteLocalAudioStream(localMuted);
          },
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.cameraswitch),
          ),
          onTap: () {
            setState(() {
              frontCamera = !frontCamera;
            });
            _engine.switchCamera();
          },
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Icon(remoteMuted ? Icons.volume_off : Icons.volume_up),
          ),
          onTap: () {
            setState(() {
              remoteMuted = !remoteMuted;
            });
            _engine.muteRemoteAudioStream(uid: _remoteUid!, mute: remoteMuted);
          },
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Icon(localVideoEnabled
                ? Icons.videocam_off_outlined
                : Icons.videocam_off),
          ),
          onTap: () {
            setState(() {
              localVideoEnabled = !localVideoEnabled;
            });
            _engine.enableLocalVideo(localVideoEnabled);
          },
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.call_end),
          ),
          onTap: () {
            _engine.leaveChannel();
          },
        ),
      ],
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return Stack(children: [
        remoteVideoEnabled
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: _remoteUid),
                    connection: const RtcConnection(channelId: channelName)),
              )
            : Center(child: Image.asset("assets/images/user.png")),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buttonBar(),
          ),
        ),
        if ((connectionState ==
                    ConnectionStateType.connectionStateReconnecting ||
                connectionState ==
                    ConnectionStateType.connectionStateConnecting ||
                remoteQuality == QualityType.qualityUnknown) &&
            remoteVideoEnabled)
          const Center(
              child: Text(
            "Trying to reconnect...",
            style: TextStyle(fontSize: 18),
          )),
      ]);
    } else {
      return const Text(
        'Please wait for remote user to join...',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }
  }

  // Display local user's video
  Widget _localVideo() {
    return localVideoEnabled
        ? Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              width: 130,
              height: 180,
              child: Center(
                child: (_localUserJoined)
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          )
        : Container();
  }
}
