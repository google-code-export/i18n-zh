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

# JAVACMD=`which java 2> /dev/null`
# if [ ! -x "AIX 5.3 no java in /bin /usr/bin" ] ; then
#   echo "Error: JAVA_HOME or PATH is not defined correctly."
#   echo "  We cannot execute java"
#   exit 1
# fi

# if [ -z "$JAVACMD" ] ; then
#   if [ -n "$JAVA_HOME" ] ; then
#     JAVACMD="$JAVA_HOME/bin/java"
#   else
#     JAVACMD=`which java 2> /dev/null`
#   fi
# fi
#
# if [ ! -x "$JAVACMD" ] ; then
#   echo "Error: JAVA_HOME is not defined correctly."
#   echo "  We cannot execute java"
#   exit 1
# fi

[ -z "$FOP_HOME" ] && FOP_HOME=`dirname $0`

if [ -z "$FOP_HOME" -o ! -d "$FOP_HOME" ] ; then
  ## resolve links - $0 may be a link to fop's home
  PRG="$0"
  progname=`basename "$0"`

  # need this for relative symlinks
  while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      PRG="$link"
    else
      PRG=`dirname "$PRG"`"/$link"
    fi
  done

  FOP_HOME=`dirname "$PRG"`

  # make it fully qualified
  FOP_HOME=`cd "$FOP_HOME" && pwd`
fi

# add fop.jar, fop-sandbox and fop-hyph.jar, which reside in $FOP_HOME/build
LOCALCLASSPATH=$FOP_HOME/build/fop.jar:$FOP_HOME/build/fop-hyph.jar:$FOP_HOME/build/fop-sandbox.jar

# add in the dependency .jar files, which reside in $FOP_HOME/lib
for i in ${FOP_HOME}/lib/*.jar; do
  LOCALCLASSPATH="$i":$LOCALCLASSPATH
done

LOGCHOICE=-Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog
LOGLEVEL=-Dorg.apache.commons.logging.simplelog.defaultlog=WARN

$JAVACMD -Xmx1024m $LOGCHOICE $LOGLEVEL -classpath $LOCALCLASSPATH org.apache.fop.cli.Main $@
