*) docbook 开发信息
    https://docbook.org
    https://docbook.sourceforge.net
    https://sourceforge.net/projects/docbook

    https://docbook.svn.sourceforge.net/svnroot/docbook/trunk


*) docbook 翻译格式

    统一采用 msgmerge 翻译格式，提交之前先格式化 po 文件。

    gettext 的 Windows 平台二进制包可以从 i18n-zh 下载。

1. 检查翻译
    msgfmt --statistics -c zh_CN.po

2. 格式化
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po defguide.pot
    diff zh_CN.po zh_CN-new.po
    mv -f zh_CN-new.po zh_CN.po

3. 以它人的翻译为准合并
      msgmerge -o zh_CN-new.po zh_CN-other.po zh_CN.po
      mv -f zh_CN-new.po zh_CN.po


*) 查阅上下文：
    如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在 build/en/defguide.xml 中的位置，例如：

    #: build/en/defguide.xml:4110(para)
    msgid "Add new elements"
    msgstr ""

    打开 build/en/defguide.xml，定位到 4110 行即可。
