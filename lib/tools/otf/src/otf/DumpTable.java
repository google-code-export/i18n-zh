package otf;

import java.io.FileOutputStream;
import java.io.RandomAccessFile;

import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;

import otf.pojo.NameHeader;
import otf.pojo.NameRecord;
import otf.pojo.OffsetTable;
import otf.pojo.TableDirectory;
import otf.util.Tookit;

public class DumpTable {

	public static void main(String[] args) throws Exception {
		
		String fontfile = "C:/wc/ttf/MicrosoftYaHei.ttf";
		// String fontfile = "C:/wc/ttf/MicrosoftYaHeiBold.ttf";
		// String fontfile = "C:/wc/ttf/FZLangtingHei.ttf";
		// String fontfile = "C:/wc/ttf/FZLangtingSong.ttf";
		// String fontfile = "C:/wc/ttf/FZYaSong.ttf";
		// String fontfile = "C:/wc/ttf/FZYaSongBold.ttf";
		// String fontfile = "C:/wc/ttf/FZXingKai.ttf";
		// String fontfile = "C:/wc/ttf/FZKai.ttf";
		// String fontfile = "C:/wc/ttf/FZHei.ttf";
		// String fontfile = "C:/wc/ttf/FZSong.ttf";
		
		new DumpTable().run(fontfile);
	}
	
	public void run(String fontfile) throws Exception {
		byte[] buf = new byte[65536];
		RandomAccessFile file = new RandomAccessFile(fontfile, "r");
		file.read(buf, 0, 12);
		
		OffsetTable ot = Tookit.getOffsetTable(buf, 0);
		if(ot.sfnt != 0x00010000 && ot.sfnt != 0x4F54544F) {
			System.err.println("Not ttf or otf font file !");
			System.exit(1);
		}
		System.out.println("OffsetTable.sfnt: " + Tookit.toHex(ot.sfnt));
		System.out.println("OffsetTable.numTables: " + ot.numTables);
		System.out.println("OffsetTable.searchRange: " + ot.searchRange);
		System.out.println("OffsetTable.entrySelector: " + ot.entrySelector);
		System.out.println("OffsetTable.rangeShift: " + ot.rangeShift);

		TableDirectory[] tds = new TableDirectory[ot.numTables];
		int name = 0;
		for(int i = 0; i < ot.numTables; i++) {
			file.read(buf, 0, 16);
			tds[i] = Tookit.getTableDirectory(buf, 0);
			System.out.println("\nTableDirectory[" + i + "].tag: " + Tookit.toTag(tds[i].tag));
			System.out.println("TableDirectory[" + i + "].checkSum: " + Tookit.toHex(tds[i].checkSum));
			System.out.println("TableDirectory[" + i + "].offset: " + tds[i].offset);
			System.out.println("TableDirectory[" + i + "].length: " + tds[i].length);
			
			if("name".equals(Tookit.toTag(tds[i].tag))) name = i;
		}
		
//		TableDirectory[12].tag: name
//		TableDirectory[12].checkSum: 0x94024320
//		TableDirectory[12].offset: 7766272
//		TableDirectory[12].length: 1044
		
		file.seek(tds[name].offset);
		file.read(buf, 0, tds[name].length);
		NameHeader nh = Tookit.getNameHeader(buf, 0);
		System.out.println("\nNameHeader.format: " + nh.format);
		System.out.println("NameHeader.count: " + nh.count);
		System.out.println("NameHeader.stringOffset: " + nh.stringOffset);

		System.out.println("\nplatformID \tencodingID \tlanguageID  \tnameID \tlength \toffset");			
		
		NameRecord[] nrs = new NameRecord[nh.count];
		String xmlfile = fontfile.substring(0, fontfile.length() - 3) + "xml2";
		XMLStreamWriter xmlw =
				XMLOutputFactory.newInstance().createXMLStreamWriter(new FileOutputStream(xmlfile), "UTF-8");
		xmlw.writeStartDocument();
		xmlw.writeStartElement("name");
		for(int i = 0; i < nh.count; i++) {
			file.read(buf, 0, 16);
			nrs[i] = Tookit.getNameRecord(buf, 6 + i * 12);
			
			System.out.println(nrs[i].platformID + "\t\t" + nrs[i].encodingID
					+ "\t\t" + nrs[i].languageID + "\t\t" + nrs[i].nameID + "\t"
					+ nrs[i].length + "\t" + nrs[i].offset);	
			if((nrs[i].platformID == 1 && nrs[i].encodingID == 0 && nrs[i].languageID == 0)
				|| (nrs[i].platformID == 3 && nrs[i].encodingID == 1 && nrs[i].languageID == 1033)
				|| (nrs[i].platformID == 3 && nrs[i].encodingID == 1 && nrs[i].languageID == 2052)) {

				xmlw.writeStartElement("string");
				xmlw.writeAttribute("platformID", Integer.toString(nrs[i].platformID));
				xmlw.writeAttribute("encodingID", Integer.toString(nrs[i].encodingID));
				xmlw.writeAttribute("languageID", Integer.toString(nrs[i].languageID));
				xmlw.writeAttribute("nameID", Integer.toString(nrs[i].nameID));
				
				xmlw.writeStartElement("description");
				switch(nrs[i].nameID) {
				case 0:
					xmlw.writeCharacters("Copyright notice.");
					break;
				case 1:
					xmlw.writeCharacters("Font Family name.");
					break;
				case 2:
					xmlw.writeCharacters("Font Subfamily name.");
					break;
				case 3:
					xmlw.writeCharacters("Unique font identifier");
					break;
				case 4:
					xmlw.writeCharacters("Full font name(No Regular).");
					break;
				case 5:
					xmlw.writeCharacters("Version string.");
					break;
				case 6:
					xmlw.writeCharacters("Postscript name for the font.");
					break;
				case 7:
					xmlw.writeCharacters("Trademark.");
					break;
				case 8:
					xmlw.writeCharacters("Manufacturer Name.");
					break;
				case 9:
					xmlw.writeCharacters("Designer.");
					break;
				case 10:
					xmlw.writeCharacters("Description.");
					break;
				case 11:
					xmlw.writeCharacters("URL Vendor.");
					break;
				case 12:
					xmlw.writeCharacters("URL Designer.");
					break;
				case 13:
					xmlw.writeCharacters("License Description.");
					break;
				case 14:
					xmlw.writeCharacters("License Info URL.");
					break;
				case 15:
					xmlw.writeCharacters("Reserved; Set to zero.");
					break;
				case 16:
					xmlw.writeCharacters("Preferred Family.");
					break;
				case 17:
					xmlw.writeCharacters("Preferred Subfamily.");
					break;
				case 18:
					xmlw.writeCharacters("Compatible Full (Macintosh only).");
					break;
				case 19:
					xmlw.writeCharacters("Sample text.");
					break;
				case 20:
					xmlw.writeCharacters("PostScript CID findfont name.");
					break;
				case 21:
					xmlw.writeCharacters("WWS Family Name.");
					break;
				case 22:
					xmlw.writeCharacters("WWS Subfamily Name.");
					break;
				default:
					xmlw.writeCharacters("unknown name id.");
					break;						
				}
				xmlw.writeEndElement();
				
				xmlw.writeStartElement("value");
				if(nrs[i].platformID == 1)
					xmlw.writeCharacters(new String(buf, nh.stringOffset + nrs[i].offset, nrs[i].length, "ISO-8859-1"));
				else
					xmlw.writeCharacters(new String(buf, nh.stringOffset + nrs[i].offset, nrs[i].length, "UTF-16"));
				xmlw.writeEndElement();
				
				xmlw.writeEndElement();
			}
		}

		xmlw.writeEndElement();
		xmlw.writeEndDocument();
		xmlw.close();
		
		file.close();
	}

}
