all:
	@echo "Usage:"
	@echo " make status - show status"

status:
	@for file in `find . -type f -name '*.po'`; do \
		printf "%s: " `basename $$file`; \
		msgfmt --statistics -c -v -o /dev/null $$file 2>&1; \
	done

