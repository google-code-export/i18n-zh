#
# Makefile for the svnbook, top-level
#

FORMATS=html pdf
PO_LANGUAGES := de zh
LANGUAGES := en $(PO_LANGUAGES)

XSLP =? xsltproc --nonet --novalid --xinclude
# XSLP =? saxon

FO2PDF =? fop
# FO2PDF =? xep

UPDATEPO = PERLLIB=tools/po4a/lib/ tools/po4a/po4a-updatepo --format docbook
TRANSLATE = PERLLIB=tools/po4a/lib/ tools/po4a/po4a-translate --format docbook --keep 0

all:
	for l in $(LANGUAGES); do \
	    for f in $(FORMATS); do \
		$(MAKE) LANG=$$l $$f; \
	    done; \
	done

help:
	@echo "  make html      [LINGUA=en|de|zh|...]"
	@echo "  make pdf       [LINGUA=en|de|zh|...]"
	@echo "  make updatepo  [LINGUA=de|zh|...]"
	@echo "  make tidypo    [LINGUA=de|zh|...] # always before commit!"
	@echo "  make validate  [LINGUA=de|zh|...] # always before commit!"
	@echo "  make stat      [LINGUA=de|zh|...] # print statistics about translations"

stat:
ifdef LINGUA
	@( \
		LANG=C; export LANG; cd po; \
		printf "%s\t" $(LINGUA).po; \
		msgfmt --statistics -c $(LINGUA).po; \
	)
else
	@( \
		LANG=C; export LANG; cd po; \
		for f in *.po; do \
		    printf "%s\t" $$f; \
		    msgfmt --statistics -c $$f; \
		done; \
	)
endif

tidypo:
ifdef LINGUA
	msgcat -w 80 po/$(LINGUA).po > po/$(LINGUA).tmp && mv po/$(LINGUA).tmp po/$(LINGUA).po;
else
	for po in $(wildcard po/*.po); do \
	    msgcat -w 80 $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
endif

ifdef LINGUA
updatepo:
	$(UPDATEPO) -M UTF-8 \
		--master source/appa-quickstart.xml \
		--master source/appb-svn-for-cvs-users.xml \
		--master source/appc-webdav.xml \
		--master source/book.xml \
		--master source/ch00-preface.xml \
		--master source/ch01-fundamental-concepts.xml \
		--master source/ch02-basic-usage.xml \
		--master source/ch03-advanced-topics.xml \
		--master source/ch04-branching-and-merging.xml \
		--master source/ch05-repository-admin.xml \
		--master source/ch06-server-configuration.xml \
		--master source/ch07-customizing-svn.xml \
		--master source/ch08-embedding-svn.xml \
		--master source/ch09-reference.xml \
		--master source/copyright.xml \
		--master source/foreword.xml \
		--po po/$(LINGUA).po
else
updatepo:
	for l in $(PO_LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
endif
