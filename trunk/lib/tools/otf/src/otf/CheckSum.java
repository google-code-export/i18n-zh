package otf;

import java.io.RandomAccessFile;

import otf.pojo.FontHeader;
import otf.pojo.OffsetTable;
import otf.pojo.TableDirectory;
import otf.util.Tookit;

public class CheckSum {

	public static void main(String[] args) throws Exception {

		// String fontfile = "C:/wc/ttf/MicrosoftYaHei.ttf";
		// String fontfile = "C:/wc/ttf/MicrosoftYaHeiBold.ttf";
		// String fontfile = "C:/wc/ttf/FZLangtingHei.ttf";
		// String fontfile = "C:/wc/ttf/FZLangtingSong.ttf";
		// String fontfile = "C:/wc/ttf/FZYaSong.ttf";
		// String fontfile = "C:/wc/ttf/FZYaSongBold.ttf";
		// String fontfile = "C:/wc/ttf/FZXingKai.ttf";
		// String fontfile = "C:/wc/ttf/FZKai.ttf";
		// String fontfile = "C:/wc/ttf/FZHei.ttf";
		// String fontfile = "C:/wc/ttf/FZSong.ttf";
		// String fontfile = "C:/wc/ttf/AdobeSongStd-Light.otf";
		// String fontfile = "C:/wc/ttf/AdobeMingStd-Light.otf";

		String fontfile = "C:/wc/ttf/FZYaSongBold.fixed.ttf";
		
		new CheckSum().run(fontfile);
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

		System.out.println("sfnt: " + Tookit.toHex(ot.sfnt) +" numTables: " + ot.numTables
				+ " searchRange: " + ot.searchRange + " entrySelector: " + ot.entrySelector
				+ " rangeShift: " + ot.rangeShift + "\n");

		TableDirectory[] tds = new TableDirectory[ot.numTables];
		int hi = 0;
		for(int i = 0; i < ot.numTables; i++) {
			file.seek(12 + 16 * i);
			file.read(buf, 0, 16);
			tds[i] = Tookit.getTableDirectory(buf, 0);
			String tag = Tookit.toTag(tds[i].tag);
			if("head".equals(tag)) {
				hi = i;
			} else {
				System.out.println("table " + tag + " checkSum: " + Tookit.toHex(tds[i].checkSum)
						 + " length: " + tds[i].length + "\toffset: " + tds[i].offset);
				int sum = Tookit.calcTableChecksum(file, tds[i].offset, tds[i].length);
				if(sum != tds[i].checkSum) {
					System.out.println("Check sum '" + tag + "' fail!");
				}
			}
		}
		
		int adj = Tookit.calcTableChecksum(file, 0, (int) file.length());
		
		file.seek(tds[hi].offset);
		file.read(buf, 0, tds[hi].length);
		FontHeader fh = Tookit.getFontHeader(buf, 0);
		
		adj -= fh.checkSumAdjustment;
		
		adj = 0xB1B0AFBA - adj;
				
		if(adj != fh.checkSumAdjustment) {
			System.out.println("Check sum 'head' fail!");			
		}
		
		file.close();

		System.out.println("\nDONE!");	
	}
}
