package otf.util;

import java.io.IOException;
import java.io.RandomAccessFile;

import otf.pojo.FontHeader;
import otf.pojo.NameHeader;
import otf.pojo.NameRecord;
import otf.pojo.OffsetTable;
import otf.pojo.TableDirectory;

public class Tookit {
	
	private Tookit() {}
	
	public static int calcTableChecksum(byte[] table, int offset, int length) {
		int sum = 0, n = 0;

		while (n < length) {
			sum += toInteger(table, offset + n);
			n += 4;
		}
		
		return sum;
	}
	
	public static int calcTableChecksum(RandomAccessFile file, int offset, int length) throws IOException {
		byte[] buf = new byte[65536];
		int sum = 0, n = 0;
		
		file.seek(offset);
		while(length > 0) {
			n = file.read(buf, 0, Math.min(buf.length, length));
			sum += calcTableChecksum(buf, 0, n);
			length -= n;
		}
		
		return sum;
	}
	
	public static char toHexChar(int index) {
		final char[] table = {
				'0', '1', '2', '3', '4', '5', '6', '7',
				'8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
		return table[index & 0x0F];
	}
	
	public static String toHex(int value) {
		char[] rs = new char[10];
		rs[0] = '0';
		rs[1] = 'x';
		rs[2] = toHexChar(value >> 28);
		rs[3] = toHexChar(value >> 24);
		rs[4] = toHexChar(value >> 20);
		rs[5] = toHexChar(value >> 16);
		rs[6] = toHexChar(value >> 12);
		rs[7] = toHexChar(value >> 8);
		rs[8] = toHexChar(value >> 4);
		rs[9] = toHexChar(value);
		
		return new String(rs);
	}
	
	public static String toTag(int value) {
		char[] rs = new char[4];
		rs[0] = (char) (0xFF & (value >> 24));
		rs[1] = (char) (0xFF & (value >> 16));
		rs[2] = (char) (0xFF & (value >> 8));
		rs[3] = (char) (0xFF & value);
		
		return new String(rs);
	}
	
	public static short toShort(byte[] table, int offset) {
		return (short)((table[0 + offset] << 8) |
			(table[1 + offset] & 0xFF));
	}
	
	public static int toInteger(byte[] table, int offset) {
		return (table[0 + offset] << 24) |
			((table[1 + offset] << 16) & 0xFF0000) | 
			((table[2 + offset] << 8) & 0xFF00) | 
			(table[3 + offset] & 0xFF);
	}
	
	public static long toLong(byte[] table, int offset) {
		return (((long)toInteger(table, offset)) << 32) |
			(toInteger(table, offset + 4) & 0xFFFFFFFFL);
	}
	
	public static OffsetTable getOffsetTable(byte[] buf, int offset) {
		OffsetTable ot = new OffsetTable();
		ot.sfnt = toInteger(buf, offset);
		ot.numTables = toShort(buf, offset + 4);
		ot.searchRange = toShort(buf, offset + 6);
		ot.entrySelector = toShort(buf, offset + 8);
		ot.rangeShift = toShort(buf, offset + 10);
		
		return ot;		
	}
	
	public static TableDirectory getTableDirectory(byte[] buf, int offset) {
		TableDirectory td = new TableDirectory();
		td.tag = toInteger(buf, offset);
		td.checkSum = toInteger(buf, offset + 4);
		td.offset = toInteger(buf, offset + 8);
		td.length = toInteger(buf, offset + 12);
		
		return td;		
	}
	
	public static FontHeader getFontHeader(byte[] buf, int offset) {
		FontHeader fh = new FontHeader();

		fh.tableRevision = toInteger(buf, offset);
		fh.fontRevision = toInteger(buf, offset + 4);
		fh.checkSumAdjustment = toInteger(buf, offset + 8);
		fh.magicNumber = toInteger(buf, offset + 12);
		fh.flags = toShort(buf, offset + 16);
		fh.unitsPerEm = toShort(buf, offset + 18);
		fh.created = toLong(buf, offset + 20);
		fh.modified = toLong(buf, offset + 28);
		fh.xMin = toShort(buf, offset + 36);
		fh.yMin = toShort(buf, offset + 38);
		fh.xMax = toShort(buf, offset + 40);
		fh.yMax = toShort(buf, offset + 42);
		fh.macStyle = toShort(buf, offset + 44);
		fh.lowestRecPPEM = toShort(buf, offset + 46);
		fh.fontDirectionHint = toShort(buf, offset + 48);
		fh.indexToLocFormat = toShort(buf, offset + 50);
		fh.glyphDataFormat = toShort(buf, offset + 52);
		
		return fh;
	}
	
	public static NameHeader getNameHeader(byte[] buf, int offset) {
		NameHeader nh = new NameHeader();

		nh.format = toShort(buf, offset);
		nh.count = toShort(buf, offset + 2);
		nh.stringOffset = toShort(buf, offset + 4);
		
		return nh;
	}
	
	public static NameRecord getNameRecord(byte[] buf, int offset) {
		NameRecord nr = new NameRecord();

		nr.platformID = toShort(buf, offset);
		nr.encodingID = toShort(buf, offset + 2);
		nr.languageID = toShort(buf, offset + 4);
		nr.nameID = toShort(buf, offset + 6);
		nr.length = toShort(buf, offset + 8);
		nr.offset = toShort(buf, offset + 10);
		
		return nr;
	}
}
