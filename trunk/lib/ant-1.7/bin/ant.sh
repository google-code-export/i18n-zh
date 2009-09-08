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
JAVACMD=`which $JAVACMD 2> /dev/null `

if [ ! -x "$JAVACMD" ] ; then
    echo "Error: JAVA_HOME is not defined correctly, we cannot execute $JAVACMD"
    exit 1
fi

# [ -z "$ANT_HOME" ] && ANT_HOME=`dirname $0`/..
if [ -z "$ANT_HOME" -o ! -d "$ANT_HOME" ] ; then
  ## resolve links - $0 may be a link to xep's home
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

  ANT_HOME=`dirname "$PRG"`

  # make it fully qualified
  ANT_HOME=`cd "$ANT_HOME/.." > /dev/null && pwd`
fi

if [ ! -e "$ANT_HOME/lib/ant.jar" ]
then
    echo The ANT_HOME environment variable is not defined correctly
    exit 1
fi

echo "ANT_HOME: $ANT_HOME"
$JAVACMD -Xmx1024m -cp $ANT_HOME/lib/ant-launcher.jar -Dant.home=$ANT_HOME \
    org.apache.tools.ant.launch.Launcher -lib $ANT_HOME/lib "$@"
