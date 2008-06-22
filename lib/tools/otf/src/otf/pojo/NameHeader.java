package otf.pojo;

// 6 bytes
public class NameHeader {
    public short format; // Format selector (=0)
    public short count; // Number of name records
    public short stringOffset; // Offset to start of string storage (from start of table)
}
