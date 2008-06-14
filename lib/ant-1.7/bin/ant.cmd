@ECHO OFF

@set ANT_HOME=%~dp0..

if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
if "%JAVACMD%" == "" set JAVACMD=%JAVA_HOME%\bin\java
goto runAnt

:noJavaHome
if "%JAVACMD%" == "" set JAVACMD=java

:runAnt
@"%JAVACMD%" -Xmx1024m -cp %ANT_HOME%\lib\ant-launcher.jar "-Dant.home=%ANT_HOME%" org.apache.tools.ant.launch.Launcher -lib %ANT_HOME%\lib %*
