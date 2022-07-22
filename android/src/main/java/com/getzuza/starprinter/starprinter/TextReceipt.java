package com.getzuza.starprinter.starprinter;

import android.content.Context;

import com.starmicronics.starioextension.ICommandBuilder;
import com.starmicronics.starioextension.StarIoExt;

public class TextReceipt extends Receipt  {

    private ICommandBuilder.AlignmentPosition _alighment;

    TextReceipt(Context context, Languages language, PaperSizes paperSize) {
        _context = context;
        _languages = language;
        _size = paperSize;
        _builder = StarIoExt.createCommandBuilder(StarIoExt.Emulation.StarLine);
        _alighment = ICommandBuilder.AlignmentPosition.Left;
    }

    @Override
    public void addAlignLeft() {
        _alighment = ICommandBuilder.AlignmentPosition.Left;
        setAlignment();
    }

    @Override
    public void addAlignRight() {
        _alighment = ICommandBuilder.AlignmentPosition.Right;
        setAlignment();
    }

    @Override
    public void addAlignCenter() {
        _alighment = ICommandBuilder.AlignmentPosition.Center;
        setAlignment();
    }

    private void setAlignment() {
        _builder.appendAlignment(_alighment);
    }

    @Override
    public void setBlackColor() {
        _builder.append(new byte[] {0x1b,0x35});
    }

    @Override
    public void setRedColor() {
        _builder.append(new byte[] {0x1b,0x34});
    }

    @Override
    public void addText(String text) {
        _builder.append(text.getBytes());
    }

    @Override
    public void addDoubleText(String text) {
        _builder.appendMultiple(text.getBytes(), 2, 2);
    }

    @Override
    public void addBoldText(String text) {
        _builder.appendEmphasis(text.getBytes());
    }

    @Override
    public void addUnderlinedText(String text) {
        _builder.appendUnderLine(text.getBytes());
    }

    @Override
    public void addInverseText(String text) {
        _builder.appendInvert(text.getBytes());
    }
}
