package otf.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamReader;

import otf.pojo.FontHeader;
import otf.pojo.NameHeader;
import otf.pojo.NameRecord;
import otf.pojo.OffsetTable;
import otf.pojo.TableDirectory;

public class Tookit {

    private Tookit() {}

    public static int calcTableChecksum(byte[] table, int offset, int length) {
        int sum = 0, n = 0;

        if(length % 4 != 0) {
            byte[] buf = new byte[(length + 3) & ~3];
            System.arraycopy(table, 0, buf, 0, length);

            while (n < length) {
                sum += toInteger(buf, offset + n);
                n += 4;
            }

            return sum;
        }

        while (n < length) {
            sum += toInteger(table, offset + n);
            n += 4;
        }

        return sum;
    }

    public static int calcTableChecksum(RandomAccessFile file, int offset, int length) throws IOException {
        byte[] buf = new byte[Math.min(65536, length)];
        int sum = 0, n = 0;

        file.seek(offset);
        while(length > 0) {
            n = file.read(buf, 0, Math.min(buf.length, length));
            if(n < 0) {
                System.out.println("EOF");
                break;
            }
            sum += calcTableChecksum(buf, 0, n);
            length -= n;
        }

        return sum;
    }

    public static void copyTo(RandomAccessFile src, int offset, RandomAccessFile dst, int dstOffset, int length) throws IOException {
        byte[] buf = new byte[Math.min(65536, length)];

        src.seek(offset);
        dst.seek(dstOffset);

        while(length > 0) {
            int n = src.read(buf, 0, Math.min(buf.length, length));
            if(n < 0) {
                System.out.println("EOF");
                break;
            }
            dst.write(buf, 0, n);
            length -= n;
        }
    }

    public static char toHexChar(int index) {
        final char[] table = {
                '0', '1', '2', '3', '4', '5', '6', '7',
                '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        return table[index & 0x0F];
    }

    public static OffsetTable updateOffsetTable(OffsetTable ot, int n) {
        ot.numTables = (short) n;
        if(ot.sfnt == 0) ot.sfnt = 0x00010000;

        int i = 0, v = 1;
        while(v < n) {
            i ++; v *= 2;
        }

        i --; v /= 2;

        ot.searchRange = (short) (v * 16);
        ot.entrySelector = (short) i;
        ot.rangeShift = (short) (n * 16 - ot.searchRange);

        return ot;
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

    public static void toBytes(short value, byte[] buf, int offset) {
        buf[offset] = (byte)(value >> 8);
        buf[offset + 1] = (byte)value;
    }

    public static int toInteger(byte[] table, int offset) {
        return (table[0 + offset] << 24) |
            ((table[1 + offset] << 16) & 0xFF0000) |
            ((table[2 + offset] << 8) & 0xFF00) |
            (table[3 + offset] & 0xFF);
    }

    public static void toBytes(int value, byte[] buf, int offset) {
        buf[offset] = (byte)(value >> 24);
        buf[offset + 1] = (byte)(value >> 16);
        buf[offset + 2] = (byte)(value >> 8);
        buf[offset + 3] = (byte)value;
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

    public static List<NameRecord> loadNameRecord(String xmlfile) throws Exception {
        List<NameRecord> nrs = new ArrayList<NameRecord>(31);
        XMLStreamReader r = XMLInputFactory.newInstance().createXMLStreamReader(new FileInputStream(xmlfile));

        int event;
        String value = "";
        NameRecord nr = null;

        while(((event = r.next()) != XMLStreamConstants.END_DOCUMENT)) {
            if(event == XMLStreamConstants.START_ELEMENT) {
                if(r.getName().toString().equals("string")) {
                    nr = new NameRecord();
                    nr.platformID = Short.parseShort(r.getAttributeValue(null, "platformID"));
                    nr.encodingID = Short.parseShort(r.getAttributeValue(null, "encodingID"));
                    nr.languageID = Short.parseShort(r.getAttributeValue(null, "languageID"));
                    nr.nameID = Short.parseShort(r.getAttributeValue(null, "nameID"));
                }
                if(r.getName().toString().equals("value")) value = "";
            }
            if(event == XMLStreamConstants.END_ELEMENT) {
                if(r.getName().toString().equals("string")) {
                    if((nr.platformID == 3 && nr.encodingID == 1 && (nr.languageID == 1033 || nr.languageID == 2052))
                            || (nr.platformID == 1 && nr.encodingID == 0 && nr.languageID == 0))
                        nrs.add(nr);
                }
                if(r.getName().toString().equals("value")) {
                    if(nr.platformID == 3)
                        nr.bytes = value.getBytes("UTF-16BE");
                    else
                        nr.bytes = value.getBytes("ISO-8859-1");

                    nr.value = value;
                    nr.length = (short) nr.bytes.length;
                }
            }
            if(event == XMLStreamConstants.CHARACTERS) value += r.getText();
        }

        r.close();

        return nrs;
    }

    public static byte[] loadNameTable(String xmlfile) throws Exception {
        byte[] buf = new byte[65536];
        List<NameRecord> nrs = Tookit.loadNameRecord(xmlfile);
        NameRecord[] nra = nrs.toArray(new NameRecord[nrs.size()]);
        NameHeader nh = new NameHeader();
        nh.format = (short)0;
        nh.count = (short) nrs.size();
        nh.stringOffset = (short)(6 + 12 * nrs.size());

        // 压缩输出字符串表，先输出最长的字符串
        Arrays.sort(nra, new Comparator<NameRecord>() {
            public int compare(NameRecord o1, NameRecord o2) {
                if(o1.length < o2.length) return 1;
                if(o1.length > o2.length) return -1;
                return 0;
            }
        });
        int size = 0;
        for(int i = 0; i < nra.length; i++) {
            int index = Tookit.indexOf(buf, nh.stringOffset, size, nra[i].bytes);
            if(index < 0) {
                System.arraycopy(nra[i].bytes, 0, buf, nh.stringOffset + size, nra[i].length);
                nra[i].offset = (short)(size);
                size += nra[i].length;
            } else {
                nra[i].offset = (short)(index - nh.stringOffset);
            }
        }

        // 输出 NameHeader
        Tookit.toBytes(nh.format, buf, 0);
        Tookit.toBytes(nh.count, buf, 2);
        Tookit.toBytes(nh.stringOffset, buf, 4);

        // 输出 NameRecord
        Arrays.sort(nra, new Comparator<NameRecord>() {
            public int compare(NameRecord o1, NameRecord o2) {
                if(o1.platformID < o2.platformID) return -1;
                if(o1.platformID > o2.platformID) return 1;

                if(o1.encodingID < o2.encodingID) return -1;
                if(o1.encodingID > o2.encodingID) return 1;

                if(o1.languageID < o2.languageID) return -1;
                if(o1.languageID > o2.languageID) return 1;

                if(o1.nameID < o2.nameID) return -1;
                if(o1.nameID > o2.nameID) return 1;

                return 0;
            }
        });

        for(int i = 0; i < nra.length; i++) {
            Tookit.toBytes(nra[i].platformID, buf, 6 + i * 12);
            Tookit.toBytes(nra[i].encodingID, buf, 6 + i * 12 + 2);
            Tookit.toBytes(nra[i].languageID, buf, 6 + i * 12 + 4);
            Tookit.toBytes(nra[i].nameID, buf, 6 + i * 12 + 6);
            Tookit.toBytes(nra[i].length, buf, 6 + i * 12 + 8);
            Tookit.toBytes(nra[i].offset, buf, 6 + i * 12 + 10);
        }

        size += nh.stringOffset;

        byte[] name = new byte[size];
        System.arraycopy(buf, 0, name, 0, size);

        return name;
    }

    public static int indexOf(byte[] buf, int offset, int size, byte[] sb) {
        if(sb.length > size) return -1;

        while(size >= sb.length) {
            int i = 0;
            while(i < sb.length) {
                if(sb[i] != buf[offset + i]) break;
                i++;
            }
            if(i >= sb.length) return offset;
            offset ++;
            size --;
        }

        return -1;
    }
}
