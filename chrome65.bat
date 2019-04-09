@echo off
setlocal
setlocal enabledelayedexpansion
rem Ищем путь до хрома
for /f "usebackq tokens=3*" %%a in (`reg query "HKLM\software\microsoft\Windows\CurrentVersion\App Paths\chrome.exe" /s`) do (
  if defined %%a do (
		if defined %%b do (
			set _chrome_path=%%a %%b\chrome.exe
		)
	)
  )
if not defined _chrome_path ( 
echo %date% %time% - cannot fined path to chrome on %computername%
goto :INST_Chrome65
)
set _chrome_path=!_chrome_path:\=\\!
rem опеределяем установленную версию хрома
for /F "tokens=2 delims==." %%I IN (
	'wmic datafile where "name='%_chrome_path%'" get version /format:list'
	) DO SET "version=%%I"
if not defined version (
echo %date% %time% - unable to check Chrome version on %computername%, installing... 
goto :INST_Chrome65
)
rem если версия ниже, чем нужна нам, устанавливаем новую версию
if %version% LSS 65 (
echo %date% %time% - current Chrome version is %version% on %computername% 
goto :INST_Chrome65
)

if %version% GEQ 65 (
echo chrome version is actual
echo %date% %time% - chrome version is actual for %username% on %computername% 
goto :EXIT
)

:INST_Chrome65
echo %date% %time% - chrome is installing for %username% on %computername% 

rem проверяем разрядность операционной системы и ставим нужную версию хрома
Set OS=64
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64

If %OS%==64 (
	msiexec /i "chrom64(65).msi" /quiet /norestart
	goto :exit
)

 msiexec /i "chrom32(65).msi" /quiet /norestart


:exit
endlocal
exit