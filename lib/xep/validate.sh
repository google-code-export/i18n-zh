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

# [ -z "$XEP_HOME" ] && XEP_HOME=`dirname $0`
if [ -z "$XEP_HOME" -o ! -d "$XEP_HOME" ] ; then
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

  XEP_HOME=`dirname "$PRG"`

  # make it fully qualified
  XEP_HOME=`cd "$XEP_HOME" > /dev/null && pwd`
fi

if [ ! -e "$XEP_HOME/lib/xep.jar" ]
then
    echo "Error: The XEP_HOME environment variable is not defined correctly"
    exit 1
fi

echo "XEP_HOME: $XEP_HOME"

$JAVACMD -Xmx1024m \
    -cp $XEP_HOME/lib/xep.jar:$XEP_HOME/lib/saxon.jar:$XEP_HOME/lib/xt.jar  \
    "-Dcom.renderx.xep.CONFIG=$XEP_HOME/xep.xml" com.renderx.xep.Validator "$@"
