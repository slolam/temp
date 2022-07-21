package com.getzuza.starprinterlib;

import android.content.Context;
import android.graphics.Color;

import com.starmicronics.stario.StarIOPort;
import com.starmicronics.stario.StarResultCode;
import com.starmicronics.starioextension.ConnectionCallback;
import com.starmicronics.starioextension.StarIoExtManager;
import com.starmicronics.starioextension.StarIoExtManagerListener;

import java.util.concurrent.locks.ReentrantLock;

public class BarcodeReader {

    private static BarcodeReader _instance;

    private StarIoExtManager _manager;

    private ReentrantLock _synchronizer = new ReentrantLock();

    private Context _context;

    private boolean _connected = false;

    private BarcodeCallback _callback;

    public interface BarcodeCallback {
        void onBarcodeRead(String code);
    }

    public BarcodeReader(String portName, Context context) {
        if (_manager != null) {
            _manager.disconnect(_connectionCallback);
            _manager = null;
        }
        _manager = new StarIoExtManager(StarIoExtManager.Type.WithBarcodeReader, portName, "", 10000, context);
        _manager.setListener(_scanCallback);
        _instance = this;
    }

    public StarIOPort getPort() {
        return _manager == null ? null : _manager.getPort();
    }

    public static BarcodeReader getInstance() {
        return _instance;
    }

    private final StarIoExtManagerListener _scanCallback = new StarIoExtManagerListener() {
        @Override
        public void onBarcodeDataReceive(byte[] data) {
        if (_callback != null) {
            _callback.onBarcodeRead(new String(data));
        }
        }
    };

    private final ConnectionCallback _connectionCallback = new ConnectionCallback();

    public void lock() {
        _synchronizer.lock();
    }

    public void unlock() {
        _synchronizer.unlock();
    }

    public void setBarcodeScanner(BarcodeCallback callback) {
        _callback = callback;
    }

    public void connect() {
        _manager.connect(_connectionCallback);
        _connected = true;
    }

    public void disconnect() {
        _manager.disconnect(_connectionCallback);
        _connected = false;
    }
}
