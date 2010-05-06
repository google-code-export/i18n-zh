@ECHO OFF

set LOCAL_FOP_HOME=%~dp0
set LIBDIR=%LOCAL_FOP_HOME%lib

set LOGCHOICE=-Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog
set LOGLEVEL=-Dorg.apache.commons.logging.simplelog.defaultlog=WARN

set LOCALCLASSPATH=%LOCAL_FOP_HOME%build\fop.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LOCAL_FOP_HOME%build\fop-sandbox.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LOCAL_FOP_HOME%build\fop-hyph.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\avalon-framework-4.2.0.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\batik-all-1.7.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\commons-io-1.3.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\commons-logging-1.1.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\serializer-2.7.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xalan-2.7.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xalan-dbxsl.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xercesImpl-2.9.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xml-apis-1.3.04.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xml-apis-ext-1.3.04.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xml-commons-resolver-1.2.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\xmlgraphics-commons-1.4svn.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%FOP_HYPHENATION_PATH%

if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
if "%JAVACMD%" == "" set JAVACMD=%JAVA_HOME%\bin\java
goto runFop

:noJavaHome
if "%JAVACMD%" == "" set JAVACMD=java

:runFop
"%JAVACMD%" -Xmx1024m %LOGCHOICE% %LOGLEVEL% -cp "%LOCALCLASSPATH%" org.apache.fop.cli.Main -c %LOCAL_FOP_HOME%conf\userconfig.xml %*
