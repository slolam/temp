package com.getzuza.starprinter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

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
public class StarprinterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  class PrinterReceipt {
    public Printer printer;
    public Receipt receipt;

    public PrinterReceipt(Printer printer) {
      this.printer = printer;
    }
  }
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private static final String STAR_PRINTER = "getzuza.starprinter";
  private HashMap<String, PrinterReceipt> printerReceipts = new HashMap<>();
  private Activity activity;
  BarcodeReader barcodeReader;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),STAR_PRINTER);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override
      public void run() {
        PrinterReceipt printer;
        String value;
        switch (call.method) {
          case "searchPrinters":
            result.success(new Gson().toJson(Printer.searchPrinters(activity)));
            break;
          case "getPrinter":
            String portName = call.argument("portName");
            int timeOut;
            if (call.argument("timeOut") != null) {
              timeOut = call.argument("timeOut");
            } else {
              timeOut = 30000;
            }
            printerReceipts.put(portName, new PrinterReceipt(Printer.getPrinter(activity, portName, timeOut)));
            result.success(portName);
            break;
          case "createReceipt":
            portName = call.argument("portName");
            boolean text = call.argument("text");
            int paperSize = call.argument("paperSize");
            printer = printerReceipts.get(portName);
            if (printer != null) {
              printer.receipt = printer.printer.createReceipt(text, paperSize);
              result.success(portName);
            } 
            break;
          case "addAlignLeft":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.addAlignLeft();
            break;

          case "addAlignRight":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.addAlignRight();
            break;

          case "addAlignCenter":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.addAlignCenter();
            break;

          case "setBlackColor":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.setBlackColor();
            break;

          case "setRedColor":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.setRedColor();
            break;

          case "addText":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addText(value);
            break;

          case "addDoubleText":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addDoubleText(value);
            break;

          case "addBoldText":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addBoldText(value);
            break;

          case "addUnderlinedText":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addUnderlinedText(value);
            break;

          case "addInverseText":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addInverseText(value);
            break;

          case "addLine":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.addLine();
            break;
          case "addImage":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            byte[] bytes = call.argument("bytes");
            Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0,
                    bytes.length);
            int width = call.argument("width");
            printer.receipt.addImage(bitmap,width);
            break;
          case "addBarcode":
            portName = call.argument("portName");
            value = call.argument("value");
            int height = call.argument("height");
            printer = printerReceipts.get(portName);
            printer.receipt.addBarcode(value,height);
          case "addQrCode":
            portName = call.argument("portName");
            value = call.argument("value");
            printer = printerReceipts.get(portName);
            printer.receipt.addQrCode(value);
            break;
          case "openCashDrawer":
            portName = call.argument("portName");
            int drawer = call.argument("drawer");
            printer = printerReceipts.get(portName);
            printer.receipt.openCashDrawer(drawer);
            break;
          case "cutPaper":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.cutPaper();
            break;
          case "setCommand":
            portName = call.argument("portName");
            String command = call.argument("command");
            printer = printerReceipts.get(portName);
            printer.receipt.setCommand(command);
            break;
          case "closeReceipt":
            portName = call.argument("portName");
            printer = printerReceipts.get(portName);
            printer.receipt.closeReceipt();
            break;
          case "printReceipt":
            portName = call.argument("portName");
            int delay = call.argument("delay");
            int retry = call.argument("retry");
            printer = printerReceipts.get(portName);
            if (printer != null) {
              printer.printer.printReceipt(printer.receipt,delay,retry,status -> {
                result.success(new Gson().toJson(status));
              });
            }
            break;
          case "connect":
            portName = call.argument("portName");
            barcodeReader = new BarcodeReader(portName,activity);

            barcodeReader.setBarcodeScanner(new BarcodeReader.BarcodeCallback() {
              @Override
              public void onBarcodeRead(String code) {
                 HashMap<String, String> barcode = new HashMap<>();
                barcode.put("code",code);
                channel.invokeMethod("onBarcodeRead",barcode);
              }
            });
            break;
          case "disconnect":
            portName = call.argument("portName");
            barcodeReader.disconnect();
          default:
            result.notImplemented();
            break;
        }
      }
    });

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
