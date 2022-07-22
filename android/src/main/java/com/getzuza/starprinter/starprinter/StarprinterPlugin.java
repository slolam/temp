package com.getzuza.starprinter.starprinter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.getzuza.starprinterlib.Printer;
import com.getzuza.starprinterlib.Receipt;
import com.google.gson.Gson;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** StarprinterPlugin */
public class StarprinterPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private static final String STAR_PRINTER = "starprinter";
  HashMap<String, Printer> printerHashMap = new HashMap<>();
  HashMap<String, Receipt> receiptHashMap = new HashMap<>();
  Activity activity;
  Printer printer;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),"starprinter");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override
      public void run() {
        printer = new Printer(activity);
        Receipt receipt;
        String value;
        switch (call.method) {
          case "searchPrinter":
            result.success(new Gson().toJson(printer.searchPrinters(activity)));
            break;
          case "getPrinter":
            String portName = call.argument("portName");
            int timeOut;
            if (call.argument("timeOut") != null) {
              timeOut = call.argument("timeOut");
            } else {
              timeOut = 0;
            }
            printerHashMap.put(portName, printer.getPrinter(activity, portName, timeOut));
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
          default:
            result.notImplemented();
            break;
        }
      }
    });


  /*  if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }*/
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onDetachedFromActivity(){

  }
  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding){

  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding){
    activity = binding.getActivity();
  }


  @Override
  public void onDetachedFromActivityForConfigChanges(){
  }
}
