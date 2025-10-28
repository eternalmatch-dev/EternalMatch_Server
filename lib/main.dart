import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  testHttp(); // اختبار HTTP بديل Alova

  runApp(MyApp());
}

// دالة لاختبار HTTP
void testHttp() async {
  try {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos/1"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("HTTP response: $data");
    } else {
      print("HTTP error: ${response.statusCode}");
    }
  } catch (e) {
    print("HTTP exception: $e");
  }
}

// دالة لاختبار الاتصال بخادم Render
void testServer() async {
  try {
    final response = await http.get(
      Uri.parse("https://eternal-token-server.onrender.com/"),
    );
    if (response.statusCode == 200) {
      print("Server response: ${response.body}");
    } else {
      print("Server error: ${response.statusCode}");
    }
  } catch (e) {
    print("Server exception: $e");
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static const String appId = "b9cc185dc37e4e62b1494ace01c08778"; // ضع App ID الخاص بك هنا
  int? _remoteUid;
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
    analytics.logEvent(name: "test_event");
    testServer(); // اختبار الاتصال بخادم Render
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    await AgoraRtcEngine.create(appId);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.startPreview();

    AgoraRtcEngine.onJoinChannelSuccess = (channel, uid, elapsed) {
      setState(() {
        _joined = true;
      });
      print('Joined channel: $channel, uid: $uid');
    };

    AgoraRtcEngine.onUserJoined = (uid, elapsed) {
      setState(() {
        _remoteUid = uid;
      });
      print('Remote user joined: $uid');
    };

    AgoraRtcEngine.onUserOffline = (uid, reason) {
      setState(() {
        _remoteUid = null;
      });
      print('Remote user left: $uid');
    };

    await AgoraRtcEngine.joinChannel(null, "testChannel", null, 0);
  }

  @override
  void dispose() {
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase + HTTP + Agora Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Check your Terminal for HTTP output'),
              SizedBox(height: 20),
              _joined
                  ? Container(
                      width: 300,
                      height: 400,
                      color: Colors.black,
                      child: _remoteUid != null
                          ? AgoraRtcEngineVideoView(uid: _remoteUid!)
                          : Center(
                              child: Text(
                                'Waiting for remote user...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    )
                  : Text('Joining channel...'),
            ],
          ),
        ),
      ),
    );
  }
}