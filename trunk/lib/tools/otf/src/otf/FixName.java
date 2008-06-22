package otf;

import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;

import otf.pojo.OffsetTable;
import otf.pojo.TableDirectory;
import otf.util.Tookit;

public class FixName {

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
    	
        String fontfile = "C:/wc/ttf/FZYaSongBold.ttf";
        String outfile = "C:/wc/ttf/FZYaSongBold.fixed.ttf";
        String xmlfile = "C:/wc/svn/i18n-zh/trunk/lib/tools/otf/xml/fixed/FZYaSongBold.xml";

        new FixName().run(fontfile, xmlfile, outfile);
    }

    public void run(String fontfile, String xmlfile, String outfile) throws Exception {
    	
    	// 检查文件头，加载表目录
        byte[] buf = new byte[65536];
        RandomAccessFile src = new RandomAccessFile(fontfile, "r");
        src.read(buf, 0, 12);
        OffsetTable ot = Tookit.getOffsetTable(buf, 0);
        if(ot.sfnt != 0x00010000 && ot.sfnt != 0x4F54544F) {
            System.err.println("Not ttf or otf font file !");
            System.exit(1);
        }        

        int head = 0, name = 0;
        List<TableDirectory> tds = new ArrayList<TableDirectory>(31);        
        for(int i = 0; i < ot.numTables; i++) {
            src.read(buf, 0, 16);
            TableDirectory td = Tookit.getTableDirectory(buf, 0);
            if(!"DSIG".equals(Tookit.toTag(td.tag))) {
            	tds.add(td);
            	if("head".equals(Tookit.toTag(td.tag))) head = tds.size() - 1;
            	if("name".equals(Tookit.toTag(td.tag))) name = tds.size() - 1;
            } else {
            	System.out.println("Remove table 'DSIG' ... done");        
            }
        }

        // 写入文件头
        ot = Tookit.updateOffsetTable(ot, tds.size());
        RandomAccessFile dst = new RandomAccessFile(outfile, "rw");
        dst.seek(0);
        dst.writeInt(ot.sfnt);
        dst.writeShort(ot.numTables);
        dst.writeShort(ot.searchRange);
        dst.writeShort(ot.entrySelector);
        dst.writeShort(ot.rangeShift);
        
        int size = 12 + 16 * tds.size();
        for(int i = 0; i < tds.size(); i++) {
        	TableDirectory td = tds.get(i);
        	
        	// 复制表内容
        	if(i == name) {
        		byte[] nameTable = Tookit.loadNameTable(xmlfile);
        		dst.seek(size);
        		dst.write(nameTable);
        		td.length = nameTable.length;
        	} else {
        		Tookit.copyTo(src, td.offset, dst, size, td.length);       		
        	}

        	if(i == head) { // 将表 head 的 checkSumAdjustment 置 0        		
        		dst.seek(size + 8);
        		dst.writeInt(0);
        	}

        	// 写入表索引    	
        	td.checkSum = Tookit.calcTableChecksum(dst, size, td.length);
    		td.offset = size;	
    		size += td.length;
    		
    		dst.seek(12 + 16 * i);
    		dst.writeInt(td.tag);
    		dst.writeInt(td.checkSum);
    		dst.writeInt(td.offset);
    		dst.writeInt(td.length);    	
    		
    		// 按照 4 字节对齐文件    		
    		if(size % 4 != 0) {
    			dst.seek(size);
    			while(size % 4 != 0) {
    				dst.write(0);
    				size++;
    			}
    		}
            System.out.println("Copy table '" + Tookit.toTag(td.tag)
            		+ "' ... done");        
        }

        // checkSumAdjustment
        int sum = 0xB1B0AFBA - Tookit.calcTableChecksum(dst, 0, size);
        dst.seek(tds.get(head).offset + 8);
        dst.writeInt(sum);

        System.out.println("\nCalc font checksum ... done");     
        
        src.close();
        dst.close();
    }
}
