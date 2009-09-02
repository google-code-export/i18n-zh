rem @echo off
rem   This batch file encapsulates a standard XEP call.

if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
if "%JAVACMD%" == "" set JAVACMD=%JAVA_HOME%\bin\java
goto runXep

:noJavaHome
if "%JAVACMD%" == "" set JAVACMD=java

:runXep
@set XEP_HOME=%~dp0..\xep

set CP=%XEP_HOME%\lib\empty-stamp.jar;%XEP_HOME%\lib\xep.jar;%XEP_HOME%\lib\saxon.jar;%XEP_HOME%\lib\xt.jar

if x%OS%==xWindows_NT goto WINNT
"%JAVACMD%" -Xmx1024m -classpath "%CP%" com.renderx.xep.XSLDriver "-DCONFIG=%XEP_HOME%\xep.xml" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:WINNT
"%JAVACMD%" -Xmx1024m -classpath "%CP%" com.renderx.xep.XSLDriver "-DCONFIG=%XEP_HOME%\xep.xml" %*

:END
set CP=
