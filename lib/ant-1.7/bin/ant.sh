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

[ -z "$ANT_HOME" ] && ANT_HOME=`dirname $0`/..
if [ ! -e "$ANT_HOME/lib/ant.jar" ]
then
    echo The ANT_HOME environment variable is not defined correctly
    exit 1
fi

echo "ANT_HOME: $ANT_HOME"

$JAVACMD -Xmx1024m -cp $ANT_HOME/lib/ant-launcher.jar -Dant.home=$ANT_HOME \
    org.apache.tools.ant.launch.Launcher -lib $ANT_HOME/lib "$@"
