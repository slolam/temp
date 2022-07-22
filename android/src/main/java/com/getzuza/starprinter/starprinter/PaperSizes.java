package com.getzuza.starprinter.starprinter;

public enum PaperSizes {
    None (0),
    PaperSizeThreeInchImpact (42),
    PaperSizeTwoInchText (32),
    PaperSizeThreeInchText (48),
    PaperSizeFourInchText (69),
    PaperSizeTwoInch (384),
    PaperSizeThreeInch (576),
    PaperSizeFourInch (832),
    PaperSizeEscPosThreeInch (512),
    PaperSizeDotImpactThreeInch (210);

    private int size;
    private PaperSizes(final int size) {
        this.size = size;
    }

    public int getSize() {
        return this.size;
    }
}
