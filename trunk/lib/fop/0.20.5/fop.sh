#!/bin/sh

[ -z "$JAVA_HOME" ] && JAVA_HOME=`which java;`/..
if [ ! -e "$JAVA_HOME/lib/tools.jar" ]
then
    echo The JAVA_HOME environment variable is not defined correctly
    exit 1
fi

[ -z "$FOP_HOME" ] && FOP_HOME=`dirname $0`
if [ ! -e "$FOP_HOME/lib/batik.jar" ]
then
    echo The FOP_HOME environment variable is not defined correctly
    exit 1
fi

for i in ${FOP_HOME}/lib/*.jar
do
    if [ -z "$LOCALCLASSPATH" ] ; then
        LOCALCLASSPATH=$i
    else
        LOCALCLASSPATH="$i":$LOCALCLASSPATH
    fi
done

$JAVA_HOME/bin/java -Xmx512m -classpath \"$LOCALCLASSPATH\" org.apache.fop.apps.Fop "$@"
