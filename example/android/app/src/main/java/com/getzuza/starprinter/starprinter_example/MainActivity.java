package com.getzuza.starprinter.starprinter_example;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

import androidx.annotation.NonNull;

import com.getzuza.starprinterlib.Printer;
import com.google.gson.Gson;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String STAR_PRINTER = "starPrinter";
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
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("searchPrinter")) {
                            result.success( new Gson().toJson(printer.searchPrinters(MainActivity.this)));
                        }else if(call.method.equals("getPrinter")){
                            String portName = call.argument("portName");
                            int timeOut;
                            if( call.argument("timeOut") != null){
                                timeOut = call.argument("timeOut") ;
                            }else{
                                timeOut = 0;
                            }

                            printer.getPrinter(MainActivity.this,portName,timeOut);
                            result.success("");
                        }else if(call.method.equals("createReceipt")){
                            boolean text = call.argument("text");
                            int paperSize = call.argument("paperSize");
                            result.success(new Gson().toJson(printer.createReceipt(true,20)));
                        }
                    }
                });
    }
}
