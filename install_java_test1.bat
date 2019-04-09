@echo off
set installedVersion=180144
setlocal
setlocal enabledelayedexpansion
rem Путь до актуальной версии Java
set jPath=\Java\jre1.8.0_144\bin\java.exe

rem Определяем установленную версию Java
PATH %PATH%;%JAVA_HOME%\bin\
set jver=
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
echo %jver%| findstr /r "[^0-9]" > nul
if errorlevel 1 goto :checkVersion 


set javaPath=C:\Program Files%jPath%
set jver=
for /f tokens^=2-5^ delims^=.-_^" %%j in ('"%javaPath%" -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
echo %jver%| findstr /r "[^0-9]" > nul
if errorlevel 1 goto :checkVersion 


set javaPath=C:\Program Files (x86)%jPath%
set jver=
for /f tokens^=2-5^ delims^=.-_^" %%j in ('"%javaPath%" -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
echo %jver%| findstr /r "[^0-9]" > nul
if errorlevel 1 goto :checkVersion


echo %date% %time% - cannot check java version. Installing actual version... on %computername%
goto :JavaInstall

:checkVersion
rem Если версия ниже чем та, которая нам нужна - устанавливаем новую версию
if %jver% LSS %installedVersion% (
echo version is slower. Current version is %jver%. 
echo Installing new Java version...
goto :JavaInstall
)

echo JavaVersion is actual. Copying config files...
echo %date% %time% - java version is actual for %username% on %computername% 
goto :CopyConfigs



:JavaInstall

msiexec.exe /i "jre-8u144-windows-i586.msi" /qn /norestart


:copyConfigs
set jPath=C:\program files (x86)\java\jre1.8.0_144
rem определяем, куда установлена Java
dir /A /B "C:\program files\java\jre1.8.0_144\bin\" | findstr /R ".">NUL && set jPath=C:\program files\java\jre1.8.0_144
dir /A /B "C:\program files (x86)\java\jre1.8.0_144\bin\" | findstr /R ".">NUL && set jPath=C:\program files (x86)\java\jre1.8.0_144
echo java install path %jPath%
mkdir c:\Windows\Sun\Java\Deployment
mkdir c:\Windows\java

rem копируем конфиги Java
copy "%~dp0cacerts" "%jpath%\lib\security\" /y 
copy "%~dp0DeploymentRuleSet.jar" "c:\windows\sun\java\deployment\" /y 
copy "%~dp0deployment.properties" "c:\windows\sun\java\deployment\" /y 
copy "%~dp0deployment.config" "c:\windows\sun\java\deployment\" /y 
copy "%~dp0exception.sites" "c:\windows\sun\java\deployment\" /y 
:EXIT
echo exiting script
exit