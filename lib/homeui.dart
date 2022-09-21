import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:battery_plus/battery_plus.dart';

class HomeUI extends StatefulWidget {
  final double espData1; // 1st Progress Bar
  final double espDataR; // 2nd Progress Bar
  final double palmCharge; // 3rd Progress Bar
  var remoteCharge; // 4th Progress Bar

  HomeUI({Key? key,
      required this.espData1,
      required this.espDataR,
      required this.palmCharge,
      required this.remoteCharge})
      : super(key: key);

  @override
  HomeUIState createState() => HomeUIState();
}

class HomeUIState extends State<HomeUI> {
//************************** Battery function *******************************//
  var battery = Battery();
  int? percentage;
  late Timer timer;
  BatteryState batteryState = BatteryState.full;
  late StreamSubscription streamSubscription;
  int counter = 0;

  bool _buttonPressed = false;
  bool _loopActive = false;

  void _increaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    while (_buttonPressed) {
      // do your thing
      setState(() {
        if (counter >= 0 && counter < 100) {
          counter++;
        }
      });
      // wait a bit
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _loopActive = false;
  }

  void _decreaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    while (_buttonPressed) {
      // do your thing
      setState(() {
        if (counter > 1) {
          counter--;
        }
      });
      // wait a bit
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _loopActive = false;
  }

  @override
  void initState() {
    super.initState();
    getBatteryPercentage();
    getBatteryState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryPercentage();
    });
  }

  void getBatteryPercentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  void getBatteryState() async {
    streamSubscription = battery.onBatteryStateChanged.listen((state) {
      setState(() {
        batteryState = state;
      });
    });
  }

  Widget buildBattery(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return Builder(builder: (context) {
          return const Icon(
            Icons.battery_full,
            size: 100,
            color: Colors.green,
          );
        });

      case BatteryState.charging:
        return const Icon(Icons.battery_charging_full,
            size: 100, color: Colors.blue);

      case BatteryState.discharging:
      default:
        return const Icon(Icons.battery_std, size: 100, color: Colors.red);
    }
  }

  @override
  //****************************** progressbar page them *************************//
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: Scaffold(
        body: CustomScrollView(primary: false, slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                // ****************************** 1st progressbar(Palm Battery) ************************* //
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildBattery(batteryState),
                      Text(
                        '${widget.espData1} %',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ],
                  ),
                ),

                // ****************************** 2nd progressbar ************************* //
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildBattery(batteryState),
                      Text(
                        '${widget.espDataR} %',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ],
                  ),
                ),

                // ****************************** 3rd progressbar ************************* //
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                            trackWidth: 10,
                            progressBarWidth: 12,
                            shadowWidth: 4),
                        customColors: CustomSliderColors(
                            trackColor: HexColor('#e2f7e2'),
                            progressBarColor: HexColor('#00fe07'),
                            //shadowColor: HexColor('#B2EBF2'),
                            //shadowMaxOpacity: 0.5, //);
                            shadowStep: 0.1),
                        infoProperties: InfoProperties(
                            bottomLabelStyle: TextStyle(
                                color: HexColor('#6DA100'),
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                            bottomLabelText: 'Palm BatteryCh Data',
                            mainLabelStyle: TextStyle(
                                color: HexColor('#54826D'),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                            modifier: (double value) {
                              return '${widget.palmCharge} ';
                            }),
                        startAngle: 90,
                        angleRange: 360,
                        size: 100, // Circle Dia
                        animationEnabled: true),
                    min: 0,
                    max: 100,
                    initialValue: widget.palmCharge,
                  ),
                ),

// ****************************** 4th progressbar ************************* //
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      "${widget.remoteCharge} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // ****************************** Open/Close Button ************************* //
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: ElevatedButton(
                          onPressed: () {
                            _increaseCounterWhilePressed();
                          },style: ElevatedButton.styleFrom(
                          primary: Colors.green),
                          child: Text("OPEN")),
                    ),
                  ),
                ),
               //**************ButtonOutput**************//
                Center(
                  child: Text(
                    "Output value= ${counter}",
                    style: const TextStyle(fontSize: 28, color: Colors.red),
                  ),
                ),
                ////*******************Close****************////
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: (Colors.grey[100])!,
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _decreaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: ElevatedButton(
                          onPressed: () {
                            _decreaseCounterWhilePressed();
                          },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red),
                            child: Text("CLOSE")
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// ********************************************* Custom ******************************** //
