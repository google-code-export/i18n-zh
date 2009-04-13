msgmerge --width=80 -o TortoiseSVN_zh_CN_new.po TortoiseSVN_zh_CN.po TortoiseSVN.pot
move /y TortoiseSVN_zh_CN_new.po TortoiseSVN_zh_CN.po

msgfmt --statistics -c TortoiseSVN_zh_CN.po

pause

