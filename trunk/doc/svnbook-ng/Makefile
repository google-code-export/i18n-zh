#
# Makefile for the svnbook, top-level
#

FORMATS=html pdf

PO_LANGUAGES := zh
DBK_LANGUAGES := en de
LANGUAGES := $(DBK_LANGUAGES) $(PO_LANGUAGES)

XSLP =? xsltproc --nonet --novalid --xinclude
# XSLP =? saxon

FO2PDF =? fop
# FO2PDF =? xep

UPDATEPO = PERLLIB=tools/po4a/lib/ tools/po4a/po4a-updatepo -M UTF-8 -f docbook
TRANSLATE = PERLLIB=tools/po4a/lib/ tools/po4a/po4a-translate -M UTF-8 -f docbook -k 0

help:
	@echo "  make html      [LINGUA=en|de|zh|...]"
	@echo "  make pdf       [LINGUA=en|de|zh|...]"
	@echo "  make validate  [LINGUA=en|de|zh|...] # always before commit!"
	@echo "  make tidypo    [LINGUA=zh|...]       # always before commit!"
	@echo "  make updatepo  [LINGUA=zh|...]       # update po files."
	@echo "  make stat      # print statistics about po files."
	@echo "  make all       # make html & pdf output of all languages."
	@echo "  make clean     # Remove the build files."

clean:
	@rm -fr build en/version.xml po/*.mo

all:
	for l in $(LANGUAGES); do \
	    for f in $(FORMATS); do \
		$(MAKE) LANG=$$l $$f; \
	    done; \
	done

stat:
	@( \
	LANG=C; export LANG; cd po; \
	for f in *.po; do \
	    printf "%s\t" $$f; \
	    msgfmt --statistics -c $$f; \
	done; \
	)

tidypo:
ifdef LINGUA
	msgcat --sort-by-file --width=80 po/$(LINGUA).po > po/$(LINGUA).tmp && \
	    mv po/$(LINGUA).tmp po/$(LINGUA).po;
else
	for po in $(wildcard po/*.po); do \
	    msgcat --sort-by-file --width=80 $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
endif

ifndef LINGUA
updatepo:
	for l in $(PO_LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
else
updatepo:
ifneq "$(findstring $(LINGUA),$(PO_LANGUAGES))" ""
	$(UPDATEPO) \
		-m en/appa-quickstart.xml \
		-m en/appb-svn-for-cvs-users.xml \
		-m en/appc-webdav.xml \
		-m en/book.xml \
		-m en/ch00-preface.xml \
		-m en/ch01-fundamental-concepts.xml \
		-m en/ch02-basic-usage.xml \
		-m en/ch03-advanced-topics.xml \
		-m en/ch04-branching-and-merging.xml \
		-m en/ch05-repository-admin.xml \
		-m en/ch06-server-configuration.xml \
		-m en/ch07-customizing-svn.xml \
		-m en/ch08-embedding-svn.xml \
		-m en/ch09-reference.xml \
		-m en/copyright.xml \
		-m en/foreword.xml \
		-p po/$(LINGUA).po
	$(MAKE) tidypo LINGUA=$$l
endif
endif

ifndef LINGUA
validate:
	for l in $(PO_LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
else
validate: build/$(LINGUA)/source/svnbook.xml
	xmllint --nonet --noout --postvalid --xinclude $<

ifneq "$(findstring $(LINGUA),$(DBK_LANGUAGES))" ""
$(LINGUA)/version.xml: $(filter-out $(LINGUA)/version.xml, $(wildcard $(LINGUA)/*.xml))
	@echo '<!ENTITY svn.version "r'`LC_ALL=C svn info $(LINGUA) | grep 'Last Changed Rev: ' | awk '{print $$4}'`'">' > $@
	@echo '<!ENTITY svn.l10n_revision "">' >> $@

build/$(LINGUA)/source/svnbook.xml: $(wildcard $(LINGUA)/*.xml) $(LINGUA)/version.xml
	mkdir -p build/$(LINGUA)/source
	cp -r $(LINGUA)/* build/$(LINGUA)/source
	xmllint --nonet --noent --xinclude --postvalid --output $@ $(LINGUA)/book.xml
else
build/$(LINGUA)/source/version.xml: $(filter-out en/version.xml, $(wildcard en/*.xml)) po/$(LINGUA).po
	mkdir -p build/$(LINGUA)/source
	cp -r en/* build/$(LINGUA)/source
	@echo '<!ENTITY svn.version "r'`LC_ALL=C svn info en | grep 'Last Changed Rev: ' | awk '{print $$4}'`']">' > $@
	@echo '<!ENTITY svn.l10n_revision "[r'`LC_ALL=C svn info po/$(LINGUA).po | grep 'Last Changed Rev: ' | awk '{print $$4}'`'/">' >> $@

build/$(LINGUA)/source/svnbook.xml: $(filter-out en/version.xml, $(wildcard en/*.xml)) po/$(LINGUA).po build/$(LINGUA)/source/version.xml
	for f in en/*.xml; do \
	    $(TRANSLATE) -m $$f -p po/$(LINGUA).po -l build/$(LINGUA)/source/`basename $$f`; \
	done
	xmllint --nonet --noent --xinclude --postvalid --output $@ build/$(LINGUA)/source/book.xml
endif

endif
