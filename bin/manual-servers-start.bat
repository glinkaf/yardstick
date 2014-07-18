::    Licensed under the Apache License, Version 2.0 (the "License");
::    you may not use this file except in compliance with the License.
::    You may obtain a copy of the License at
::
::        http://www.apache.org/licenses/LICENSE-2.0
::
::    Unless required by applicable law or agreed to in writing, software
::    distributed under the License is distributed on an "AS IS" BASIS,
::    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::    See the License for the specific language governing permissions and
::    limitations under the License.

::
:: Script that starts BenchmarkServer on local machines.
:: This script expects first argument to be a path to run properties file.
:: Second argument is optional and defines number of starting nodes.
::

@echo off

:: Define script directory.
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

set CONFIG_INCLUDE=%1

if "%2"=="" (
    set SERVER_NODES=1
) else (
    set SERVER_NODES=%2
)

setlocal

set or=false
if "%CONFIG_INCLUDE%"=="-h" set or=true
if "%CONFIG_INCLUDE%"=="--help" set or=true

if "%or%"=="true" (
    echo Usage: manual-servers-start.bat [PROPERTIES_FILE_PATH]
    echo Script that starts BenchmarkServer on local machines.

    exit /b
)

endlocal

if not exist "%CONFIG_INCLUDE%" (
    echo ERROR: Properties file is not found.
    echo Type \"--help\" for usage.
    exit /b
)

shift

set CONFIG_TMP=tmp.%RANDOM%.bat

echo off > %CONFIG_TMP%

type %CONFIG_INCLUDE% >> %CONFIG_TMP%

call "%CONFIG_TMP%" > nul 2>&1

del %CONFIG_TMP%

if not defined CONFIG (
    for /f "tokens=1 delims=," %%a in ("%CONFIGS%") do (
        set CONFIG=%%a
    )
)

if not defined CONFIG (
    echo ERROR: Configurations ^(CONFIGS^) are not defined in properties file.
    echo Type \"--help\" for usage.
    exit /b
)

:: Define logs directory.
set LOGS_BASE=logs-%time:~0,2%%time:~3,2%%time:~6,2%

set LOGS_DIR=%SCRIPT_DIR%\..\%LOGS_BASE%\logs_servers

if not exist "%LOGS_DIR%" (
    mkdir %LOGS_DIR%
)

:: JVM options.
set JVM_OPTS=%JVM_OPTS% -Dyardstick.server

set CUR_DIR=%cd%

setlocal enabledelayedexpansion

for /L %%i IN (1,1,%SERVER_NODES%) DO (
    echo %%i
    set file_log=%LOGS_DIR%\%%i_server.log

    echo ^<%time:~0,2%:%time:~3,2%:%time:~6,2%^>^<yardstick^> Starting server config '%CONFIG%'
    echo ^<%time:~0,2%:%time:~3,2%:%time:~6,2%^>^<yardstick^> Log file: !file_log!

    start /min /low cmd /c ^
        "set MAIN_CLASS=org.yardstickframework.BenchmarkServerStartUp && set JVM_OPTS=%JVM_OPTS% && set CP=%CP% && set CUR_DIR=%CUR_DIR% && %SCRIPT_DIR%\benchmark-bootstrap.bat %CONFIG% --config %CONFIG_INCLUDE% ^>^> !file_log! 2^>^&1"
)
