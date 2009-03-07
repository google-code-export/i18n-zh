#
# Makefile for the svnbook, top-level
#

FORMATS=html pdf

PO_LANGUAGES := zh
DBK_LANGUAGES := en de
LANGUAGES := $(DBK_LANGUAGES) $(PO_LANGUAGES)

UPDATEPO = PERLLIB=../tools/po4a/lib/ ../tools/po4a/po4a-updatepo -M UTF-8 \
	   -f docbook -o doctype='docbook' -o includeexternal \
	   -o nodefault='<programlisting> <screen>' \
	   -o untranslated='<programlisting> <screen>'
TRANSLATE = PERLLIB=tools/po4a/lib/ tools/po4a/po4a-translate -M UTF-8 \
	   -f docbook -o doctype='docbook' \
	   -k 0

help:
	@echo "  make html         [LINGUA=en|de|zh|...]"
	@echo "  make html-single  [LINGUA=en|de|zh|...]"
	@echo "  make pdf          [LINGUA=en|de|zh|...]"
	@echo "  make validate     [LINGUA=en|de|zh|...] # always before commit!"
	@echo "  make tidypo       [LINGUA=zh|...]       # always before commit!"
	@echo "  make updatepo     [LINGUA=zh|...]       # update po files."
	@echo "  make stat         # print statistics about po files."
	@echo "  make all          # make html & pdf output of all languages."
	@echo "  make clean        # Remove the build files."

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
	(cd en && $(UPDATEPO) -m book.xml -p ../po/$(LINGUA).po)
	$(MAKE) tidypo LINGUA=$$l
endif
endif

ifndef LINGUA
validate:
	for l in $(LANGUAGES); do \
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
	mkdir -p build/$(LINGUA)/source/images
	cp $(LINGUA)/*.xml build/$(LINGUA)/source
	cp $(LINGUA)/images/*.png build/$(LINGUA)/source/images
	xmllint --nonet --noent --xinclude --postvalid --output $@ $(LINGUA)/book.xml
else
build/$(LINGUA)/source/version.xml: $(filter-out en/version.xml, $(wildcard en/*.xml)) po/$(LINGUA).po
	mkdir -p build/$(LINGUA)/source
	cp en/*.xml build/$(LINGUA)/source
	@echo '<!ENTITY svn.version "r'`LC_ALL=C svn info en | grep 'Last Changed Rev: ' | awk '{print $$4}'`'">' > $@
	@echo '<!ENTITY svn.l10n_revision "r'`LC_ALL=C svn info po/$(LINGUA).po | grep 'Last Changed Rev: ' | awk '{print $$4}'`'/">' >> $@

build/$(LINGUA)/source/svnbook.xml: $(filter-out en/version.xml, $(wildcard en/*.xml)) po/$(LINGUA).po build/$(LINGUA)/source/version.xml
	mkdir -p build/$(LINGUA)/source/images
	cp en/images/*.png build/$(LINGUA)/source/images
	for f in en/*.xml; do \
	    if [ $$f != "en/version.xml" ]; then \
	        $(TRANSLATE) -m $$f -p po/$(LINGUA).po -l build/$(LINGUA)/source/`basename $$f`; \
            fi \
	done
	xmllint --nonet --noent --xinclude --postvalid --output $@ build/$(LINGUA)/source/book.xml
endif

endif

ifndef LINGUA
html:
	for l in $(LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
else
html: build/$(LINGUA)/html/index.html

build/$(LINGUA)/html/index.html: build/$(LINGUA)/source/svnbook.xml stylesheets/html.xsl stylesheets/$(LINGUA)/html.xsl
	mkdir -p build/$(LINGUA)/html/images
	cp en/styles.css build/$(LINGUA)/html
	cp en/images/*.png build/$(LINGUA)/html/images
	xsltproc --output build/$(LINGUA)/html/ \
	    stylesheets/$(LINGUA)/html.xsl build/$(LINGUA)/source/svnbook.xml
endif

ifndef LINGUA
html-single:
	for l in $(LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
else
html-single: build/$(LINGUA)/html-single/svnbook.html

build/$(LINGUA)/html-single/svnbook.html: build/$(LINGUA)/source/svnbook.xml stylesheets/html-single.xsl stylesheets/$(LINGUA)/html-single.xsl
	mkdir -p build/$(LINGUA)/html-single/images
	cp en/styles.css build/$(LINGUA)/html-single
	cp en/images/*.png build/$(LINGUA)/html-single/images
	xsltproc --output build/$(LINGUA)/html-single/svnbook.html \
	    stylesheets/$(LINGUA)/html-single.xsl build/$(LINGUA)/source/svnbook.xml
endif

ifndef LINGUA
pdf:
	for l in $(LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
else
pdf: build/$(LINGUA)/pdf/svnbook.pdf

build/$(LINGUA)/pdf/svnbook.pdf: build/$(LINGUA)/source/svnbook.xml stylesheets/fo.xsl stylesheets/$(LINGUA)/fo.xsl
	mkdir -p build/$(LINGUA)/pdf
	java -classpath tools/fop/lib/saxon65.jar:tools/fop/lib/saxon65-dbxsl.jar:tools/fop/lib/xml-commons-resolver-1.2.jar:tools/fop/conf \
	    com.icl.saxon.StyleSheet \
	    -x org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -y org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -r org.apache.xml.resolver.tools.CatalogResolver \
	    -o build/$(LINGUA)/source/svnbook.fo \
	    build/$(LINGUA)/source/svnbook.xml \
	    stylesheets/$(LINGUA)/fo.xsl \
	    fop1.extensions=1

	(cd build/$(LINGUA)/source && ../../../tools/fop/fop.sh svnbook.fo ../pdf/svnbook.pdf)
endif
