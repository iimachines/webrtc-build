@echo off

REM Because of paths becoming too long in Windows/Python, we clone the webrtc code in c:\wc
set "CLONE_DIR=c:\wc"
set "TOOLS_DIR=%localappdata%\WMP\depot_tools"
set "BATCH_DIR=%~dp0%"
set "OLD_PATH=%PATH%"
set "WEBRTC_BRANCH=m73"

REM H264 support can only be compiled with clang, not MSVC. 
REM Downside is source debugging in Visual Studio is not yet suported when using clang :(
set "h264=0"

set DEPOT_TOOLS_WIN_TOOLCHAIN=0

if not exist "%TOOLS_DIR%" (
    echo "Installing Google depot tools in %TOOLS_DIR%..."

    powershell "%BATCH_DIR%\install_depot_tools.ps1" -rootPath "%TOOLS_DIR%"
    if errorlevel 1 goto :error
) else (
    echo "Using Google depot tools at %TOOLS_DIR%"
)

set PATH="%TOOLS_DIR%";%OLD_PATH%

echo ----------------------------------------------------------------

if NOT "%1"=="" goto %1

if not exist %CLONE_DIR% (
    mkdir %CLONE_DIR%
    if errorlevel 1 goto :error
)

cd /d %CLONE_DIR%
if errorlevel 1 goto :error

if not exist %CLONE_DIR%\src (
    echo Fetching webrtc source code...
    call fetch --nohooks webrtc
    if errorlevel 1 goto :error
) 

echo ----------------------------------------------------------------

echo Updating webrtc source code...
cd /d %CLONE_DIR%\src
if errorlevel 1 goto :error

call git rev-parse 2>nul --verify branch_%WEBRTC_BRANCH%
if errorlevel 128 (
    echo Checking out %WEBRTC_BRANCH%...
    call git checkout -b branch_%WEBRTC_BRANCH% branch-heads/%WEBRTC_BRANCH%
    if errorlevel 1 goto :error
)

echo Checking out %WEBRTC_BRANCH%...
call git checkout branch_%WEBRTC_BRANCH%
if errorlevel 1 goto :error

echo Pulling latest changes...
call git pull origin branch-heads/%WEBRTC_BRANCH%
if errorlevel 1 goto :error
)

echo ----------------------------------------------------------------

:sync

cd /d %CLONE_DIR%
if errorlevel 1 goto :error

echo Synching webrtc source code...
call gclient sync --with_branch_heads -f 
if errorlevel 1 goto :error
 
echo ----------------------------------------------------------------

:rev

cd /d %CLONE_DIR%\src
if errorlevel 1 goto :error

call git >%BATCH_DIR%\webrtc_revision.txt rev-parse HEAD
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

:gen

cd /d %CLONE_DIR%
if errorlevel 1 goto :error

echo Generating debug build script, H264=%h264%...

if %h264%==1 (
    call gn gen windows_clang_debug_x64 --root="src" --args="target_cpu=\"x64\" is_debug=true use_rtti=true rtc_include_tests=false  symbol_level=0 proprietary_codecs=true use_openh264=true ffmpeg_branding=\"Chrome\""
) else (
    call gn gen windows_msvc_debug_x64 --root="src" --args="target_cpu=\"x64\" is_debug=true use_rtti=true rtc_include_tests=false  symbol_level=2 is_clang=false"
)
if errorlevel 1 goto :error

echo ----------------------------------------------------------------

cd /d %CLONE_DIR%
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

cd /d %CLONE_DIR%
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
cd /d %CLONE_DIR%
call %BATCH_DIR%\copy_webrtc_API.bat %CLONE_DIR% %h264%
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
set PATH=%OLD_PATH%
cd /d %BATCH_DIR%
pause
color


