#
# Makefile for the svnbook, LINGUA=zh
#

LINGUA=zh
FORMATS=html html-single pdf

UPDATEPO = PERLLIB=../../tools/po4a/lib/ ../../tools/po4a/po4a-updatepo -M UTF-8 \
       -f docbook -o doctype='docbook' -o includeexternal \
       -o nodefault='<programlisting> <screen>' \
       -o untranslated='<programlisting> <screen>'
TRANSLATE = PERLLIB=../tools/po4a/lib/ ../tools/po4a/po4a-translate -M UTF-8 \
       -f docbook -o doctype='docbook' \
       -k 0

help:
	@echo "  make html"
	@echo "  make html-single"
	@echo "  make pdf"
	@echo "  make validate      # always before commit!"
	@echo "  make tidypo        # always before commit!"
	@echo "  make updatepo      # update po files."
	@echo "  make all"
	@echo "  make stat"
	@echo "  make clean"

clean:
	@rm -fr build ../en/book/version.xml po/*.mo

all:
	for f in $(FORMATS); do \
	  $(MAKE) $$f; \
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
	for po in $(wildcard po/*.po); do \
	  msgcat --sort-by-file --width=80 $$po > $$po.tmp && mv $$po.tmp $$po; \
	done

updatepo:
	(cd po && $(UPDATEPO) -m ../../en/book/book.xml -p $(LINGUA).po)
	$(MAKE) tidypo

validate: build/source/svnbook.xml
	xmllint --nonet --noout --postvalid --xinclude $<

build/source/version.xml: $(filter-out ../en/book/version.xml, $(wildcard ../en/book/*.xml)) po/$(LINGUA).po
	mkdir -p build/source
	cp ../en/book/*.xml build/source
	@echo '<!ENTITY svn.version "r'`LC_ALL=C svn info en | grep 'Last Changed Rev: ' | awk '{print $$4}'`'">' > $@
	@echo '<!ENTITY svn.l10n_revision "r'`LC_ALL=C svn info po/$(LINGUA).po | grep 'Last Changed Rev: ' | awk '{print $$4}'`'/">' >> $@

build/source/svnbook.xml: $(filter-out ../en/book/version.xml, $(wildcard ../en/book/*.xml)) po/$(LINGUA).po build/source/version.xml
	mkdir -p build/source/images
	cp ../en/book/images/*.png build/source/images
	for f in ../en/book/*.xml; do \
	  if [ $$f != "../en/book/version.xml" ]; then \
	    $(TRANSLATE) -m $$f -p po/$(LINGUA).po -l build/source/`basename $$f`; \
	  fi \
	done
	xmllint --nonet --noent --xinclude --postvalid --output $@ build/source/book.xml

html: build/html/index.html

build/html/index.html: build/source/svnbook.xml ../stylesheets/html.xsl ../stylesheets/$(LINGUA)/html.xsl
	mkdir -p build/html/images
	cp ../en/book/styles.css build/html
	cp ../en/book/images/*.png build/html/images
	xsltproc --output build/html/ \
	    ../stylesheets/$(LINGUA)/html.xsl build/source/svnbook.xml

html-single: build/html-single/svnbook.html

build/html-single/svnbook.html: build/source/svnbook.xml ../stylesheets/html-single.xsl ../stylesheets/$(LINGUA)/html-single.xsl
	mkdir -p build/html-single/images
	cp ../en/book/styles.css build/html-single
	cp ../en/book/images/*.png build/html-single/images
	xsltproc --output build/html-single/svnbook.html \
	    ../stylesheets/$(LINGUA)/html-single.xsl build/source/svnbook.xml

pdf: build/pdf/svnbook.pdf

build/pdf/svnbook.pdf: build/source/svnbook.xml ../stylesheets/fo.xsl ../stylesheets/$(LINGUA)/fo.xsl
	mkdir -p build/pdf
	java -classpath ../tools/fop/lib/saxon65.jar:../tools/fop/lib/saxon65-dbxsl.jar:../tools/fop/lib/xml-commons-resolver-1.2.jar:../tools/fop/conf \
	    com.icl.saxon.StyleSheet \
	    -x org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -y org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -r org.apache.xml.resolver.tools.CatalogResolver \
	    -o build/source/svnbook.fo \
	    build/source/svnbook.xml \
	    ../stylesheets/$(LINGUA)/fo.xsl \
	    fop1.extensions=1

	(cd build/source && ../../../tools/fop/fop.sh svnbook.fo ../pdf/svnbook.pdf)
