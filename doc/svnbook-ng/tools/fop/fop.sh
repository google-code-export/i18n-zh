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

# add fop.jar, fop-sandbox and fop-hyph.jar, which reside in $FOP_HOME/build
LOCALCLASSPATH=$FOP_HOME/build/fop.jar

# add in the dependency .jar files, which reside in $FOP_HOME/lib
for i in ${FOP_HOME}/lib/*.jar; do
  LOCALCLASSPATH="$i":$LOCALCLASSPATH
done

LOGCHOICE=-Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog
LOGLEVEL=-Dorg.apache.commons.logging.simplelog.defaultlog=WARN

$JAVACMD -Xmx1024m $LOGCHOICE $LOGLEVEL -classpath $LOCALCLASSPATH \
    org.apache.fop.cli.Main -c $FOP_HOME/conf/userconfig.xml $@
