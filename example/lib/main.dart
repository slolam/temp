import 'package:flutter/material.dart';
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
  BarcodeReader? _barcodeReader;
  String? barcodeReadData;
  List<dynamic> printersList = [];
  final TextEditingController _portController =
      TextEditingController(text: 'BT:TSP100-174736');
  @override
  void initState() {
    super.initState();
  }

  setPrinter() async {
    _printer =
        await Printer.getPrinter(portName: _portController.text, timeOut: 2000);
    debugPrint("_printer =>>>>${_printer?.portName}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Start Printer example app'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        obscureText: false,
                        controller: _portController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: OutlineInputBorder(),
                          labelText: 'Port Name',
                          hintText: 'Port Name',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          printersList = await Printer.searchPrinters();
                          debugPrint(' list of printers $printersList');
                        },
                        child: const Center(
                          child: Text('SEARCH'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setPrinter();
                          /*  _receipt = await _printer?.createReceipt(
                            text: true,
                            paperSize: 20,
                          );*/
                        },
                        child: const Center(
                          child: Text('CLICK'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setPrinter();
                          _receipt = await _printer?.createReceipt(
                            text: true,
                            paperSize: 20,
                          );
                        },
                        child: const Center(
                          child: Text('TEXT'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setPrinter();
                          _receipt = await _printer?.createReceipt(
                            text: false,
                            paperSize: 20,
                          );
                        },
                        child: const Center(
                          child: Text('GRAPHIC'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _barcodeReader = _printer?.getBarcodeReader();
                          _barcodeReader?.barcodeConnect();
                          _barcodeReader?.onBarcodeRead.listen((event) {
                            setState(() {
                              barcodeReadData = event;
                            });
                            debugPrint("onBarcodeRead=>>>> $event");
                          });
                        },
                        child: const Center(
                          child: Text('BARCODE START'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _barcodeReader?.disconnect();
                        },
                        child: const Center(
                          child: Text('BARCODE STOP'),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        barcodeReadData ?? "Dummy place holder",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: const [
                          Expanded(child: Text("PORT")),
                          Expanded(child: Text("MAC ADDRESS")),
                          Expanded(child: Text("MODEL")),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              children:  [
                                Expanded(child: Text(printersList[index]['macAddress'])),
                                Expanded(child: Text(printersList[index]['modelName'])),
                                Expanded(child: Text(printersList[index]['portName'])),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                height: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            );
                          },
                          itemCount: printersList.length)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
