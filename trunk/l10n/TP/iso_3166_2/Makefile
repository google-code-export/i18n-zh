all: diff.dat

diff.dat: 1.5.dat 3.1.dat
	diff -u $^ > $@

1.5.dat: iso_3166_2-1.5.zh_CN.po po2translated.py
	python po2translated.py iso_3166_2-1.5.zh_CN.po | sort > $@

3.1.dat: iso_3166_2-3.1.zh_CN.po po2translated.py
	python po2translated.py iso_3166_2-3.1.zh_CN.po | sort > $@
