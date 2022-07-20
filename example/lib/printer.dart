import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Printer {
  MethodChannel _starPrinter = MethodChannel("starPrinter");
  List<dynamic> searchPrinterData = [];
  String? portName;

  Printer({this.portName});

  searchPrinter() async {
    searchPrinterData =
        json.decode(await (_starPrinter.invokeMethod("searchPrinter")));
    if (kDebugMode) {
      print("searchPrinter---> $searchPrinterData");
    }
    return searchPrinterData;
  }

  static Future<Printer?> getPrinter(
      {required String portName, required int timeOut}) async {
    try {
       MethodChannel starPrinter = const MethodChannel("starPrinter");
      String _portName = await (starPrinter.invokeMethod(
          "getPrinter", {"portName": portName, "timeOut": timeOut}));
      if (kDebugMode) {
        print("getPrinter--->$_portName");
      }
      Printer printer = Printer(portName: _portName);
      return printer;
    } catch (e) {
      return null;
    }
  }

  createReceipt({
    required bool text,
    required int paperSize,
  }) async {
    String createReceiptID = await (_starPrinter.invokeMethod("createReceipt",
        {"text": text, "paperSize": paperSize, "portName": portName}));
    return createReceiptID;
  }

  addAlignLeft() async {
    await _starPrinter.invokeMethod("addAlignLeft", {
      "portName": portName,
    });
  }

  addAlignRight() async {
    await _starPrinter.invokeMethod("addAlignRight", {"portName": portName});
  }

  addAlignCenter() async {
    await _starPrinter.invokeMethod("addAlignCenter", {"portName": portName});
  }

  setBlackColor() async {
    await _starPrinter.invokeMethod("setBlackColor", {
      "portName": portName,
    });
  }

  setRedColor() async {
    await _starPrinter.invokeMethod("setRedColor", {
      "portName": portName,
    });
  }

  addText({
    String? value,
  }) async {
    await _starPrinter
        .invokeMethod("addText", {"portName": portName, "value": value});
  }

  addDoubleText({
    String? value,
  }) async {
    await _starPrinter
        .invokeMethod("addDoubleText", {"portName": portName, "value": value});
  }

  addBoldText({
    String? value,
  }) async {
    await _starPrinter
        .invokeMethod("addBoldText", {"portName": portName, "value": value});
  }

  addUnderlinedText({
    String? value,
  }) async {
    await _starPrinter.invokeMethod(
        "addUnderlinedText", {"portName": portName, "value": value});
  }

  addInverseText({
    String? value,
  }) async {
    await _starPrinter
        .invokeMethod("addInverseText", {"portName": portName, "value": value});
  }

  addLine() async {
    await _starPrinter.invokeMethod("addLine", {
      "portName": portName,
    });
  }

  addImage({required Uint8List? bytes, int width = 0}) async {
    await _starPrinter.invokeMethod(
        "addImage", {"portName": portName, "bytes": bytes, "width": width});
  }

  printReceipt() async {
    Map<String, dynamic> printStatus = json.decode(await _starPrinter
        .invokeMethod("printReceipt", {"portName": portName}));
    return printStatus;
  }
}
