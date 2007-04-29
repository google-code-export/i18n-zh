作者：
    *) Dongsheng Song <dongsheng.song@gmail.com>, 2007

用法：
    *) 根据本机配置修改 build.tmpl.properties，生成 build.properties
    *) 生成 html 输出格式：ant html
    *) 生成 pdf  输出格式：ant pdf
    *) 生成 所有 输出格式：ant all

    *) 生成英文 html 输出格式：ant html.en
    *) 生成英文 pdf  输出格式：ant pdf.en

依赖：
    *) python 2.4+              : http://www.python.org/windows/
    *) python-libxml2 2.6.27+   : http://users.skynet.be/sbi/libxml-python/
    *) xsltproc 1.1.20+         : http://www.zlatkovic.com/libxml.en.html
    *) gettext 0.16+            : http://code.google.com/p/i18n-zh/downloads/list
    *) jdk 1.4.2+               : http://java.sun.com/javase/downloads/
    *) xml2po 0.10.3            : 已经包含在 svn 仓库中。http://svn.gnome.org/viewcvs/
    
    PS：以上只给出了其 Windows 系统二进制包的下载地址。linux 系统已经包含在发布各种发布版本中。

计划：
    *) 增加多语言支持
    *) 增加 chm 输出支持，它只能在 Windows 中构建，是否必要？
    *) ...

规范 po 文件格式：
    msgmerge --no-wrap -F -o zh.po.new zh.po book.pot
    diff zh.po.new zh.po
    mv zh.po.new zh.po

查阅上下文：
    如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在 build\en\book.xml 中的位置，例如：

    #: build/en/book.xml:10070(title)
    msgid "Choosing a Data Store"
    msgstr "选择数据存储格式"

    打开 build/en/book.xml，定位到 10070 行即可。
