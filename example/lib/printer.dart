import 'dart:convert';

import 'package:flutter/services.dart';

class Printer {
  MethodChannel starPrinter = const MethodChannel("starPrinter");
  List<dynamic> searchPrinterData = [];
  searchPrinter() async {
    searchPrinterData  =
        json.decode(await (starPrinter.invokeMethod("searchPrinter")));
    return searchPrinterData;
  }

  getPrinter({required String portName, required int timeOut}) async {
    try {
      await (starPrinter.invokeMethod(
          "getPrinter", {"portName": portName, "timeOut": timeOut}));
      return true;
    } catch (e) {
      return false;
    }
  }

  createReceipt({required bool text, required int paperSize}) async {
    Map<String, dynamic> createReceipt = await (starPrinter
        .invokeMethod("createReceipt", {"text": text, "paperSize": paperSize}));
    return createReceipt;
  }
}
