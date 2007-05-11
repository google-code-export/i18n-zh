*) 翻译格式

    统一采用 msgmerge 翻译格式，提交之前先格式化 po 文件。

    gettext 的 Windows 平台二进制包可以从 i18n-zh 下载。

1. 检查翻译
    msgfmt --statistics -c zh.po

2. 格式化
    msgmerge --no-wrap -o zh.po.new zh.po book.pot
    diff zh.po zh.po.new
    mv -f zh.po.new zh.po

3. 以它人的翻译为准合并
      msgmerge -o zh-new.po zh-other.po zh.po
      mv -f zh-new.po zh.po


*) 查阅上下文：
    如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在 build\en\book.xml 中的位置，例如：

    #: build/en/book.xml:10070(title)
    msgid "Choosing a Data Store"
    msgstr "选择数据存储格式"

    打开 build/en/book.xml，定位到 10070 行即可。
