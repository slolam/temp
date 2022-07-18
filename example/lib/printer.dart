import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Printer {
  MethodChannel starPrinter = const MethodChannel("starPrinter");
  List<dynamic> searchPrinterData = [];

  searchPrinter() async {
    searchPrinterData =
        json.decode(await (starPrinter.invokeMethod("searchPrinter")));
    print("abcd=>>>> "+searchPrinterData.toString());
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

  addAlignLeft({
    required portName,
  }) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "addAlignLeft",
    });
  }

  addAlignRight({
    required portName,
  }) async {
    await starPrinter.invokeMethod(
        "changeStyle", {"portName": portName, "methodName": "addAlignRight"});
  }

  addAlignCenter({
    required portName,
  }) async {
    await starPrinter.invokeMethod(
        "changeStyle", {"portName": portName, "methodName": "addAlignCenter"});
  }

  setBlackColor({
    required portName,
  }) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "setBlackColor",
    });
  }

  setRedColor({
    required portName,
  }) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "setRedColor",
    });
  }

  addText({
    required portName,
    String? value,
  }) async {
    await starPrinter.invokeMethod("changeStyle",
        {"portName": portName, "methodName": "addText", "value": value});
  }

  addDoubleText({
    required portName,
    String? value,
  }) async {
    await starPrinter.invokeMethod("changeStyle",
        {"portName": portName, "methodName": "addDoubleText", "value": value});
  }

  addBoldText({
    required portName,
    String? value,
  }) async {
    await starPrinter.invokeMethod("changeStyle",
        {"portName": portName, "methodName": "addBoldText", "value": value});
  }

  addUnderlinedText({
    required portName,
    String? value,
  }) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "addUnderlinedText",
      "value": value
    });
  }

  addInverseText({
    required portName,
    String? value,
  }) async {
    await starPrinter.invokeMethod("changeStyle",
        {"portName": portName, "methodName": "addInverseText", "value": value});
  }

  addLine({
    required portName,
  }) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "addLine",
    });
  }

  addImage(
      {required portName,
      required Uint8List? bytes,
      required int width}) async {
    await starPrinter.invokeMethod("changeStyle", {
      "portName": portName,
      "methodName": "addImage",
      "bytes": bytes,
      "width": width
    });
  }

  printReceipt({required portName}) async {
    Map<String, dynamic> printStatus = json.decode(
        await starPrinter.invokeMethod("printReceipt", {"portName": portName}));
    return printStatus;
  }
}
