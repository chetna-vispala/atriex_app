
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'drawer.dart';
import 'homeui.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice? device;

  @override
  SensorPageState createState() => SensorPageState();
}

class SensorPageState extends State<SensorPage> {
  final String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  late Stream<List<int>> stream;
  late List espData;
  double _palmBt = 0; //palm battery %
  double _remoteBt = 0; //remote battery %
  double _handOpenCloseData = 0; // Palm Charging Count
  var _ShowError = ""; // Remote Charging Count

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  @override
  void dispose() {
    widget.device?.disconnect();
    super.dispose();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _pop();
      }
    });

    await widget.device?.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }
    widget.device?.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _pop();
      return;
    }
    List<BluetoothService> services = await widget.device!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == serviceUUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        }
      }
    }

    if (!isReady) {
      _pop();
    }
  }

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to disconnect device and go back?'),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No')),
          TextButton(
              onPressed: () {
                disconnectFromDevice();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
        ],
      ),
    ));
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

//***************************Enable Button & AppBar***********************//

  bool textBtnswitchState = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vispala'),
          actions: [
            TextButton(
              onPressed: textBtnswitchState ? () {} : null,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    } else {
                      return Colors.white;
                    }
                  },
                ),
              ),
              child: const Text('Enable'),
            ),
            Switch(
              value: textBtnswitchState,
              onChanged: (newState) {
                setState(() {
                  textBtnswitchState = !textBtnswitchState;
                });
              },
              activeColor: Colors.red,
              activeTrackColor: Colors.red[700],
              // inactiveTrackColor: Colors.grey[100],
              inactiveThumbColor: Colors.grey,
            ),
          ],
          actionsIconTheme: const IconThemeData(
            size: 40,
          ),
        ),
        drawer: const MyDrawer(),

//**************************************************//

        body: Container(
          child: !isReady
              ? const Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                ))
              : StreamBuilder<List<int>>(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                  /*  if (snapshot.hasData) {
                      return Text(snapshot.data.toString(),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 40));
                    } */
                    if (snapshot.connectionState == ConnectionState.active) {
                      // geting data from bluetooth
                      var currentValue = _dataParser(snapshot.data!);
                      var espData = currentValue.split(",");
                      if (espData[0] != null) {
                        _palmBt = double.parse(espData[0]);
                      }
                      if (espData[1] != null) {
                        _remoteBt = double.parse(espData[1]);
                      }
                      if (espData[2] != null) {
                        _handOpenCloseData = double.parse(espData[2]);
                      }
                      if (espData[3] != null) {
                        _ShowError =(espData[3]) ;
                      }



                      return HomeUI(
                        espDataR: _remoteBt,
                        espData1: _palmBt,
                        palmCharge: _handOpenCloseData,
                        remoteCharge: _ShowError,
                      );
                  }
                  else {
                      return const Text('Check the stream');
                     }
                  }
                  ),
        ),
      ),
    );
  }
}
