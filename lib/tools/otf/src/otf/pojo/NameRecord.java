package otf.pojo;

// 12 bytes
public class NameRecord {
	public short platformID; // Platform ID
	public short encodingID; // Platform-specific encoding ID
	public short languageID; // Language ID
	public short nameID; // Name ID
	public short length; // String length (in bytes)
	public short offset; // String offset from start of storage area (in bytes)
	
	public String value;
}
