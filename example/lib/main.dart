import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tun_flutter/tun_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _vpnStarted = false;
  int _tun_fd = 0;
  final _tunFlutterPlugin = TunFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool vpnStarted;
    int tun_fd;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _tunFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      vpnStarted = await _tunFlutterPlugin.startVpn({
            'nodeAddr': '5b4:86cf:d8db:87ee:3c:ab49:ef82:8f81',
          }) ??
          false;
    } on PlatformException {
      vpnStarted = false;
    }

    // TODO FIXME
    // The TUN device creation happened in the Kotlin code in async way,
    // and we currently don't have mechanism to send data initiated from Kotlin.
    // So, we need to poll the Tun FD existance.
    // We also currently don't have good simple solution to poll the data,
    // so we do sleep for now.
    await Future.delayed(Duration(seconds: 3));

    try {
      tun_fd = await _tunFlutterPlugin.getTunFD() ?? 0;
    } on PlatformException {
      tun_fd = 0;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _vpnStarted = vpnStarted;
      _tun_fd = tun_fd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(
              'Running on: $_platformVersion\nvpnStarted: $_vpnStarted \ntun_fd: $_tun_fd \n'),
        ),
      ),
    );
  }
}
