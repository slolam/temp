package com.getzuza.starprinter.starprinter_example;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import android.content.Intent;
import java.io.File;
import java.io.IOException;

//import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String STAR_PRINTER = "starprinter";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        registerChannelForEducationRecordPdfGeneration(flutterEngine);
    }



    private void registerChannelForEducationRecordPdfGeneration(FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STAR_PRINTER).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getPriner")) {
                            result.success("Success");
                        }
                    }
                });
    }
}
