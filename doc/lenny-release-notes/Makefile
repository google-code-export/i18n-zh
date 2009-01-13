#
# Makefile for the release notes, top-level
#

# comment out this line when the release notes should go into
# production mode
DRAFT := 1

# TODO: Once #477458 is fixed in stable remove all committed sgml files
# which are generated from a PO file (was a workaround for old po4a).

manual := release-notes

arches := $(shell grep '<phrase arch=' $(CURDIR)/$(manual).ent \
		| sed 's/.* arch=.\([a-z0-9]*\).*/\1/' | sort -u)

ifeq "$(OFFICIALWEBBUILD)" "true"
  install_file	:= install -m 2664 -p
  makedir	:= mkdir -p -m 2775
else
  install_file	:= cp -r 
  makedir	:= mkdir -p -m 0755
endif

LANGUAGES := en ca cs de es fi fr it ja pl pt_BR pt ro ru sv zh_TW
# languages w/o .po files
# (either original English or translators don't like .po)
DBK_LANGUAGES := en ca cs pt_BR
XMLROFF_LANGS=cs ja pl ro ru vi zh_CN zh_TW
DISABLED_PDF=zh_TW
# cairo backend of xmlroff 0.6.0 crashes on some languages (#492597)
GPLIST=zh_TW

LANGUAGES-publish := $(addsuffix -publish,$(LANGUAGES))
LANGUAGES-clean := $(addsuffix -clean,$(LANGUAGES))

SOURCES := $(wildcard en/*.dbk)

# DocBook stuff
XP=xsltproc --nonet --novalid --xinclude
XL=xmllint --nonet --noout --postvalid --xinclude
# XSL files and parameters
# note: the URL is used as identifier, no HTTP is used!
DOCBOOK_XSL=http://docbook.sourceforge.net/release/xsl/current
# for HTML output
DBK2HTML=$(CURDIR)/html.xsl
# all in one file for text output
DBK2HTML1=$(CURDIR)/txt.xsl
DBLATEX=dblatex --style=db2latex
PROFILE=$(DOCBOOK_XSL)/profiling/profile.xsl
XMLROFF=xmlroff --backend cairo
XMLROFF_GP=xmlroff --backend gp

FORMATS=html txt pdf ps

ifeq "$(DRAFT)" "1"
    draftmode := yes
else
    draftmode := maybe
endif

# po4a stuff
# The etch version of po4a does not have the --previous option
#UPDATEPO=PERLLIB=lib/ po4a-updatepo --previous --format docbook
UPDATEPO=PERLLIB=lib/ po4a-updatepo --format docbook
# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=PERLLIB=lib/ po4a-translate --format docbook --keep 0

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES) $(LANGUAGES-publish)

all:
	for l in $(LANGUAGES); do \
	    for a in $(arches); do \
		$(MAKE) LINGUA=$$l architecture=$$a $(FORMATS); \
	    done; \
	done

help:
	@echo make html LINGUA=zh_CN architecture=i386
	@echo make pdf LINGUA=zh_CN architecture=i386
	@echo make txt LINGUA=zh_CN architecture=i386
	@echo "make stat # output stat information for zh_CN"
	@echo "make tidypo # clean .po files"

stat:
	@(cd zh_CN; for f in *.po; do printf "%s\t" $$f; msgfmt --statistics -c $$f; done)

$(LANGUAGES):
ifeq "$(architecture)" ""
	@echo "architecture variable must be set, try one of: $(arches)"
	exit 1
else
	-$(MAKE) LINGUA=$@ architecture=$$a $(FORMATS)
endif

publish:
	set -ex; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) $(PUBLISHDIR)/$$arch/$(manual); \
	  $(makedir) $(manual)-$$arch; \
	  for lang in $(LANGUAGES); do \
	    $(makedir) $(manual)-$$arch/$$lang; \
	    $(install_file) $$lang/$(manual).$$arch.html/*.html \
		$(PUBLISHDIR)/$$arch/$(manual)/; \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.txt; \
	    $(install_file) $$lang/$(manual).$$arch.pdf \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.pdf; \
	    $(install_file) $$lang/$(manual).$$arch.ps \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.ps; \
	    $(install_file) $$lang/$(manual).$$arch.html/*.html \
		$(manual)-$$arch/$$lang/; \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(manual)-$$arch/$$lang/$(manual).$$lang.txt; \
	    $(install_file) $$lang/$(manual).$$arch.pdf \
		$(manual)-$$arch/$$lang/$(manual).$$lang.pdf ; \
	    $(install_file) $$lang/$(manual).$$arch.ps \
		$(manual)-$$arch/$$lang/$(manual).$$lang.ps ; \
	  done; \
	  for i in $(PUBLISHDIR)/$$arch/$(manual)/*.en.html; do \
	    ln -sf `basename $$i` $${i%.en.html}.html; \
	  done; \
	  if [ -n "$(PUBLISHTARBALL)" ]; then (cd $(manual)-$$arch \
		&& tar czf $(PUBLISHDIR)/$(manual)-$$arch.tar.gz *); fi \
	done

ifeq "$(architecture)" ""
$(FORMATS)::
	@echo "architecture variable must be set, try one of: $(arches)"
	exit 1
endif

ifdef LINGUA
html::	$(LINGUA)/$(manual).$(architecture).html/index.html
$(LINGUA)/$(manual).$(architecture).html/index.html: \
		$(LINGUA)/$(manual).$(architecture).xml html.xsl
	mkdir -p $(LINGUA)/$(manual).$(architecture).html/images
	cp debian.css $(LINGUA)/$(manual).$(architecture).html
	cp /usr/share/xml/docbook/stylesheet/nwalsh/images/*.png \
	    $(LINGUA)/$(manual).$(architecture).html/images
	cd $(LINGUA) && $(XP) -o $(manual).$(architecture).html/ \
	    --stringparam html.ext .$(LINGUA).html \
	    --stringparam draft.mode $(draftmode) \
	    $(DBK2HTML) $(manual).$(architecture).xml

pdf::	$(LINGUA)/$(manual).$(architecture).pdf
ps::	$(LINGUA)/$(manual).$(architecture).ps
ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
$(LINGUA)/$(manual).$(architecture).pdf: \
		$(LINGUA)/$(manual).$(architecture).fo
$(LINGUA)/$(manual).$(architecture).ps: \
		$(LINGUA)/$(manual).$(architecture).fo
$(LINGUA)/$(manual).$(architecture).fo: \
		$(LINGUA)/$(manual).$(architecture).xml fo.xsl
else
$(LINGUA)/$(manual).$(architecture).pdf: \
		$(LINGUA)/$(manual).$(architecture).xml
$(LINGUA)/$(manual).$(architecture).ps: \
		$(LINGUA)/$(manual).$(architecture).xml
endif

ifneq "$(filter $(DISABLED_PDF),$(LINGUA))" ""
%.pdf: %.xml
	echo "PDF for $$LINGUA currently disabled." > $@
else
ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
%.fo: %.xml
	$(XP) -o $@ --stringparam draft.mode $(draftmode) fo.xsl $<

%.pdf: %.fo
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) -o $@ $<; \
	else \
	    $(XMLROFF) -o $@ $<; \
	fi
else
%.pdf: %.xml
	[ -f $(@D)/ifxetex.sty ] || cp ifxetex.sty $(@D)/
	$(DBLATEX) --output=$@ --param=draft.mode=$(draftmode) $<
endif
endif

ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
# Can't we just drop PS in favour of PDF?
%.ps: %.fo
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) --format postscript -o $@ $<; \
	else \
	    $(XMLROFF) --format postscript -o $@ $<; \
	fi
else
%.ps: %.xml
	[ -f $(@D)/ifxetex.sty ] || cp ifxetex.sty $(@D)/
	$(DBLATEX) --output=$@ --ps --param=draft.mode=$(draftmode) $<
endif

txt::	$(LINGUA)/$(manual).$(architecture).txt
$(LINGUA)/$(manual).$(architecture).txt: \
		$(LINGUA)/$(manual).$(architecture).xml txt.xsl
	$(XP) --stringparam draft.mode $(draftmode) $(DBK2HTML1) $< \
	    | w3m -cols 70 -dump -no-graph -T text/html > $@

# profiling for architecture, needed by all output formats
condition := ;
ifeq "$(DRAFT)" "1"
    condition := fixme
endif
space := $(undef) $(undef)
semic := $(undef);$(undef)
otherarchs := $(subst  $(space),$(semic), \
	$(addprefix not-,$(filter-out $(architecture),$(arches))))
ifneq "$(filter $(architecture),i386 amd64 powerpc)" ""
    condition := $(condition);g-i
endif

ifneq "$(filter $(architecture),mips mipsel)" ""
    initrd := $(condition);no-initrd
else
    initrd := $(condition);uses-initrd
endif

$(LINGUA)/$(manual).$(architecture).xml: \
		$(patsubst en/%,$(LINGUA)/%,$(SOURCES))
	$(XP) --stringparam profile.arch "$(architecture)$(otherarchs)" \
	      --stringparam profile.condition "$(condition)" \
	    $(PROFILE) $(@D)/$(manual).dbk > $@
endif

# There must be an easier way than recursive make!
.PRECIOUS:		%.dbk %.ent
ifndef LINGUA
%.dbk %.ent: FORCE
	$(MAKE) $@ LINGUA=`basename $(@D)`

FORCE:
else
ifneq "$(LINGUA)" "en"
$(LINGUA)/%.dbk:	en/%.dbk $(LINGUA)/%.po
	echo " $(DBK_LANGUAGES) " | grep -q " $$LINGUA " || \
	$(TRANSLATE) --master $< --po $(@:.dbk=.po) --localized $@
endif
endif

ifdef LINGUA
.PHONY:	updatepo
updatepo:	$(patsubst en/%.dbk,$(LINGUA)/%.po,$(wildcard en/*.dbk))
$(LINGUA)/%.po:		en/%.dbk
	echo " $(DBK_LANGUAGES) " | grep -q " $$LINGUA " || \
	$(UPDATEPO) --master $< --po $@

validate:	$(patsubst en/%,$(LINGUA)/%,$(SOURCES))
	$(XL) $(LINGUA)/$(manual).dbk
endif

tidypo:
ifdef LINGUA
	for po in $(wildcard $(LINGUA)/*.po); do \
	    msgcat -w 80 $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
else
	for po in $(wildcard */*.po); do \
	    msgcat -w 80 $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
endif

ifndef LINGUA
%:
	for l in $(LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
endif

clean::
	rm -f relnotes.tar.bz2
	find -maxdepth 1 -name '$(manual)-*' -type d -exec rm -fr {} \;
clean:: $(LANGUAGES-clean)

$(LANGUAGES-clean):
	cd $(subst -clean,,$@); \
	rm -rf *~ .*~ $(manual).*.html $(manual).*.txt $(manual).*.pdf \
	    $(manual).*.ps $(manual).*.xml ifxetex.sty body.tmp head.tmp \
	    release-notes.*.tpt

printarches:
	@echo $(arches)
