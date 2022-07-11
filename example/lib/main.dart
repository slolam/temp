import 'package:flutter/material.dart';
import 'package:futter_starprinter/printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? portName;
  @override
  void initState() {
    super.initState();
    Printer().searchPrinter();
    getPrinter();
  }

  getPrinter() async{
    portName = await Printer().getPrinter(portName: '123.0.0',timeOut: 2000);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Printer().createReceipt(text: true,paperSize: 20, portName: portName);
                },
                child: const Center(
                  child: Text('createReceipt'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Printer().changeStyle(methodName: "setRedColor",portName:portName );
                },
                child: const Center(
                  child: Text('setRedColor'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Printer().printReceipt(portName:portName);
                },
                child: const Center(
                  child: Text('printReceipt'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
