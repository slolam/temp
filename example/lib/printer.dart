import 'dart:convert';

import 'package:flutter/services.dart';

class Printer {
  MethodChannel starPrinter = const MethodChannel("starPrinter");
  List<dynamic> searchPrinterData = [];

  searchPrinter() async {
    searchPrinterData =
        json.decode(await (starPrinter.invokeMethod("searchPrinter")));
    return searchPrinterData;
  }

  Future<String?> getPrinter(
      {required String portName, required int timeOut}) async {
    try {
      String printerID = await (starPrinter.invokeMethod(
          "getPrinter", {"portName": portName, "timeOut": timeOut}));
      return printerID;
    } catch (e) {
      return null;
    }
  }

  createReceipt({
    required portName,
    required bool text,
    required int paperSize,
  }) async {
    String createReceiptID = await (starPrinter.invokeMethod("createReceipt",
        {"text": text, "paperSize": paperSize, "portName": portName}));
    return createReceiptID;
  }

  changeStyle(
      {required portName, required String methodName, String? value}) async {
    await starPrinter.invokeMethod("changeStyle",
        {"portName": portName, "methodName": methodName, "value": value});
  }

  printReceipt({required portName}) async {
    Map<String, dynamic> printStatus =
    json.decode(await starPrinter.invokeMethod("printReceipt", {"portName": portName}));
    return printStatus;
  }
}
