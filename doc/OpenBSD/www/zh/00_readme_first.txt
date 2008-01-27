//
// asciidoc -a toc -a numbered 00_readme_first.txt
//

== Install HTML tools

=== tidy
----------------------------------------------------------------
$ cd /usr/ports/www/tidy
$ make install
$ tidy -v
HTML Tidy for OpenBSD released on 1 September 2005

$ cvs -d :pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy co tidy
$ cd tidy/build/gmake
$ sudo gmake install
$ tidy -v
HTML Tidy for OpenBSD released on 25 January 2008
----------------------------------------------------------------

=== validate
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


== Validate, correct, and pretty HTML file

=== tidy
----------------------------------------------------------------
# $ sed /^[[:space:]]*$/d example.html > tmp

$ tidy -utf8 -b -i -q --wrap 0 --output-bom no --newline LF -asxhtml \
      --tidy-mark no --doctype transitional -m example.html
----------------------------------------------------------------

=== validate
----------------------------------------------------------------
$ validate -w --charset=utf-8 example.html
----------------------------------------------------------------


== Check HTML file for broken links

=== linkchecker
----------------------------------------------------------------
$ linkchecker -r 1 example.html
----------------------------------------------------------------
