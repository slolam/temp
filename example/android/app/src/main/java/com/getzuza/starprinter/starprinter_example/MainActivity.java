package com.getzuza.starprinter.starprinter_example;


import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

import androidx.annotation.NonNull;

import com.getzuza.starprinterlib.Printer;
import com.getzuza.starprinterlib.PrinterStatus;
import com.getzuza.starprinterlib.Receipt;
import com.google.gson.Gson;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Random;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String STAR_PRINTER = "starPrinter";
    HashMap<String, Printer> printerHashMap = new HashMap<>();
    HashMap<String, Receipt> receiptHashMap = new HashMap<>();
    Printer printer = new Printer(MainActivity.this);
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        registerChannelForPrinter(flutterEngine);
    }

    private void registerChannelForPrinter(FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STAR_PRINTER).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NotNull MethodCall call, MethodChannel.Result result) {
                        Receipt receipt;
                        String value;
                        switch (call.method) {
                            case "searchPrinter":
                                result.success(new Gson().toJson(printer.searchPrinters(MainActivity.this)));
                                break;
                            case "getPrinter":
                                String portName = call.argument("portName");
                                int timeOut;
                                if (call.argument("timeOut") != null) {
                                    timeOut = call.argument("timeOut");
                                } else {
                                    timeOut = 0;
                                }
                                printerHashMap.put(portName, printer.getPrinter(MainActivity.this, portName, timeOut));
                                result.success(portName);
                                break;
                            case "createReceipt":
                                 portName = call.argument("portName");
                                boolean text = call.argument("text");
                                int paperSize = call.argument("paperSize");
                                Printer printer = printerHashMap.get(portName);
                                if (printer != null) {
                                    receiptHashMap.put(portName,printer.createReceipt(text, paperSize));
                                    result.success(portName);
                                }
                                break;
                            case "addAlignLeft":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.addAlignLeft();
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addAlignRight":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.addAlignRight();
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addAlignCenter":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.addAlignCenter();
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "setBlackColor":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.setBlackColor();
                                break;

                            case "setRedColor":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.setRedColor();
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addText":
                                portName = call.argument("portName");
                                value = call.argument("value");
                                receipt = receiptHashMap.get(portName);
                                receipt.addText(value);
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addDoubleText":
                                portName = call.argument("portName");
                                String methodName = call.argument("methodName");
                                value = call.argument("value");
                                receipt = receiptHashMap.get(portName);
                                receipt.addDoubleText(value);
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addBoldText":
                                portName = call.argument("portName");
                                value = call.argument("value");
                                receipt = receiptHashMap.get(portName);
                                receipt.addBoldText(value);
                                break;

                            case "addUnderlinedText":
                                portName = call.argument("portName");
                                value = call.argument("value");
                                receipt = receiptHashMap.get(portName);
                                receipt.addUnderlinedText(value);
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addInverseText":
                                portName = call.argument("portName");
                                value = call.argument("value");
                                receipt = receiptHashMap.get(portName);
                                receipt.addInverseText(value);
                                receiptHashMap.put(portName,receipt);
                                break;

                            case "addLine":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                receipt.addLine();
                                receiptHashMap.put(portName,receipt);
                                break;
                            case "addImage":
                                portName = call.argument("portName");
                                receipt = receiptHashMap.get(portName);
                                byte[] bytes = call.argument("bytes");
                                Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0,
                                        bytes.length);
                                int width = call.argument("width");
                                receipt.addImage(bitmap,width);
                                receiptHashMap.put(portName,receipt);
                                break;
                            case "printReceipt":
                                portName = call.argument("portName");
                                int delay = call.argument("delay");
                                int retry = call.argument("retry");
                                printer = printerHashMap.get(portName);
                                receipt = receiptHashMap.get(portName);
                                if(printer != null && receipt != null){
                                    printer.printReceipt(receipt,delay,retry,status -> {
                                        result.success(new Gson().toJson(status));
                                    });
                                }
                                break;
                        }
                    }
                });
    }

}


