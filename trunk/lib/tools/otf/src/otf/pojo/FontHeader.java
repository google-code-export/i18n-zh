package otf.pojo;

// 54 bytes
public class FontHeader {
    public int tableRevision;
    public int fontRevision;
    public int checkSumAdjustment;
    public int magicNumber;
    public short flags;
    public short unitsPerEm;
    public long created;
    public long modified;
    public short xMin;
    public short yMin;
    public short xMax;
    public short yMax;
    public short macStyle;
    public short lowestRecPPEM;
    public short fontDirectionHint;
    public short indexToLocFormat;
    public short glyphDataFormat;
}
