package com.getzuza.starprinterlib;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.media.Image;

import com.starmicronics.starioextension.ICommandBuilder;

import java.nio.charset.Charset;

public  class Receipt {

    protected PaperSizes _size;

    protected Languages _languages;

    protected ICommandBuilder _builder;

    protected Context _context;

    private boolean _closed;

    public static Receipt createReceiptFromText(Context context, boolean text, Languages language, int paperSize) {

        PaperSizes size = PaperSizes.None;
        Receipt receipt;
        if (text) {
            switch (paperSize) {
                case 2:
                    size = PaperSizes.PaperSizeTwoInchText;
                    break;
                case 3:
                    size = PaperSizes.PaperSizeThreeInchText;
                    break;
                case 4:
                    size = PaperSizes.PaperSizeFourInchText;
                    break;
                default:
                    size = PaperSizes.PaperSizeThreeInchText;
                    break;
            }
            receipt = new TextReceipt(context, language, size);
        } else {
            switch (paperSize) {
                case 2:
                    size = PaperSizes.PaperSizeTwoInch;
                    break;
                case 3:
                    size = PaperSizes.PaperSizeThreeInch;
                    break;
                case 4:
                    size = PaperSizes.PaperSizeFourInch;
                    break;
                default:
                    size = PaperSizes.PaperSizeThreeInch;
                    break;
            }
            receipt = new GraphicReceipt(context, language, size);
        }
        receipt._builder.beginDocument();
        return receipt;
    }

    public void setFont(Typeface font) {

    }

    public void setFontName(String name) {

    }

    public void setFontSize(float size) {
    }

    public void addAlignLeft() {
    }

    public void addAlignRight() {
    }

    public void addAlignCenter() {
    }

    public void addText(String text) {
    }

    public void addDoubleText(String text) {
    }

    public void addBoldText(String text) {
    }

    public void addUnderlinedText(String text) {
    }

    public void addInverseText(String text) {
    }

    public void addLine() {
    }

    public void addBarcode(String text, int height) {
        text = String.format("{B%s", text);
        _builder.appendBarcodeWithAlignment(text.getBytes(),
                ICommandBuilder.BarcodeSymbology.Code128,
                ICommandBuilder.BarcodeWidth.ExtMode1,
                height, true, ICommandBuilder.AlignmentPosition.Center);
    }

    protected int paperWidth() {
        switch (_size) {
            default:
            case PaperSizeDotImpactThreeInch:
            case PaperSizeThreeInchText:
            case PaperSizeThreeInch:
            case PaperSizeEscPosThreeInch:
                return PaperSizes.PaperSizeThreeInch.getSize();

            case PaperSizeFourInch:
            case PaperSizeFourInchText:
                return PaperSizes.PaperSizeFourInch.getSize();

            case PaperSizeTwoInch:
            case PaperSizeTwoInchText:
                return PaperSizes.PaperSizeTwoInch.getSize();
        }
    }

    public void addImage(Bitmap image, int width) {
        if (image != null) {
            int w = paperWidth();
            if (width <= 0 || width > w) {
                width = w;
            }
            _builder.appendBitmapWithAlignment(image, false, width, true, ICommandBuilder.AlignmentPosition.Center);
        }
    }

    public void addQrCode(String data) {
        if (data != null) {
            byte[] bytes = data.getBytes();
            _builder.appendQrCodeWithAlignment(bytes, ICommandBuilder.QrCodeModel.No2, ICommandBuilder.QrCodeLevel.M,8, ICommandBuilder.AlignmentPosition.Center);
            //_builder.appendBitmapWithAlignment(image, false, width, true, ICommandBuilder.AlignmentPosition.Center);
        }
    }

    public void openCashDrawer() {
        _builder.endDocument();
        _builder.appendPeripheral(ICommandBuilder.PeripheralChannel.No1);
        _builder.appendPeripheral(ICommandBuilder.PeripheralChannel.No2);
        _builder.beginDocument();
    }

    public void cutPaper() {
        _builder.appendCutPaper(ICommandBuilder.CutPaperAction.PartialCutWithFeed);
    }

    public void setBlackColor() {
    }

    public void setRedColor() {
    }

    public void closeReceipt() {
        if (!_closed) {
            _builder.endDocument();
            _closed = true;
        }
    }

    public void setCommand(String command) {
        byte[] data;
        try {
            data = command.getBytes("UTF-8");
        } catch (Exception e) {
            data = new byte[0];
        }
        _builder.append((data));
    }

}
