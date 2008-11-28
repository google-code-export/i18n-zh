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
 * 准确翻译，仔细复审。
 * 除非必要，不许增删改 HTML 标签，或者调整这些标签的顺序。
 * 预览效果，尽量与原文的版面一致。
 * 尽量保证行长不大于 72 个英文字符。
 * 注意换行引入的额外空格。尽量在需要加入空格的地方或标点符号之后换行。
 * 不许修改版权信息，包括年份。
 * 由于http://steelix.kd85.com/translation/tagreport/#zh[标签报告]的问题，建议使用文本编辑器从事翻译工作。
 * 经常浏览http://steelix.kd85.com/translation/status.html#zh[翻译状态页面]，及时更新。

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

中文翻译小组使用 http://hg.sharesource.org/g11n/[sharesource] 作为主要版本库，
定期同步到 http://code.google.com/p/i18n-zh/[i18n-zh]
和 http://code.google.com/p/openbsdonly/[openbsdonly]。


在完成翻译，通过各种检查后，由 http://code.google.com/p/i18n-zh/[i18n-zh]
小组将文档提交到位于 steelix.kd85.com 的 CVS 版本库(steelix-www)，然后回写 CVS 标签到
http://hg.sharesource.org/g11n/[sharesource]，可能还有
http://code.google.com/p/i18n-zh/[i18n-zh] 和
http://code.google.com/p/openbsdonly/[openbsdonly]。


目前官方版本库(openbsd-www)不对翻译人员开放。在 steelix.kd85.com 有一个不对外提供匿名
CVS 服务的翻译版本库(steelix-www)。翻译人员与翻译协调者联系，取得账户后，
可以提交到此版本库中。然后统一由翻译协调者将所有语言的翻译同步到官方版本库中。

=== 从匿名 CVS 服务器更新
----------------------------------------------------------------
WC_CVS=/usr/www
WC_HG=/home/dongsheng/var/hg/g11n

# for i in . faq faq/pf openbgpd opencvs openntpd openssh papers porting spamd; do
#     /bin/rm ${WC_CVS}/${i}/*.html
# done
# cd ${WC_CVS} && cvs up

for i in . faq faq/pf openbgpd opencvs openntpd openssh papers porting spamd; do
    /bin/cp ${WC_CVS}/${i}/*.html ${WC_HG}/os/OpenBSD/www/${i}
done

cd ${WC_HG}/os/OpenBSD/www/ && hg purge -f .
# cd ${WC_HG}/os/OpenBSD/www/ && hg ci -m "Sync with AnonCVS" .
----------------------------------------------------------------

=== 从 steelix 检出
对于 steelix 的文档，不需要全部检出，只检出我们需要的部分即可。首先执行非递归检出，例如：
----------------------------------------------------------------
cd /home/dongsheng/var/cvs
cvs -d dongsheng@steelix.kd85.com:/cvs co -l -d steelix-www www
----------------------------------------------------------------

然后就可以执行非递归更新了，例如只检出/更新当前翻译相关部分：
----------------------------------------------------------------
cd /home/dongsheng/var/cvs/steelix-www

cvs up -l images
cvs up -l zh
cvs up -l opencvs
cvs up -l opencvs/images
cvs up -l opencvs/zh
cvs up -l faq
cvs up -l faq/images
cvs up -l faq/zh
cvs up -l faq/pf
cvs up -l faq/pf/zh
cvs up -l spamd
cvs up -l spamd/zh
----------------------------------------------------------------

=== 提交到 steelix

从 sharesource 提交到 steelix 后，再向 sharesource 同步 CVS 标签。
----------------------------------------------------------------
WC_CVS=/home/dongsheng/var/cvs/steelix-www
WC_HG=/home/dongsheng/var/hg/g11n

for i in zh opencvs/zh faq/zh faq/pf/zh spamd/zh; do
    /bin/cp ${WC_HG}/os/OpenBSD/www/${i}/*.html ${WC_CVS}/${i}
done

cd ${WC_CVS} && cvs ci -m "Sync with http://hg.sharesource.org/g11n/"

for i in zh opencvs/zh faq/zh faq/pf/zh spamd/zh; do
    /bin/cp ${WC_CVS}/${i}/*.html  ${WC_HG}/os/OpenBSD/www/${i}
done

cd ${WC_HG} && hg ci -m "Sync CVS Tags"
----------------------------------------------------------------

== 加入我们
如果大家发现问题，请先检查 http://hg.sharesource.org/g11n/[sharesource]
中的文件。如果发现 http://hg.sharesource.org/g11n/[sharesource]
中的文件仍旧有此问题，参看 http://hg.sharesource.org/g11n/[sharesource]
中的版本信息，将问题或补丁发给 http://code.google.com/p/i18n-zh/[i18n-zh]
的http://groups.google.com/group/i18n-zh/[讨论组]或译者。

如果你有兴趣参加，请在 http://code.google.com/p/i18n-zh/[i18n-zh]
的http://groups.google.com/group/i18n-zh/[讨论组]发言。
在提交数个网页的合格翻译后，会被授予 http://hg.sharesource.org/g11n/[sharesource]
的写权限。
