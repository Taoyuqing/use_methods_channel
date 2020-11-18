import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String channelName = "samples.flutter.dev/battery";
  static const _platform = const MethodChannel(channelName);
  String _batteryLevel = 'Unknown battery level.';
  dynamic _invokeInfo = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _platform.setMethodCallHandler(platformCallHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child:
                      Text('原生通过invokeMethod和flutter通信，获取到的信息是: $_invokeInfo'),
                  onPressed: () {
                    _makeNativeInvokeFlutter();
                  }),
              RaisedButton(
                  child: Text('原生通过result和flutter通信，获取到的信息是：$_batteryLevel'),
                  onPressed: () {
                    _getBatteryLevel();
                  }),
            ],
          ),
        ));
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future _makeNativeInvokeFlutter() async {
    _platform.invokeMapMethod("makeNativeInvokeFlutter",
        {"content": "please invoke flutter methods"});
  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "makeNativeInvokeFlutter":
        setState(() {
          _invokeInfo = call.arguments;
        });
        break;
      default:
    }
  }
}
