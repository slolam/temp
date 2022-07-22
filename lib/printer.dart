import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:starprinter/starprinter.dart';

class Printer {
   static MethodChannel starPrinter =  const MethodChannel("starprinter");
  List<dynamic> searchPrinterData = [];
  String? portName;

  Printer({this.portName});

  searchPrinter() async {
    searchPrinterData =
        json.decode(await (starPrinter.invokeMethod("searchPrinter")));
    if (kDebugMode) {
      print("searchPrinter---> $searchPrinterData");
    }
    return searchPrinterData;
  }

  static Future<Printer?> getPrinter(
      {required String portName, required int timeOut}) async {
    try {
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
    String createReceiptID = await (starPrinter.invokeMethod("createReceipt",
        {"text": text, "paperSize": paperSize, "portName": portName}));
    return createReceiptID;
  }

  addAlignLeft() async {
    await starPrinter.invokeMethod("addAlignLeft", {
      "portName": portName,
    });
  }

  addAlignRight() async {
    await starPrinter.invokeMethod("addAlignRight", {"portName": portName});
  }

  addAlignCenter() async {
    await starPrinter.invokeMethod("addAlignCenter", {"portName": portName});
  }

  setBlackColor() async {
    await starPrinter.invokeMethod("setBlackColor", {
      "portName": portName,
    });
  }

  setRedColor() async {
    await starPrinter.invokeMethod("setRedColor", {
      "portName": portName,
    });
  }

  addText({
    String? value,
  }) async {
    await starPrinter
        .invokeMethod("addText", {"portName": portName, "value": value});
  }

  addDoubleText({
    String? value,
  }) async {
    await starPrinter
        .invokeMethod("addDoubleText", {"portName": portName, "value": value});
  }

  addBoldText({
    String? value,
  }) async {
    await starPrinter
        .invokeMethod("addBoldText", {"portName": portName, "value": value});
  }

  addUnderlinedText({
    String? value,
  }) async {
    await starPrinter.invokeMethod(
        "addUnderlinedText", {"portName": portName, "value": value});
  }

  addInverseText({
    String? value,
  }) async {
    await starPrinter
        .invokeMethod("addInverseText", {"portName": portName, "value": value});
  }

  addLine() async {
    await starPrinter.invokeMethod("addLine", {
      "portName": portName,
    });
  }

  addImage({required Uint8List? bytes, int width = 0}) async {
    await starPrinter.invokeMethod(
        "addImage", {"portName": portName, "bytes": bytes, "width": width});
  }

  addBarcode({required String? value, required int height}) async {
    await starPrinter.invokeMethod("addBarcode", {
      "value": value,
      "height": height,
    });
  }

  printReceipt({required int delay, required int retry}) async {
    Map<String, dynamic> printStatus = json.decode(await starPrinter
        .invokeMethod("printReceipt",
            {"portName": portName, "delay": delay, "retry": retry}));
    return printStatus;
  }

  void getPlatform() async {
    String? data = await Starprinter().getPlatformVersion();
    if (kDebugMode) {
      print(data);
    }
  }
}
