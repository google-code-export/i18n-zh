all: zh_CN.mo
	@for file in *.po; do \
		/bin/echo -e -n "$$file\t"; \
		msgfmt -v $$file; \
	done

zh_CN.mo: zh_CN.po
	msgfmt -o $@ -v $<

install: all
	install -d /usr/share/locale/zh_CN/LC_MESSAGES/
	install -o root -g root -m 644 zh_CN.mo /usr/share/locale/zh_CN/LC_MESSAGES/nano.mo
