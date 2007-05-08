规范 po 文件格式：
    msgmerge --no-wrap -F -o zh.po.new zh.po book.pot
    diff zh.po.new zh.po
    mv -f zh.po.new zh.po

查阅上下文：
    如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在 build\en\book.xml 中的位置，例如：

    #: build/en/book.xml:10070(title)
    msgid "Choosing a Data Store"
    msgstr "选择数据存储格式"

    打开 build/en/book.xml，定位到 10070 行即可。
