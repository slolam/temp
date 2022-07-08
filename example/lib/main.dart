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
  @override
  void initState() {
    super.initState();
    Printer().searchPrinter();
    Printer().getPrinter(portName: '123.0.0',timeOut: 2000);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Printer().createReceipt(text: true,paperSize: 20);
          },
          child: const Center(
            child: Text('Running on: '),
          ),
        ),
      ),
    );
  }
}
