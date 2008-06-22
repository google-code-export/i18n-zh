package otf.pojo;

// 16 bytes
public class TableDirectory {
    public int tag;         // 4 byte identifier
    public int checkSum;    // CheckSum for this table
    public int offset;      // Offset from beginning of TrueType font file
    public int length;      // Length of this table
}
