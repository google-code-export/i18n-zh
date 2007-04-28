@set FOP_HOME=%~dp0

@if exist "%JAVA_HOME%\lib\tools.jar" goto okJH
@echo The JAVA_HOME environment variable is not defined correctly
@goto end

:okJH

@if exist "%FOP_HOME%\lib\batik.jar" goto okAH
@echo The FOP_HOME environment variable is not defined correctly
@goto end

:okAH

for %%l in (%FOP_HOME%\lib\*.jar) do set LOCALCLASSPATH=!LOCALCLASSPATH!;%%l

@"%JAVA_HOME%\bin\java.exe" -Xmx512m -cp "%LOCALCLASSPATH%" org.apache.fop.apps.Fop %*

:end
