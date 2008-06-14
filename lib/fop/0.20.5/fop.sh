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

$JAVACMD -Xmx1024m -classpath \"$LOCALCLASSPATH\" org.apache.fop.apps.Fop "$@"
