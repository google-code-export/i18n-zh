all:

zh_CN.mo: zh_CN.po
	msgfmt --statistics -c -v -o $@ $<

install: zh_CN.mo
	cp $< /usr/share/locale/zh_CN/LC_MESSAGES/psmisc.mo
