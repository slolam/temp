package com.getzuza.starprinterlib;

public class PrinterInfo {

    public PrinterInfo(String portName, String address, String modelName) {
        this.portName = portName;
        this.macAddress = address;
        this.modelName = modelName;
    }
    public final String portName;
    public final String macAddress;
    public final String modelName;
}
