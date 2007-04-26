#!/bin/sh

[ -z "$JAVA_HOME" ] && JAVA_HOME=`which java;`/..
if [ ! -e "$JAVA_HOME/lib/tools.jar" ]
then
    echo The JAVA_HOME environment variable is not defined correctly
    exit 1
fi

[ -z "$ANT_HOME" ] && ANT_HOME=`dirname $0`/..
if [ ! -e "$ANT_HOME/lib/ant.jar" ]
then
    echo The ANT_HOME environment variable is not defined correctly
    exit 1
fi

echo "ANT_HOME: $ANT_HOME"

$JAVA_HOME/bin/java -Xmx512m -cp $ANT_HOME/lib/ant-launcher.jar -Dant.home=$ANT_HOME \
    org.apache.tools.ant.launch.Launcher -lib $ANT_HOME/lib "$@"
