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
  Printer? _printer;
  Receipt? _receipt;
  final TextEditingController _portController =
      new TextEditingController(text: 'BT:TSP100-174736');
  @override
  void initState() {
    super.initState();
    // _printer?.getPlatform();

    //  _printer?.searchPrinter();
    setPrinter();
  }

  setPrinter() async {
    _printer =
        await Printer.getPrinter(portName: 'BT:TSP100-174736', timeOut: 2000);
    debugPrint("_printer =>>>>${_printer?.portName}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: false,
                            controller: _portController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Port Name',
                              hintText: 'Port Name',
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            _receipt = await _printer?.createReceipt(
                              text: true,
                              paperSize: 20,
                            );
                          },
                          child: const Center(
                            child: Text('createReceipt'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _receipt?.addAlignLeft();
                            _receipt?.addAlignCenter();
                            _receipt?.setBlackColor();
                            _receipt?.addText('Shailesh');
                          },
                          child: const Center(
                            child: Text('addAlignLeft'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _printer?.printReceipt(delay: 0, retry: 1);
                          },
                          child: const Center(
                            child: Text('printReceipt'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String testImage =
                                "https://images.pexels.com/photos/3521937/pexels-photo-3521937.jpeg?auto=compress&cs=tinysrgb&h=566.525&fit=crop&w=633.175&dpr=1";
                            Uint8List bytes =
                                (await NetworkAssetBundle(Uri.parse(testImage))
                                        .load(testImage))
                                    .buffer
                                    .asUint8List();
                            _receipt?.addImage(bytes);
                          },
                          child: const Center(
                            child: Text('addImage'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            BarcodeReader barcodeReader = _printer?.getBarcodeReader();
                            barcodeReader.barcodeConnect();
                            barcodeReader.onBarcodeRead.listen((event) {
                              debugPrint("onBarcodeRead $event");
                            });
                          },
                          child: const Center(
                            child: Text('barcode connect'),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var list = await Printer.searchPrinters();
                      debugPrint(' list of printers $list');
                    },
                    child: const Center(
                      child: Text('Search Printers'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
