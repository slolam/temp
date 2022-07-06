package android.StarPrinterLib.src.main.java.com.getzuza.starprinterlib;

import android.content.Context;
import android.util.Log;

import com.starmicronics.stario.StarIOPort;
import com.starmicronics.stario.StarIOPortException;
import com.starmicronics.stario.StarPrinterStatus;
import com.starmicronics.stario.StarResultCode;
import com.starmicronics.starioextension.ICommandBuilder;

public class PrintJob implements Runnable {

    private static final String Class = "PrintJob";

    private String _portName;

    private Context _context;

    private int _timeout;

    private ICommandBuilder _builder;

    private int _retry;
    private long _delay;

    private Printer.PrinterCallback _callback;

    PrintJob(Context context, String portName, int timeout, float delay, int retry, ICommandBuilder builder, Printer.PrinterCallback callback) {
        _context = context;
        _portName = portName;
        _timeout = timeout;
        _builder = builder;
        _callback = callback;
        _retry = retry;
        _delay = (long)(delay * 1000);

        if(_delay < 500) {
            _delay = 500;
        } else if(_delay > 2500) {
            _delay = 2500;
        }
    }


    @Override
    public void run() {
        StarIOPort port = null;
        PrinterStatus status = new PrinterStatus();

        BarcodeReader bcr = BarcodeReader.getInstance();

        boolean sharedPort = bcr != null && bcr.getPort().getPortName() == _portName;

        do {
            try {
                status.printed = false;

                if(sharedPort) {
                    bcr.lock();
                    port = bcr.getPort();
                } else {
                    port = StarIOPort.getPort(_portName, "", Printer.TIMEOUT, _context);
                }

                if (port == null) {
                    status.error = "Cannot connect to the printer";
                    _callback.onResponse(status);
                    return;
                }

                StarPrinterStatus ps;

                ps = port.beginCheckedBlock();

                if (status.offline) {
                    status.error = "Printer is offline.";
                    throw new StarIOPortException(status.error);
                }

                byte[] data = _builder.getCommands();

                port.writePort(data, 0, data.length);

                port.setEndCheckedBlockTimeoutMillis(_timeout);

                ps = port.endCheckedBlock();

                if (ps.coverOpen) {
                    status.error = "Printer cover is open";
                    throw new StarIOPortException(status.error);
                } else if (ps.receiptPaperEmpty) {
                    status.error = "Receipt paper is empty";
                    throw new StarIOPortException(status.error);
                } else if (status.offline) {
                    status.error = "Printer is offline";
                    throw new StarIOPortException(status.error);
                }

                status.printed = true;
                status.error = null;

            } catch (StarIOPortException e) {
                status.error = e.getMessage();
            }
            finally {
                if (port != null) {
                    try {
                        if(sharedPort) {
                            bcr.unlock();
                        } else {
                            StarIOPort.releasePort(port);
                        }
                    } catch (StarIOPortException e) {
                        // Nothing
                    }
                    port = null;
                }
            }
            if(status.printed) {
                _callback.onResponse(status);
                return;
            }
            if(_retry > 0){
                Log.e(Class, String.format("Retring on port %s remaining %d sleeping for %d", _portName, _retry, _delay));
                try {
                    Thread.sleep(_delay);
                } catch(Exception e) {

                }
            }
            _retry--;
        } while(_retry > 0);

        _callback.onResponse(status);
    }
}
