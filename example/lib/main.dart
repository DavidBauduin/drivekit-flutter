import 'package:drivekit/data/drivekit_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:drivekit/drivekit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements DriveKitListener {
  final _drivekitPlugin = Drivekit();
  bool _isDriveKitConfigured = false;
  bool _isUserConnected = false;
  bool _isAutoStartEnabled = false;
  String _apiKey = '';
  String _userId = '';
  final apiKeyController = TextEditingController();
  final userIdController = TextEditingController();

  @override
  void dispose() {
    apiKeyController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _drivekitPlugin.setDriveKitListener(this);
    updateIsDriveKitConfigured();
    updateIsUserConnected();
    updateAutoStartEnabled();
    initApiKey();
    initUserId();
  }

  Future<void> updateIsDriveKitConfigured() async {
    bool isDriveKitConfigured;
    try {
      isDriveKitConfigured = await _drivekitPlugin.isDriveKitConfigured();
    } on PlatformException {
      isDriveKitConfigured = false;
    }

    if (!mounted) return;

    setState(() {
      _isDriveKitConfigured = isDriveKitConfigured;
    });
  }

  Future<void> updateIsUserConnected() async {
    bool isUserConnected;
    try {
      isUserConnected = await _drivekitPlugin.isUserConnected();
    } on PlatformException {
      isUserConnected = false;
    }

    if (!mounted) return;

    setState(() {
      _isUserConnected = isUserConnected;
    });
  }

  Future<void> updateAutoStartEnabled() async {
    bool isAutoStartEnabled;
    try {
      isAutoStartEnabled = await _drivekitPlugin.isAutoStartEnabled();
    } on PlatformException {
      isAutoStartEnabled = false;
    }

    if (!mounted) return;

    setState(() {
      _isAutoStartEnabled = isAutoStartEnabled;
    });
  }

  Future<void> initApiKey() async {
    String? apiKey;
    try {
      apiKey = await _drivekitPlugin.getApiKey();
    } on PlatformException {
      apiKey = '';
    }

    if (!mounted) return;

    setState(() {
      if (apiKey != null) {
        _apiKey = apiKey;
      }
      apiKeyController.text = _apiKey;
    });
  }

  Future<void> initUserId() async {
    String? userId;
    try {
      userId = await _drivekitPlugin.getUserId();
    } on PlatformException {
      userId = '';
    }

    if (!mounted) return;

    setState(() {
      if (userId != null) {
        _userId = userId;
      }
      userIdController.text = _userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DriveKit example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Is DriveKit configured: $_isDriveKitConfigured\n'),
            ),
            Center(
              child: Text('Is user connected: $_isUserConnected\n'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: apiKeyController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter the api key',
                  labelText: 'Api key',
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Set api key'),
              onPressed: () {
                _drivekitPlugin.setApiKey(apiKeyController.text);
                updateIsDriveKitConfigured();
                updateIsUserConnected();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter your userId',
                  labelText: 'UserId',
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Set userId'),
              onPressed: () {
                _drivekitPlugin.setUserId(userIdController.text);
                updateIsDriveKitConfigured();
                updateIsUserConnected();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Text('Enabled auto start: '),
                  Switch(
                    value: _isAutoStartEnabled,
                    onChanged: (bool value) {
                      _drivekitPlugin.enableAutoStart(value);
                      updateAutoStartEnabled();
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('request location permission'),
              onPressed: () {
                _drivekitPlugin.requestIOSLocationPermission();
              },
            ),
            ElevatedButton(
              child: const Text('request activity permission'),
              onPressed: () {
                _drivekitPlugin.requestIOSActivityPermission();
              },
            ),
            ElevatedButton(
              child: const Text('request bluetooth permission'),
              onPressed: () {
                _drivekitPlugin.requestIOSBluetoothPermission();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onAccountDeleted(DeleteAccountStatus status) {
    debugPrint('===== onAccountDeleted - status = $status');
  }

  @override
  void onAuthenticationError(RequestError errorType) {
    debugPrint('===== onAuthenticationError - errorType = $errorType');
  }

  @override
  void onConnected() {
    updateIsUserConnected();
    debugPrint('===== onConnected');
  }

  @override
  void onDisconnected() {
    updateIsUserConnected();
    debugPrint('===== onDisconnected');
  }

  @override
  void userIdUpdateStatus(UpdateUserIdStatus status, String? userId) {
    debugPrint('===== userIdUpdateStatus - status = $status - userId = $userId');
  }
}
