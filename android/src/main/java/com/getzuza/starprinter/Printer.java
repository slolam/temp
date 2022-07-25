package com.getzuza.starprinter;

import android.content.Context;
import android.graphics.Typeface;
import android.util.Log;

import com.starmicronics.stario.PortInfo;
import com.starmicronics.stario.StarIOPort;

import java.io.Console;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class Printer {

    public static final int TIMEOUT = 10000;

    private static final String Class = "Printer";

    private static final ConcurrentHashMap<String, ExecutorService> _printerQueue = new ConcurrentHashMap<>();

    public String portName;

    private Context _context;

    private int _timeout;

    public float fontSize = 24.5f;

    public String fontName = "Menlo";

    public Printer(Context context, String portName, int timeout) {
        _context = context;
        this.portName = portName;
        _timeout = timeout;
    }
    public Printer(Context context) {
        _context = context;
    }
    
    public interface PrinterCallback {
        void onResponse(PrinterStatus status);
    }

    private static final String[] PrinterTypes = new String[]{"TCP:", "BT:", "USB:"};

    public static PrinterInfo[] searchPrinters(Context context) {
        List<PortInfo> list = new ArrayList<>();
        for (String type : PrinterTypes) {
            try {
                list.addAll(StarIOPort.searchPrinter(type, context));
            } catch (Exception e) {
                // DO NOTHING
                Log.e(Class, "Error occured " + e.getMessage());
            }
        }

        PrinterInfo[] retVal = new PrinterInfo[list.size()];

        for (int i = 0; i < list.size(); i++) {
            PortInfo port = list.get(i);
            retVal[i] = new PrinterInfo(port.getPortName(), port.getMacAddress(), port.getModelName());
        }

        return retVal;
    }

    public static Printer getPrinter(Context context, String portName, int timeout) {
        return new Printer(context, portName, timeout);
    }

    public Receipt createReceipt(boolean text, int paperSize) {
        Receipt receipt = Receipt.createReceiptFromText(_context, text, Languages.LanguageEnglish, paperSize);
        receipt.setFont(Typeface.MONOSPACE);
        receipt.setFontSize(fontSize);

        Log.e(Class, "Receipt created");
        return receipt;
    }

    public void printReceipt(Receipt receipt, float delay, int retry, PrinterCallback callback) {

        ExecutorService queue = _printerQueue.get(portName);

        if(queue == null) {
            synchronized (_printerQueue) {
                queue = _printerQueue.get(portName);
                if(queue == null) {
                    Log.e(Class,"Creating queue for " + portName);
                    queue = Executors.newSingleThreadExecutor();
                    _printerQueue.put(portName, queue);
                }
            }
        }

        queue.submit(new PrintJob(_context, portName, _timeout, delay, retry, receipt._builder, callback));
    }

}
