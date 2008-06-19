package otf.pojo;

public class OffsetTable {
	public int sfnt; 			// 0x00010000 for version 1.0, 0x4F54544F for otf, 0x74746366 for ttc
	public short numTables; 	// Number of tables
	public short searchRange;	// (Maximum power of 2 <= numTables) x 16
	public short entrySelector;	// Log2(maximum power of 2 <= numTables)
	public short rangeShift;	// NumTables x 16-searchRange
}
