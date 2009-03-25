#
# Makefile for the svnbook, LINGUA=zh
#

LINGUA=en
FORMATS=html html-single pdf

help:
	@echo "  make html"
	@echo "  make html-single"
	@echo "  make pdf"
	@echo "  make validate      # always before commit!"
	@echo "  make all"
	@echo "  make clean"

clean:
	@rm -fr build book/version.xml book/svnbook.xml book/svnbook.fo

all:
	for f in $(FORMATS); do \
	  $(MAKE) $$f; \
	done

validate: book/svnbook.xml
	xmllint --nonet --noout --postvalid --xinclude $<

book/version.xml: $(filter-out book/version.xml book/svnbook.xml, $(wildcard book/*.xml))
	@echo '<!ENTITY svn.version "r'`LC_ALL=C svn info $(LINGUA) | grep 'Last Changed Rev: ' | awk '{print $$4}'`'">' > $@
	@echo '<!ENTITY svn.l10n_revision "">' >> $@

book/svnbook.xml: $(filter-out book/svnbook.xml, $(wildcard book/*.xml)) book/version.xml
	xmllint --nonet --noent --xinclude --postvalid --output $@ book/book.xml

html: build/html/index.html

build/html/index.html: book/svnbook.xml ../stylesheets/html.xsl ../stylesheets/$(LINGUA)/html.xsl
	mkdir -p build/html/images
	cp book/styles.css build/html
	cp book/images/*.png build/html/images
	xsltproc --output build/html/ \
	    ../stylesheets/$(LINGUA)/html.xsl book/svnbook.xml

html-single: build/html-single/svnbook.html

build/html-single/svnbook.html: book/svnbook.xml ../stylesheets/html-single.xsl ../stylesheets/$(LINGUA)/html-single.xsl
	mkdir -p build/html-single/images
	cp book/styles.css build/html-single
	cp book/images/*.png build/html-single/images
	xsltproc --output build/html-single/svnbook.html \
	    ../stylesheets/$(LINGUA)/html-single.xsl book/svnbook.xml

pdf: build/pdf/svnbook.pdf

build/pdf/svnbook.pdf: book/svnbook.xml ../stylesheets/fo.xsl ../stylesheets/$(LINGUA)/fo.xsl
	mkdir -p build/pdf
	java -classpath ../tools/fop/lib/saxon65.jar:../tools/fop/lib/saxon65-dbxsl.jar:../tools/fop/lib/xml-commons-resolver-1.2.jar:../tools/fop/conf \
	    com.icl.saxon.StyleSheet \
	    -x org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -y org.apache.xml.resolver.tools.ResolvingXMLReader \
	    -r org.apache.xml.resolver.tools.CatalogResolver \
	    -o book/svnbook.fo \
	    book/svnbook.xml \
	    ../stylesheets/$(LINGUA)/fo.xsl \
	    fop1.extensions=1

	(cd book && ../../tools/fop/fop.sh svnbook.fo ../build/pdf/svnbook.pdf)
