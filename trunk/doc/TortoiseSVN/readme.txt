Description:
    xsl/ .......................... xsl & css files.
    po/ ........................... pot & po files
    xml2po.py & xml2po-modes ...... xml2po -- translate XML documents
    build.xml ..................... build file.
    build.properties .............. build configuration file.

Before Commit:
    msgmerge --width=80 -o TortoiseSVN-zh_CN_new.po TortoiseSVN-zh_CN.po TortoiseSVN.pot
    mv -f TortoiseSVN-zh_CN_new.po TortoiseSVN-zh_CN.po
    msgfmt --statistics -c TortoiseSVN-zh_CN.po

Aim:
    Since the official pdf output broken for simplified chinese, we tried
    to fix it.

Status:

2007-05-15 Saimei Su <saimei.su@gmail.com>
    * init directory structure
    * import TortoiseSVN_zh_CN.po@r9363
