[RFC] 建立翻译共享池
====================
鉴于poEdit等工具的翻译词库功能太弱，所以决定开发一个翻译共享池软件。它可以简单
的增加翻译资源，使用高度智能的匹配算法执行机器翻译，除了给出准确的翻译之外，还
尽量给出更多的混淆翻译。


增加新的翻译资源(tsp push)
--------------------------
增加po文件或目录中的所有mo文件之翻译字符串到翻译共享池。例如：

    tsp push /usr/share/locale
    tsp push tortoisesvn/doc/po/ tortoisesvn/Languages/
    tsp push zh_CN.po

PS: 目前准备只加入准确翻译，依照从左到右的顺序加入文件，如果是目录，则深度
优先，按照字母顺序排序文件。如果出现翻译冲突，则以最后加入的翻译为准。


使用翻译资源更新po文件(tsp pull)
--------------------------------
使用翻译共享池中的翻译字符串更新po文件，给出准确翻译和混淆翻译。例如：

    tsp pull zh_CN.po

PS: 目前准备用 msgmerge 执行匹配。如果选择相信自己的翻译，请在更新前将自己的翻
译加入翻译共享池。


输出统计信息(tsp stat)
----------------------
输出翻译共享池中的翻译字符串统计信息。例如：

    tsp stat
    zh_CN: ??? strings
    zh_TW: ??? strings
    ...


翻译共享池的存储格式
====================
在其数据目录内，每个区域有一个xml文件保存翻译字符串，翻译字符串按照字母顺序
排序。以zhCN.xml为例：
<?xml version="1.0" encoding="UTF-8"?>
<pool locale="zh_CN">
    <record>
        <msgid>AAA</msgid>
        <msgstr>111</msgstr>
    </record>
    <record>
        <msgid>BBB</msgid>
        <msgstr>222</msgstr>
    </record>
    <record>
        <msgid>CCC</msgid>
        <msgstr>333</msgstr>
    </record>
</pool>


[TODO]
======
优先级很低的功能，可能永远不实现。


支持单复数
----------


追踪翻译资源
------------
记录翻译字符串的来源，帮助修正其它软件的错误翻译。


选择更新或交互更新
------------------
是否使用翻译共享池中的翻译字符串更新没有标记为混淆的翻译？
如果两个翻译不同，能否让用户介入，选择合适的翻译？
