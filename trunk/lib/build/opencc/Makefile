#
# Test with gcc 4.5 for windows at http://code.google.com/p/i18n-zh/downloads/list
#

CC := gcc
CFLAGS := -O2 -s -flto -DBYTEORDER=LITTLE_ENDIAN

help:
	@echo Available targets:
	@echo   make build
	@echo   make check
	@echo   make release
	@echo   make all
	@echo   make clean

all: build check release

clean:
	if exist release rmdir /S /Q release
	del /Q opencc.dll opencc_dict.exe opencc.exe *.ocd 2>NUL

build: opencc.dll opencc_dict.exe opencc.exe simp_to_trad_characters.ocd simp_to_trad_phrases.ocd trad_to_simp_characters.ocd trad_to_simp_phrases.ocd

check: build check-zhs2zht check-zht2zhs check-mix2zht check-mix2zhs

release: build check
	if exist release rmdir /S /Q release
	mkdir release
	copy /Y ..\data\config\*.ini release
	copy /Y *.dll release
	copy /Y *.exe release
	copy /Y *.ocd release

opencc.dll: $(wildcard ../src/*.c) $(wildcard ../src/dictionary/*.c)
	$(CC) $(CFLAGS) -shared -o $@ -I. -L. -liconv-2 $?

opencc_dict.exe: opencc.dll ../src/tools/opencc_dict.c
	$(CC) $(CFLAGS) -o $@ -I. -L. -lopencc ../src/tools/opencc_dict.c

opencc.exe: opencc.dll ../src/tools/opencc.c
	$(CC) $(CFLAGS) -o $@ -I. -L. -lopencc ../src/tools/opencc.c

simp_to_trad_characters.ocd: opencc_dict.exe ../data/simp_to_trad/characters.txt
	opencc_dict.exe -i ../data/simp_to_trad/characters.txt -o simp_to_trad_characters.ocd

simp_to_trad_phrases.ocd:  opencc_dict.exe ../data/simp_to_trad/phrases.txt
	opencc_dict.exe -i ../data/simp_to_trad/phrases.txt -o simp_to_trad_phrases.ocd

trad_to_simp_characters.ocd: opencc_dict.exe ../data/trad_to_simp/characters.txt
	opencc_dict.exe -i ../data/trad_to_simp/characters.txt -o trad_to_simp_characters.ocd

trad_to_simp_phrases.ocd: opencc_dict.exe ../data/trad_to_simp/phrases.txt
	opencc_dict.exe -i ../data/trad_to_simp/phrases.txt -o trad_to_simp_phrases.ocd

check-zhs2zht: opencc.exe ../test/testcases/zhs2zht.in ../data/config/zhs2zht.ini
	opencc.exe -i ../test/testcases/zhs2zht.in -o zhs2zht.out -c ../data/config/zhs2zht.ini
	fc ..\test\testcases\zhs2zht.ans zhs2zht.out >NUL
	del /Q zhs2zht.out

check-zht2zhs: opencc.exe ../test/testcases/zht2zhs.in ../data/config/zht2zhs.ini
	opencc.exe -i ../test/testcases/zht2zhs.in -o zht2zhs.out -c ../data/config/zht2zhs.ini
	fc ..\test\testcases\zht2zhs.ans zht2zhs.out
	del /Q zht2zhs.out

check-mix2zht: opencc.exe ../test/testcases/mix2zht.in ../data/config/mix2zht.ini
	opencc.exe -i ../test/testcases/mix2zht.in -o mix2zht.out -c ../data/config/mix2zht.ini
	fc ..\test\testcases\mix2zht.ans mix2zht.out
	del /Q mix2zht.out

check-mix2zhs: opencc.exe ../test/testcases/mix2zhs.in ../data/config/mix2zhs.ini
	opencc.exe -i ../test/testcases/mix2zhs.in -o mix2zhs.out -c ../data/config/mix2zhs.ini
	fc ..\test\testcases\mix2zhs.ans mix2zhs.out
	del /Q mix2zhs.out

.PHONY: release
