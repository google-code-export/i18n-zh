@set ANT_HOME=%~dp0..

@if exist "%ANT_HOME%\lib\ant.jar" goto okAH
@echo The ANT_HOME environment variable is not defined correctly
@goto end

:okAH

@if exist "%JAVA_HOME%\lib\tools.jar" goto okJH
@echo The JAVA_HOME environment variable is not defined correctly
@goto end

:okJH

@"%JAVA_HOME%\bin\java.exe" -Xmx512m -cp %ANT_HOME%\lib\ant-launcher.jar "-Dant.home=%ANT_HOME%" org.apache.tools.ant.launch.Launcher -lib %ANT_HOME%\lib %*

:end
