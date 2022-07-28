import 'dart:async';
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
        await (starPrinter.invokeMethod("searchPrinters"));

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
    return Receipt(portName: portName, text: text);
  }

  Future<Map<String, dynamic>> printReceipt(
      {required int delay, required int retry}) async {
    Map<String, dynamic> printStatus = json.decode(await starPrinter
        .invokeMethod("printReceipt",
            {"portName": portName, "delay": delay, "retry": retry}));
    return printStatus;
  }

  getBarcodeReader() {
    return BarcodeReader(portName: portName);
  }
}

class BarcodeReader {
  String portName;
  StreamController onBarcodeReadController = StreamController.broadcast();

  BarcodeReader({required this.portName}) {
    starPrinter.setMethodCallHandler(_didReceiveTranscript);
  }

  Stream get onBarcodeRead => onBarcodeReadController.stream;

  Future<void> _didReceiveTranscript(MethodCall call) async {
    switch (call.method) {
      case "onBarcodeRead":
        final Map<String, dynamic> args =
            call.arguments.cast<String, dynamic>();
        onBarcodeReadController.add(args['code']);
        break;
    }
  }

  barcodeConnect() async {
    await starPrinter.invokeMethod("connect", {"portName": portName});
  }

  disconnect() async {
    onBarcodeReadController.close();
    await starPrinter.invokeMethod("disconnect", {"portName": portName});
  }
}

class Receipt {
  String portName;
  bool text = false;

  Receipt({required this.portName, required bool text});

  Future<void> addAlignLeft() async {
    await starPrinter.invokeMethod("addAlignLeft", {
      "portName": portName,
    });
  }

  Future<void> addAlignRight() async {
    await starPrinter.invokeMethod("addAlignRight", {"portName": portName});
  }

  Future<void> addAlignCenter() async {
    await starPrinter.invokeMethod("addAlignCenter", {"portName": portName});
  }

  Future<void> setBlackColor() async {
    await starPrinter.invokeMethod("setBlackColor", {
      "portName": portName,
    });
  }

  Future<void> setRedColor() async {
    await starPrinter.invokeMethod("setRedColor", {
      "portName": portName,
    });
  }

  Future<void> addText(
    String value,
  ) async {
    await starPrinter
        .invokeMethod("addText", {"portName": portName, "value": value});
  }

  Future<void> addDoubleText(
    String value,
  ) async {
    await starPrinter
        .invokeMethod("addDoubleText", {"portName": portName, "value": value});
  }

  Future<void> addBoldText(
    String value,
  ) async {
    await starPrinter
        .invokeMethod("addBoldText", {"portName": portName, "value": value});
  }

  Future<void> addUnderlinedText(
    String value,
  ) async {
    await starPrinter.invokeMethod(
        "addUnderlinedText", {"portName": portName, "value": value});
  }

  Future<void> addInverseText(
    String value,
  ) async {
    await starPrinter
        .invokeMethod("addInverseText", {"portName": portName, "value": value});
  }

  Future<void> addLine() async {
    await starPrinter.invokeMethod("addLine", {
      "portName": portName,
    });
  }

  Future<void> addImage(Uint8List bytes, {int width = 0}) async {
    await starPrinter.invokeMethod(
        "addImage", {"portName": portName, "bytes": bytes, "width": width});
  }

  Future<void> addBarcode(String value, int height) async {
    await starPrinter.invokeMethod("addBarcode", {
      "portName": portName,
      "value": value,
      "height": height,
    });
  }

  Future<void> addQrCode(String value) async {
    await starPrinter.invokeMethod("addQrCode", {
      "portName": portName,
      "value": value,
    });
  }

  Future<void> openCashDrawer({required int drawer}) async {
    await starPrinter.invokeMethod("openCashDrawer", {
      "portName": portName,
      "drawer": drawer,
    });
  }

  Future<void> cutPaper() async {
    await starPrinter.invokeMethod("cutPaper", {
      "portName": portName,
    });
  }

  Future<void> setCommand(String command) async {
    await starPrinter.invokeMethod("setCommand", {
      "portName": portName,
      "command": command,
    });
  }

  Future<void> setFontSize(double size) async {
    await starPrinter
        .invokeMethod("setFontSize", {"portName": portName, "size": size});
  }

  Future<void> setFontSizeSmall() async {
    if (text) {
      setCommand('\x1B\x68\x00\x1B\x57\x00');
    } else {
      setFontSize(24.5);
    }
  }

  Future<void> setFontSizeMedium() async {
    if (text) {
      setCommand('\x1B\x68\x00\x1B\x57\x01');
    } else {
      setFontSize(26.5);
    }
  }

  Future<void> setFontSizeLarge() async {
    if (text) {
      setCommand('\x1B\x68\x01\x1B\x57\x01');
    } else {
      setFontSize(29);
    }
  }

  Future<void> closeReceipt() async {
    await starPrinter.invokeMethod("closeReceipt", {
      "portName": portName,
    });
  }

  Future<Map<dynamic, dynamic>> print(double delay, int retry) async {
    return await starPrinter.invokeMethod(
        "printReceipt", {"portName": portName, "delay": delay, "retry": retry});
  }
}
