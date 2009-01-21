#!/bin/sh
#
# Usage:
# ./po-update.sh
#   - to update all locales
# ./po-update.sh LL
#   - to update one the LL locale

set -e

MSGMERGE=${MSGMERGE:-msgmerge}

hg_base=
for i in . .. ../..; do
  if [ -d "$i/hg/i18n" ]; then
    hg_base="$i"
    break
  fi
done
if [ -z "$hg_base" ]; then
  echo "E: You must run po-update.sh from within a Mercurial source tree." >&2
  exit 1
fi

update_pot()
{
  cd $hg_base/hg && (
    pygettext -d doc -p i18n --docstrings \
    mercurial/commands.py hgext/*.py hgext/*/__init__.py
    pygettext -d all -p i18n mercurial hgext doc
    msgcat i18n/doc.pot i18n/all.pot > i18n/hg.pot

    rm i18n/doc.pot i18n/all.pot
  )
}

update_po()
{
  (cd $hg_base/hg/i18n &&
  for i in $1.po; do
    echo "Updating $i ..."
    msgmerge --width=80 --sort-by-file -o tmp.po $i hg.pot
    mv -f tmp.po $i
  done )
}

update_pot

if [ $# -eq 0 ]; then
  update_po \*
else
  langs=
  while [ $# -ge 1 ]; do
    case $1 in
      pot) ;;
      *)
      if [ -e $hg_base/hg/i18n/$1.po ]; then
        langs="$langs $1"
      else
        echo "E: No such .po file '$1.po'" >&2
        exit 1
      fi
    esac
    shift
  done
  for lang in $langs; do
    update_po $lang
  done
fi

cd $hg_base/hg/i18n && printf "\nTranslation statistics:\n"
for f in *.po; do
  printf "%s\t" $f; 
  msgfmt --statistics -c $f;
done
