import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  Printer().addAlignLeft(portName:portName );
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
                onTap: (){
                  Printer().printReceipt(portName:portName);
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
                onTap: () async{
                  String testImage = "https://images.pexels.com/photos/3521937/pexels-photo-3521937.jpeg?auto=compress&cs=tinysrgb&h=566.525&fit=crop&w=633.175&dpr=1";
                  Uint8List bytes = (await NetworkAssetBundle(Uri.parse(testImage))
                      .load(testImage))
                      .buffer
                      .asUint8List();
                  Printer().addImage(portName: portName, bytes: bytes);
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
