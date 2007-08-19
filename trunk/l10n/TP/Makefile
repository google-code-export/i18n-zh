all:
	@echo "Usage:"
	@echo " make status - show status"
	@echo " make check  - confirm the translated file does not contain invalid(?) char"

status:
	@for file in `find . -type f -name '*.po'`; do \
		printf "%s: " `basename $$file`; \
		msgfmt --statistics -c -v -o /dev/null $$file 2>&1; \
	done

check:
	@for file in `find . -type f -name '*.po'`; do \
		printf "%s: " `basename $$file`; \
		grep msgstr $$file \
			| grep -v "·" \
			| grep -v "©" \
			| iconv -f utf8 -t gb2312 > /dev/null \
		&& echo "OK"; \
	done
