#!/bin/sh

if [ -z "$JAVACMD" ]; then
    if [ ! -z "$JAVA_HOME" ]; then
        if [ ! -e "$JAVA_HOME/bin/java" ]; then
            JAVACMD=java
        else
            JAVACMD=$JAVA_HOME/bin/java
        fi
    else
        JAVACMD=java
    fi
fi

echo "JAVACMD: $JAVACMD"

[ -z "$XEP_HOME" ] && XEP_HOME=`dirname $0`
if [ ! -e "$XEP_HOME/lib/xep.jar" ]
then
    echo The XEP_HOME environment variable is not defined correctly
    exit 1
fi

$JAVACMD -Xmx1024m "-DCONFIG=%XEP_HOME%/xep.xml" \
    -cp $XEP_HOME/lib/xep.jar:$XEP_HOME/lib/saxon.jar:$XEP_HOME/lib/xt.jar  \
    org.apache.tools.XEP.launch.Launcher -lib $XEP_HOME/lib "$@"
