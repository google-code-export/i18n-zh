/******************************************************************************
PO-MERGE - A simple po map tool

Copyright (C) 2006 - Dongsheng Song <dongsheng.song@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA

Description:
[TBD]

Use:
    po-map en.pot zh.pot zh.po

******************************************************************************/

using System;
using System.Collections;
using System.IO;
using System.Text;

class Program
{
    private static void Usage() {
        Console.WriteLine("Usage:\n\tpo-map en.pot zh.pot zh.po\n");
    }

    public static void Main(String[] args) {
        if (args.Length != 3) {
            Usage();
            return;
        }

        StreamReader en = new StreamReader(args[0], Encoding.UTF8);
        StreamReader zh = new StreamReader(args[1], Encoding.UTF8);
        StreamWriter sw = new StreamWriter(args[2], true);
        String id = null, id2 = null;
        int n = 0;

        while(true) {
            id = NextMsgid(en);
            id2 = NextMsgid(zh);

            if (id == null && id2 == null) break;
            if (id == null || id2 == null) {
                sw.Flush();
                Console.Error.WriteLine("id: \"{0}\"", id);
                Console.Error.WriteLine("id2: \"{0}\"", id2);
                throw new Exception("Can't map msg id");
            }

            n = n + 1;
            sw.WriteLine("msgid \"{0}\"", id);
            sw.WriteLine("msgstr \"{0}\"\n", id2);
        }

        en.Close();
        zh.Close();
        sw.Close();

        Console.Error.WriteLine("Total map {0} messages.", n);
    }

    private static String NextMsgid(StreamReader sr) {
        String line, msgid = null;

        while (true) {
            line = sr.ReadLine();
            if (line == null) return null;

            line = line.Trim();

            if (line.StartsWith("msgid \"")) {
                if (line[line.Length - 1] != '\"') throw new Exception("parse error");

                if (line.Length >= 9) {
                    msgid = line.Substring(7, line.Length - 8);
                    break;
                }
            }
        }

        return msgid;
    }
}
