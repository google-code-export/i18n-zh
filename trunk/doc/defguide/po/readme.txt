docbook 开发资源
----------------
    https://docbook.org
    https://docbook.sourceforge.net
    https://sourceforge.net/projects/docbook

    https://docbook.svn.sourceforge.net/svnroot/docbook/trunk


docbook 翻译格式
----------------
    统一采用 gettext 翻译格式，提交之前先格式化 po 文件。

    gettext 的 Windows 平台二进制包可以从 i18n-zh 下载。


docbook 翻译方法
----------------

更新到最新版本的 pot 文件
~~~~~~~~~~~~~~~~~~~~~~~~~
    msgmerge --update zh_CN.po defguide.pot

开始翻译 po 文件
~~~~~~~~~~~~~~~~
    使用 poedit 或 KBabel，甚至普通文本编辑器。

检查翻译
~~~~~~~~
    msgfmt --statistics -c zh_CN.po

格式化
~~~~~~
    msgmerge --width=96 -o zh_CN_new.po zh_CN.po defguide.pot
    mv -f zh_CN_new.po zh_CN.po

以它人的翻译为准合并
~~~~~~~~~~~~~~~~~~~~
如果需要以自己的为准合并，交换 zh_CN.po 和 zh_CN-other.po 即可。

使用 Subversion 的 po-merge.py
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po

使用 translation tookit 的 pomerge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po

查阅上下文
~~~~~~~~~~
    如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在 build/en/defguide.xml 中的位置，例如：

    #: build/en/defguide.xml:4110(para)
    msgid "Add new elements"
    msgstr ""

    打开 build/en/defguide.xml，定位到 4110 行即可。
