import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi App',
      home: WifiInfoScreen(),
    );
  }
}

class WifiInfoScreen extends StatefulWidget {
  @override
  _WifiInfoScreenState createState() => _WifiInfoScreenState();
}

class _WifiInfoScreenState extends State<WifiInfoScreen> {
  bool _isLoading = false;
  String _wifiInfo = '';

  Future<void> _getWifiInfo() async {
    setState(() {
      _isLoading = true;
    });

    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        String wifiName = await WifiInfo().getWifiName() ?? 'Unknown SSID';
        String wifiBSSID = await WifiInfo().getWifiBSSID() ?? 'Unknown BSSID';
        String wifiIP = await WifiInfo().getWifiIP() ?? 'Unknown IP Address';

        setState(() {
          _wifiInfo = 'SSID: $wifiName\nIP Address: $wifiIP\nBSSID: $wifiBSSID';
        });
      } catch (e) {
        setState(() {
          _wifiInfo = 'Failed to get Wi-Fi info: $e';
        });
      }
    } else {
      setState(() {
        _wifiInfo = 'Location permission is required to get Wi-Fi information.';
      });
    }

    setState(() {
      _isLoading = false;
    });

    _showDialog(context, _wifiInfo);
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wi-Fi Info'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Info'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _getWifiInfo,
                child: Text('Get Wi-Fi Info'),
              ),
      ),
    );
  }
}