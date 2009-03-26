if which ant > /dev/null; then
	ANT=ant
else
	ANT="../../../lib/ant-1.7/bin/ant.sh"
fi

$ANT -f build.xml "$@"
