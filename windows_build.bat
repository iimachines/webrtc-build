@echo off

set "currentDirectory=%cd%"
set "batchDirectory=%~dp0%"

echo This script assumes you have installed the Google depot_tools, see https://webrtc.org/native-code/development

echo ----------------------------------------------------------------

if not exist webrtc-checkout (
    mkdir webrtc-checkout
    if errorlevel 1 goto :error

    cd webrtc-checkout
    if errorlevel 1 goto :error

    echo Fetching webrtc source code...
    call fetch --nohooks webrtc
    if errorlevel 1 goto :error
) else (
    cd webrtc-checkout
    if errorlevel 1 goto :error
)

echo ----------------------------------------------------------------

:update

echo Updating webrtc source code...

pushd src
if errorlevel 1 goto :error

git checkout master
if errorlevel 1 goto :error

git pull origin master
if errorlevel 1 goto :error

call gclient sync
if errorlevel 1 goto :error
popd

echo ----------------------------------------------------------------

:gen

echo Generating debug build script...
call gn gen windows_debug_x64 --root="src" --args="is_debug=true rtc_include_tests=false target_cpu=\"x64\" symbol_level=2 is_clang=false"
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

echo Generating release build script...
call gn gen windows_release_x64 --root="src" --args="is_debug=false rtc_include_tests=false target_cpu=\"x64\" symbol_level=0 is_clang=false"
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:build

echo Building debug libraries...
ninja -C windows_debug_x64
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

echo Building release libraries...
ninja -C windows_release_x64
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:copy

echo Copying API...
cd %currentDirectory%
call %batchDirectory%\copy_webrtc_API.bat
if errorlevel 1 goto :error

:done
color 2F
echo ************************** SUCCES :) ***************************
goto :exit

:error
color 4E
echo ************************** FAILURE :( **************************
goto :exit

:exit
cd %currentDirectory%
pause
color


