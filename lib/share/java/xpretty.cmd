@echo off
@rem Invokes pretty printer

@set XMLBEANS_LIB=%~dp0
@set cp=%XMLBEANS_LIB%xbean.jar;%XMLBEANS_LIB%jsr173_1.0_api.jar

java -classpath "%cp%" org.apache.xmlbeans.impl.tool.PrettyPrinter %*
