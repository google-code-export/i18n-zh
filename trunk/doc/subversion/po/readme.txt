msgmerge --no-wrap -F -o zh.po.new zh.po book.pot
diff zh.po.new zh.po
mv zh.po.new zh.po

