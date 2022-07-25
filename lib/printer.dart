import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel starPrinter = MethodChannel("getzuza.starprinter");

class Printer {
  String portName;

  Printer({required this.portName});

  static Future<List<dynamic>> searchPrinters() async {
    List<dynamic> searchPrinterData =
        json.decode(await (starPrinter.invokeMethod("searchPrinters")));

    debugPrint("searchPrinter---> $searchPrinterData");

    return searchPrinterData;
  }

  static Future<Printer?> getPrinter(
      {required String portName, required int timeOut}) async {
    try {
      portName = await (starPrinter.invokeMethod(
          "getPrinter", {"portName": portName, "timeOut": timeOut}));

      debugPrint("getPrinter--->$portName");

      return Printer(portName: portName);
    } catch (e) {
      return null;
    }
  }

  Future<Receipt?> createReceipt({
    required bool text,
    required int paperSize,
  }) async {
    await starPrinter.invokeMethod("createReceipt",
        {"text": text, "paperSize": paperSize, "portName": portName});
    return Receipt(portName: portName);
  }

  printReceipt({required int delay, required int retry}) async {
    Map<String, dynamic> printStatus = json.decode(await starPrinter
        .invokeMethod("printReceipt",
            {"portName": portName, "delay": delay, "retry": retry}));
    return printStatus;
  }
}

class Receipt {
  String portName;

  Receipt({required this.portName});

  void addAlignLeft() async {
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

  addText(
    String? value,
  ) async {
    await starPrinter
        .invokeMethod("addText", {"portName": portName, "value": value});
  }

  addDoubleText(
    String? value,
  ) async {
    await starPrinter
        .invokeMethod("addDoubleText", {"portName": portName, "value": value});
  }

  addBoldText({
    String? value,
  }) async {
    await starPrinter
        .invokeMethod("addBoldText", {"portName": portName, "value": value});
  }

  addUnderlinedText(
    String? value,
  ) async {
    await starPrinter.invokeMethod(
        "addUnderlinedText", {"portName": portName, "value": value});
  }

  addInverseText(
    String? value,
  ) async {
    await starPrinter
        .invokeMethod("addInverseText", {"portName": portName, "value": value});
  }

  addLine() async {
    await starPrinter.invokeMethod("addLine", {
      "portName": portName,
    });
  }

  addImage(Uint8List? bytes, {int width = 0}) async {
    await starPrinter.invokeMethod(
        "addImage", {"portName": portName, "bytes": bytes, "width": width});
  }

  addBarcode(String? value, {required int height}) async {
    await starPrinter.invokeMethod("addBarcode", {
      "value": value,
      "height": height,
    });
  }
}
