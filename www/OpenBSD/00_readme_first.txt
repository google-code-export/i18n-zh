//
// asciidoc -a toc -a toclevels=3 -a numbered 00_readme_first.txt
//

= 翻译 OpenBSD 文档的方法

== 安装工具

=== iconv

iconv 用来将英文的 ISO-8859-1 编码无损转换为 UTF-8 编码。
----------------------------------------------------------------
$ cd /usr/ports/converters/libiconv
$ make install
$ iconv --version
iconv (GNU libiconv 1.9)
Copyright (C) 2000-2002 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Bruno Haible.
----------------------------------------------------------------

=== validate

推荐使用 validate 校验 HTML 文档的合法性。
----------------------------------------------------------------
$ cd /usr/ports/textproc/validate
$ make install
$ validate -v
Offline HTMLHelp.com Validator, Version 1.2.2
by Liam Quinn <liam@htmlhelp.com>
----------------------------------------------------------------

但是你也可以使用 tidy(由于换行问题，其输出文件不能满足要求):
----------------------------------------------------------------
$ cd /usr/ports/www/tidy
$ make install
$ tidy -v
HTML Tidy for OpenBSD released on 1 September 2005
----------------------------------------------------------------

由于官方不再发布打包后的代码，所以最新的 tidy 只能从 CVS 获得:
----------------------------------------------------------------
$ cvs -d :pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy co tidy
$ cd tidy/build/gmake
$ sudo gmake install
$ tidy -v
HTML Tidy for OpenBSD released on 25 January 2008
----------------------------------------------------------------

tidy 的配置文件:
----------------------------------------------------------------
$ cat ~/tidy.conf
bare: yes
# break-before-br: yes
# doctype: transitional
drop-empty-paras: no
# drop-proprietary-attributes: yes
indent: auto
newline: LF
output-bom: no
output-encoding: utf8
output-html: yes
quiet: yes
tidy-mark: no
# wrap: 0
write-back: no
----------------------------------------------------------------

=== linkchecker
强烈建议使用 linkchecker 检查 HTML 文档是否有死链接。
----------------------------------------------------------------
$ cd /usr/ports/www/linkchecker
$ make install
$ linkchecker -V
LinkChecker 4.5              Copyright (C) 2000-2006 Bastian Kleineidam
----------------------------------------------------------------

== 工作流程

=== 编码转换

禁止使用 GB18030/GBK/GB2312/Big5 等编码。在工作之前，
要将 HTML 文件的编码从 ISO-8859-1 转换为 UTF-8。例如:
----------------------------------------------------------------
$ iconv -f ISO-8859-1 -t UTF-8 example.html > zh/example.html
----------------------------------------------------------------

=== 翻译文档
准确翻译，仔细复审。然后预览效果，尽量与原文的版面一致。

=== 校验文档

校验文档的格式是否合法。例如:
----------------------------------------------------------------
# $ sed /^[[:space:]]*$/d example.html > tmp

$ validate -w --charset=utf-8 example.html
----------------------------------------------------------------

但是你也可以使用 tidy(由于换行问题，其输出文件不能满足要求):
----------------------------------------------------------------
$ tidy -config ~/tidy.conf -utf8 -o /dev/null example.html
----------------------------------------------------------------

=== 检查链接

使用 linkchecker 检查 HTML 文档是否有死链接。例如:
----------------------------------------------------------------
$ linkchecker -r 1 example.html
----------------------------------------------------------------

== 版本控制

=== 中文翻译版本库
中文翻译小组使用 http://hg.sharesource.org/g11n/[sharesource] 作为主要版本库，
定期同步到 http://code.google.com/p/i18n-zh/[i18n-zh]
和 http://code.google.com/p/openbsdonly/[openbsdonly] 的版本库中。

在完成翻译，通过各种检查后，由 http://code.google.com/p/i18n-zh/[i18n-zh]
小组将文档提交到位于 steelix.kd85.com 的 CVS 版本库，然后回写(CVS keyword)到
http://hg.sharesource.org/g11n/[sharesource]，可能还有
http://code.google.com/p/i18n-zh/[i18n-zh] 和
http://code.google.com/p/openbsdonly/[openbsdonly] 的版本库中。

=== OpenBSD 翻译版本库
目前官方版本库不对翻译人员开放。

在 steelix.kd85.com 有一个不对外提供匿名 CVS 服务的翻译版本库。翻译人员在取得
账户后，可以提交到此版本库中。然后统一由翻译协调者将所有语言的翻译同步到官方
版本库中。

== 加入我们
如果大家发现问题，请先检查 http://hg.sharesource.org/g11n/[sharesource]
中的文件。如果发现 http://hg.sharesource.org/g11n/[sharesource]
中的文件仍旧有此问题，参看 http://hg.sharesource.org/g11n/[sharesource]
中的版本信息，将问题或补丁发给 http://code.google.com/p/i18n-zh/[i18n-zh]
的http://groups.google.com/group/i18n-zh/[讨论组]或译者。

如果你有兴趣参加，请在 http://code.google.com/p/i18n-zh/[i18n-zh]
的http://groups.google.com/group/i18n-zh/[讨论组]发言。只有在提交数个网页的合
格翻译后，才能获得 http://hg.sharesource.org/g11n/[sharesource] 的写权限。
