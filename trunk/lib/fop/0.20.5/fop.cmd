@ECHO OFF

if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
if "%JAVACMD%" == "" set JAVACMD=%JAVA_HOME%\bin\java
goto runFop

:noJavaHome
if "%JAVACMD%" == "" set JAVACMD=java

:runFop

set LOCAL_FOP_HOME=%~dp0
set LIBDIR=%LOCAL_FOP_HOME%lib

set LOCALCLASSPATH=%LIBDIR%\fop-0.20.5-RFC3066-patched.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\avalon-framework-cvs-20020806.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\batik.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\jai_core.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\jai_codec.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\rowan-0.1.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\saxon.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\saxoncatalog.jar
set LOCALCLASSPATH=%LOCALCLASSPATH%;%LIBDIR%\saxon-dbxsl-extensions.jar

"%JAVACMD%" -Xmx1024m -cp "%LOCALCLASSPATH%" org.apache.fop.apps.Fop %*
