package com.getzuza.starprinter.starprinter;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.AlignmentSpan;
import android.text.style.BackgroundColorSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.text.style.UnderlineSpan;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.TextView;

import com.starmicronics.starioextension.StarIoExt;

import static android.graphics.Color.BLACK;
import static android.graphics.Color.WHITE;

public class GraphicReceipt extends Receipt {

    private static final AlignmentSpan LEFT = new AlignmentSpan.Standard(Layout.Alignment.ALIGN_NORMAL);
    private static final AlignmentSpan CENTER = new AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER);
    private static final AlignmentSpan RIGHT = new AlignmentSpan.Standard(Layout.Alignment.ALIGN_OPPOSITE);

    private static final StyleSpan BOLD = new StyleSpan(Typeface.BOLD);
    private static final UnderlineSpan UNDERLINE = new UnderlineSpan();
    private static final ForegroundColorSpan FOREGROUND_COLOR = new ForegroundColorSpan(Color.WHITE);
    private static final BackgroundColorSpan BACKGROUND_COLOR = new BackgroundColorSpan(Color.BLACK);

    private static final float FONT_SIZE = 23.5f;

    private static Typeface DEFAULT_FONT;// = Typeface.createFromFile("font/menlo.ttf");
    //private static final Typeface DEFAULT_FONT = Typeface.create(Typeface.MONOSPACE, Typeface.NORMAL);

    private static final String Class = "GraphicReceipt";

    private SpannableStringBuilder _receiptBuilder;

    private float _fontSize = FONT_SIZE;

    private String _fontName;

    private Typeface _font;

    private AlignmentSpan _alignment = LEFT;

    GraphicReceipt(Context context, Languages language, PaperSizes paperSize) {
        _context = context;
        _languages = language;
        _size = paperSize;
        _receiptBuilder = new SpannableStringBuilder();
        _builder = StarIoExt.createCommandBuilder(StarIoExt.Emulation.StarGraphic);
        if(DEFAULT_FONT == null) {
            DEFAULT_FONT = Typeface.createFromAsset(context.getAssets(), "font/menlo.ttf");
        }
        _font = DEFAULT_FONT;
    }

    private void drawPrevious() {
        if(_receiptBuilder != null && _receiptBuilder.length() > 0) {

            Log.e(Class, String.format("Receipt content length %d", _receiptBuilder.length()));

            TextView view = new TextView(_context);
            view.setText(_receiptBuilder, TextView.BufferType.SPANNABLE);
            int hSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
            int wSpec = View.MeasureSpec.makeMeasureSpec(paperWidth() + 1, View.MeasureSpec.EXACTLY);

            view.setTypeface(DEFAULT_FONT);
            view.setTextSize(TypedValue.COMPLEX_UNIT_PX, FONT_SIZE);
            view.setBackgroundColor(WHITE);
            view.setTextColor(BLACK);
            view.measure(wSpec, hSpec);
            view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());

            Bitmap img = Bitmap.createBitmap(view.getMeasuredWidth(), view.getMeasuredHeight(), Bitmap.Config.ARGB_8888);

            Canvas canvas = new Canvas(img);

            view.draw(canvas);

            _builder.appendBitmap(img, false);

            _receiptBuilder = null;
        }
    }

    private void ensureBuilder() {
        if(_receiptBuilder == null) {
            _receiptBuilder = new SpannableStringBuilder();
        }
    }

    private Spannable copyString(String text){
        ensureBuilder();
        SpannableString span = new SpannableString(text);
        int length = span.length();

        float relative = _fontSize / FONT_SIZE;
        span.setSpan(new AbsoluteSizeSpan((int)_fontSize), 0, length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        span.setSpan(_alignment, 0, length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        return span;
    }

    @Override
    public void addAlignLeft() {
        _alignment = LEFT;
    }

    @Override
    public void addAlignCenter() {
        _alignment = CENTER;
    }

    @Override
    public void addAlignRight() {
        _alignment = RIGHT;
    }

    @Override
    public void setFont(Typeface font) {
        _font = font != null ? font : DEFAULT_FONT;
    }

    @Override
    public void setFontSize(float size) {
        _fontSize = size;
    }

    @Override
    public void addText(String text) {
        Spannable span = copyString(text);
        _receiptBuilder.append(span);
    }

    @Override
    public void addBoldText(String text) {
        Spannable span = copyString(text);
        span.setSpan(BOLD, 0, span.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        _receiptBuilder.append(span);
    }

    @Override
    public void addUnderlinedText(String text) {
        Spannable span = copyString(text);
        span.setSpan(UNDERLINE, 0, span.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        _receiptBuilder.append(span);
    }

    @Override
    public void addInverseText(String text) {
        Spannable span = copyString(text);
        int length = span.length();
        span.setSpan(FOREGROUND_COLOR, 0, length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        span.setSpan(BACKGROUND_COLOR, 0, length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        _receiptBuilder.append(span);
    }

    @Override
    public void addDoubleText(String text) {

    }

    @Override
    public void addLine() {

    }

    @Override
    public void addImage(Bitmap image, int width) {
        drawPrevious();
        super.addImage(image, width);
    }

    @Override
    public void addQrCode(String data) {
        drawPrevious();
        super.addQrCode(data);
    }

    @Override
    public void addBarcode(String text, int height) {
        drawPrevious();
        super.addBarcode(text, height);
    }

    @Override
    public void openCashDrawer() {
        drawPrevious();
        super.openCashDrawer();
    }

    @Override
    public void cutPaper() {
        drawPrevious();
        super.cutPaper();
    }

    @Override
    public void closeReceipt() {
        drawPrevious();
        super.closeReceipt();
    }
}
