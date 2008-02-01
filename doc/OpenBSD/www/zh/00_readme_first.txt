//
// asciidoc -a toc -a toclevels=3 -a numbered 00_readme_first.txt
//

= Translation of the OpenBSD documentation

== Install tools

=== iconv
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

=== tidy

We prefer tidy:
----------------------------------------------------------------
$ cd /usr/ports/www/tidy
$ make install
$ tidy -v
HTML Tidy for OpenBSD released on 1 September 2005
----------------------------------------------------------------

The latest version of tidy is exclusively available through CVS:

----------------------------------------------------------------
$ cvs -d :pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy co tidy
$ cd tidy/build/gmake
$ sudo gmake install
$ tidy -v
HTML Tidy for OpenBSD released on 25 January 2008
----------------------------------------------------------------

The configuration of tidy:
----------------------------------------------------------------
$ cat ~/tidy.conf
bare: yes
# break-before-br: yes
doctype: transitional
drop-empty-paras: yes
drop-proprietary-attributes: yes
indent: auto
newline: LF
output-bom: no
output-encoding: utf8
output-xhtml: yes
quiet: yes
tidy-mark: no
word-2000: yes
wrap: 0
write-back: yes
----------------------------------------------------------------

But you can use validate instead:
----------------------------------------------------------------
$ cd /usr/ports/textproc/validate
$ make install
$ validate -v
Offline HTMLHelp.com Validator, Version 1.2.2
by Liam Quinn <liam@htmlhelp.com>
----------------------------------------------------------------

=== linkchecker
----------------------------------------------------------------
$ cd /usr/ports/www/linkchecker
$ make install
$ linkchecker -V
LinkChecker 4.5              Copyright (C) 2000-2006 Bastian Kleineidam
----------------------------------------------------------------


== Convert HTML file encoding from  iso-8859-1 to utf-8

Before translation, you must convert HTML files encoding from  iso-8859-1 to utf-8.
For example:
----------------------------------------------------------------
$ iconv -f ISO-8859-1 -t UTF-8 porting.html > zh/porting.html
----------------------------------------------------------------

== Validate, correct, and pretty HTML file


We prefer tidy:
----------------------------------------------------------------
# $ sed /^[[:space:]]*$/d example.html > tmp

$ tidy -config ~/tidy.conf -utf8 example.html
----------------------------------------------------------------

But you can use validate instead:
----------------------------------------------------------------
$ validate -w --charset=utf-8 example.html
----------------------------------------------------------------

== Check HTML file for broken links

----------------------------------------------------------------
$ linkchecker -r 1 example.html
----------------------------------------------------------------
