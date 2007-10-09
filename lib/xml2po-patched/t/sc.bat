python xml2po.py -o sc.pot sc.xml

msgmerge --no-wrap -o sc-zh_CN_new.po sc-zh_CN.po sc.pot
mv -f sc-zh_CN_new.po sc-zh_CN.po

python xml2po.py -o sc-zh_CN.xml -p sc-zh_CN.po sc.xml
