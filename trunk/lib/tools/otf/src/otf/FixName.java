package otf;

import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
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
    	
        String fontfile = "C:/wc/ttf/FzYaSongBold.ttf";
        String outfile = "C:/wc/ttf/FzYaSongBold.fixed.ttf";
        String xmlfile = "C:/wc/svn/i18n-zh/trunk/lib/tools/otf/xml/fixed/FzYaSongBold.xml";

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

        TableDirectory head = null;
        List<TableDirectory> tdl = new ArrayList<TableDirectory>(31);
        for(int i = 0; i < ot.numTables; i++) {
            src.read(buf, 0, 16);
            TableDirectory td = Tookit.getTableDirectory(buf, 0);
            if(!"DSIG".equals(Tookit.toTag(td.tag))) {
                tdl.add(td);
                if("head".equals(Tookit.toTag(td.tag))) head = td;
            } else {
                System.out.println("Remove table 'DSIG' ... done");
            }
        }

        // 写入文件头
        ot = Tookit.updateOffsetTable(ot, tdl.size());
        RandomAccessFile dst = new RandomAccessFile(outfile, "rw");
        dst.seek(0);
        dst.writeInt(ot.sfnt);
        dst.writeShort(ot.numTables);
        dst.writeShort(ot.searchRange);
        dst.writeShort(ot.entrySelector);
        dst.writeShort(ot.rangeShift);

        // 按照原始偏移排序表
        TableDirectory[] tds = tdl.toArray(new TableDirectory[tdl.size()]);
        Arrays.sort(tds,  new Comparator<TableDirectory>() {
            public int compare(final TableDirectory o1, final TableDirectory o2) {
                if(o1.offset > o2.offset) return 1;
                if(o1.offset < o2.offset) return -1;
                return 0;
            }});

        // 复制表内容
        int size = 12 + 16 * tds.length;
        for(int i = 0; i < tds.length; i++) {
            TableDirectory td = tds[i];

            if("name".equals(Tookit.toTag(td.tag))) {
                byte[] nameTable = Tookit.loadNameTable(xmlfile);
                dst.seek(size);
                dst.write(nameTable);
                td.length = nameTable.length;
            } else {
                Tookit.copyTo(src, td.offset, dst, size, td.length);
            }

            if("head".equals(Tookit.toTag(td.tag))) { // 将表 head 的 checkSumAdjustment 置 0
                dst.seek(size + 8);
                dst.writeInt(0);                

                // 更新修改时间
//            	GregorianCalendar c = new GregorianCalendar();
//            	c.set(1904, 1 - 1, 1, 0 + 8, 0);
//            	long t = c.getTimeInMillis();
//            	c.set(1970, 1 - 1, 1, 0 + 8, 0);
//            	t = c.getTimeInMillis() - t;            	
//                
//              t = (t + System.currentTimeMillis()) / 1000;
//              dst.seek(size + 28);
//              dst.writeLong(t);
            }

            // 调节表索引
            td.checkSum = Tookit.calcTableChecksum(dst, size, td.length);
            td.offset = size;
            size += td.length;

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

        // 按照 tag 排序表
        Arrays.sort(tds,  new Comparator<TableDirectory>() {
            public int compare(final TableDirectory o1, final TableDirectory o2) {
                if(o1.tag > o2.tag) return 1;
                if(o1.tag < o2.tag) return -1;
                return 0;
            }});

        // 写入表索引
        dst.seek(12);
        for(int i = 0; i < tds.length; i++) {
          dst.writeInt(tds[i].tag);
          dst.writeInt(tds[i].checkSum);
          dst.writeInt(tds[i].offset);
          dst.writeInt(tds[i].length);
        }

        // checkSumAdjustment
        int sum = 0xB1B0AFBA - Tookit.calcTableChecksum(dst, 0, size);
        dst.seek(head.offset + 8);
        dst.writeInt(sum);

        System.out.println("\nCalc font checksum ... done");

        src.close();
        dst.close();
    }
}
