all:

zh_CN.mo: cpio-2.7.zh_CN.po
	msgfmt --statistics -c -v -o $@ $<

install: zh_CN.mo
	cp $< /usr/share/locale/zh_CN/LC_MESSAGES/cpio.mo
