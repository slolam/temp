import 'dart:convert';

import 'package:flutter/services.dart';

class Printer {
  MethodChannel starPrinter = const MethodChannel("starPrinter");
  Map<String, dynamic> searchPrinterData = {};
  searchPrinter() async {
    searchPrinterData =
        json.decode(await (starPrinter.invokeMethod("searchPrinter")));
    return searchPrinterData;
  }

}
