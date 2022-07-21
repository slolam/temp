import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starprinter/printer.dart';

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
  Printer? _printer = Printer();
  @override
  void initState() {
    super.initState();
   // _printer?.getPlatform();

  //  _printer?.searchPrinter();
    setPrinter();
  }

  setPrinter() async {
    _printer = await Printer.getPrinter(portName: '123.0.0', timeOut: 2000);
    print("_printer =>>>>${_printer?.portName}");
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
                onTap: () {
                  _printer?.createReceipt(
                    text: true,
                    paperSize: 20,
                  );
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
                onTap: () {
                  _printer?.addAlignLeft();
                },
                child: const Center(
                  child: Text('addAlignLeft'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _printer?.printReceipt(delay: 0,retry: 1);
                },
                child: const Center(
                  child: Text('printReceipt'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  String testImage =
                      "https://images.pexels.com/photos/3521937/pexels-photo-3521937.jpeg?auto=compress&cs=tinysrgb&h=566.525&fit=crop&w=633.175&dpr=1";
                  Uint8List bytes =
                      (await NetworkAssetBundle(Uri.parse(testImage))
                              .load(testImage))
                          .buffer
                          .asUint8List();
                  _printer?.addImage(bytes: bytes);
                },
                child: const Center(
                  child: Text('addImage'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
