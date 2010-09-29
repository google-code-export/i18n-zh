export CFLAGS='-march=core2 -mno-sse3 -mtune=generic -pipe -funroll-loops -ftree-vectorize -O3'
export CXXFLAGS=${CFLAGS}
export LDFLAGS='-s'
export PATH=/home/oracle/gcc-4.5-w32_i686-linux/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

signtool sign /t http://timestamp.verisign.com/scripts/timstamp.dll *.dll *.exe

1. libiconv 1.13.1
CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++ \
./configure --prefix=/home/oracle/tmp/w32 --host=i686-w64-mingw32 --with-libiconv-prefix=/home/oracle/tmp/w32 \
  --enable-relocatable  --disable-static --disable-nls

2. gettext 0.18.1.1
CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++ \
../gettext-0.18.1.1/configure --prefix=/home/oracle/tmp/w32 --host=i686-w64-mingw32 --with-libiconv-prefix=/home/oracle/tmp/w32 \
  --enable-relocatable --disable-static

vi gettext-0.18.1.1/gettext-tools/libgettextpo/Makefile

libgettextpo_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC \
        $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=link $(CCLD) \
        $(AM_CFLAGS) $(CFLAGS) $(libgettextpo_la_LDFLAGS) $(LDFLAGS) -lgrt \
        -o $@

3. libiconv 1.13.1
CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++ \
./configure --prefix=/home/oracle/tmp/w32 --host=i686-w64-mingw32 --with-libiconv-prefix=/home/oracle/tmp/w32 \
  --enable-relocatable  --disable-static
