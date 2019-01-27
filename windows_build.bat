@echo off

REM Because of paths becoming too long in Windows/Python, we clone the webrtc code in c:\wc
set "cloneDir=c:\wc"
set "batchDir=%~dp0%"

REM H264 support can only be compiled with clang, not MSVC. 
REM Downside is source debugging in Visual Studio is not yet suported when using clang :(
set "h264=0"

set DEPOT_TOOLS_WIN_TOOLCHAIN=0

echo This script assumes you have installed the Google depot_tools, see https://webrtc.org/native-code/development

REM goto :rev

echo ----------------------------------------------------------------

if not exist %cloneDir% (
    mkdir %cloneDir%
    if errorlevel 1 goto :error

    cd /d %cloneDir%
    if errorlevel 1 goto :error

    echo Fetching webrtc source code...
    call fetch --nohooks webrtc
    if errorlevel 1 goto :error
) else (
    echo Updating webrtc source code...

    cd /d %cloneDir%
    if errorlevel 1 goto :error

    pushd src
    if errorlevel 1 goto :error

    git checkout master
    if errorlevel 1 goto :error

    git pull origin master
    if errorlevel 1 goto :error
    popd
)

echo ----------------------------------------------------------------

:sync

cd /d %cloneDir%
if errorlevel 1 goto :error

echo Synching webrtc source code...
call gclient sync -f
if errorlevel 1 goto :error
 
echo ----------------------------------------------------------------

:rev

cd /d %cloneDir%\src
if errorlevel 1 goto :error

git >%batchDir%\webrtc_revision.txt rev-parse HEAD
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:gen

cd /d %cloneDir%
if errorlevel 1 goto :error

echo Generating debug build script, H264=%h264%...

if %h264%==1 (
    call gn gen windows_clang_debug_x64 --root="src" --args="target_cpu=\"x64\" is_debug=true use_rtti=true rtc_include_tests=false  symbol_level=0 proprietary_codecs=true use_openh264=true ffmpeg_branding=\"Chrome\""
) else (
    call gn gen windows_msvc_debug_x64 --root="src" --args="target_cpu=\"x64\" is_debug=true use_rtti=true rtc_include_tests=false  symbol_level=2 is_clang=false"
)
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

cd /d %cloneDir%
if errorlevel 1 goto :error

echo Generating release build script, H264=%h264%...
if %h264%==1 (
    call gn gen windows_clang_release_x64 --root="src" --args="target_cpu=\"x64\" is_debug=false use_rtti=true rtc_include_tests=false  symbol_level=0 proprietary_codecs=true use_openh264=true ffmpeg_branding=\"Chrome\""
) else (
    call gn gen windows_msvc_release_x64 --root="src" --args="target_cpu=\"x64\" is_debug=false use_rtti=true rtc_include_tests=false  symbol_level=0 is_clang=false"
)
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:build

cd /d %cloneDir%
if errorlevel 1 goto :error

echo Building debug libraries, H264=%h264%......
if %h264%==1 (
    ninja -C windows_clang_debug_x64
) else (
    ninja -C windows_msvc_debug_x64
)
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

echo Building release libraries...

if %h264%==1 (
    ninja -C windows_clang_release_x64
) else (
    ninja -C windows_msvc_release_x64
)
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:copy

echo Copying API...
cd /d %cloneDir%
call %batchDir%\copy_webrtc_API.bat %cloneDir% %h264%
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
cd /d %cloneDir%
pause
color


