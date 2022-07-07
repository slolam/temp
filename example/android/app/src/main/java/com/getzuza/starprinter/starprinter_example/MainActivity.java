package com.getzuza.starprinter.starprinter_example;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import java.util.List;
import java.util.stream.Collectors;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import static com.getzuza.starprinterlib.Printer.searchPrinters;

public class MainActivity extends FlutterActivity {
    private static final String STAR_PRINTER = "starPrinter";
    String searchPrinter;
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
                            searchPrinter = new Gson().toJson(searchPrinters(MainActivity.this));
                            result.success(searchPrinter);
                        }
                    }
                });
    }
}
