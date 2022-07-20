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
                            case "changeStyle":
                                portName = call.argument("portName");
                                String methodName = call.argument("methodName");
                                String value = call.argument("value");
                                Receipt receipt = receiptHashMap.get(portName);
                                if (methodName != null && receipt != null) {
                                    switch (methodName) {
                                        case "addAlignLeft":
                                            receipt.addAlignLeft();
                                            break;

                                        case "addAlignRight":
                                            receipt.addAlignRight();
                                            break;

                                        case "addAlignCenter":
                                            receipt.addAlignCenter();
                                            break;

                                        case "setBlackColor":
                                            receipt.setBlackColor();
                                            break;

                                        case "setRedColor":
                                            receipt.setRedColor();
                                            break;

                                        case "addText":
                                            receipt.addText(value);
                                            break;

                                        case "addDoubleText":
                                            receipt.addDoubleText(value);
                                            break;

                                        case "addBoldText":
                                            receipt.addBoldText(value);
                                            break;

                                        case "addUnderlinedText":
                                            receipt.addUnderlinedText(value);
                                            break;

                                        case "addInverseText":
                                            receipt.addInverseText(value);
                                            break;

                                        case "addLine":
                                            receipt.addLine();
                                            break;
                                        case "addImage":
                                            byte[] bytes = call.argument("bytes");
                                            Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0,
                                                    bytes.length);
                                            int width = call.argument("width");
                                            receipt.addImage(bitmap,width);
                                            break;
                                        case "addBarcode":
                                            String height = call.argument("height");
                                            receipt.addBarcode(value,height);
                                            break;
                                    }
                                    receiptHashMap.put(portName,receipt);
                                }
                                break;

                            case "printReceipt":
                                portName = call.argument("portName");
                                printer = printerHashMap.get(portName);
                                receipt = receiptHashMap.get(portName);
                                if(printer != null && receipt != null){
                                    printer.printReceipt(receipt,0,1,status -> {
                                        result.success(new Gson().toJson(status));
                                    });
                                }
                                break;
                        }
                    }
                });
    }

}


