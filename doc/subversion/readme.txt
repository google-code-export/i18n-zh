目前是直接翻译xml文件，很难同步，需要修改为使用xml2po方式。

xsltproc --nonet --xinclude --output en.xml xsl/profile.xsl src/en/book/book.xml

xsltproc --nonet --xinclude --output zh.xml xsl/profile.xsl src/zh/book/book.xml

python xml2po.py -e -o en.po en.xml

python xml2po.py -e -o zh.po zh.xml

python xml2po.py -t zh.mo -o zh.xml en.xml


for i in src/en/book/*.xml; do 
    echo $i;
    python xml2po.py -e -o $i.pot $i
done
