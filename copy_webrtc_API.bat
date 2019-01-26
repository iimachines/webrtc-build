@ECHO OFF

REM https:\\webrtc.googlesource.com\src\+\master\native-api.md
REM the above documentation is not up-to-date with the version of webrtc we are building,
REM so we have to add more include files :(

set "out=%1"
set "h264=%2"
set "src=%out%\src"

set "batchDir=%~dp0%"
set "lib=%batchDir%lib"
set "include=%batchDir%include"

rd /s /q "%include%"

if "%h264%"==1 then (
    xcopy /y /i /d %out%\windows_clang_debug_x64\obj\webrtc.lib    %lib%\windows_debug_x64\
    xcopy /y /i /d %out%\windows_clang_release_x64\obj\webrtc.lib  %lib%\windows_release_x64\
) else (
    xcopy /y /i /d %out%\windows_msvc_debug_x64\obj\webrtc.lib    %lib%\windows_debug_x64\
    xcopy /y /i /d %out%\windows_msvc_release_x64\obj\webrtc.lib  %lib%\windows_release_x64\
)

xcopy /y /s /i /d %src%\api\*.h                          %include%\webrtc\api\

xcopy /y /s /i /d %src%\third_party\abseil-cpp\absl\*.h  %include%\webrtc\absl\
xcopy /y /s /i /d %src%\rtc_base\*.h                     %include%\webrtc\rtc_base\
xcopy /y /s /i /d %src%\logging\*.h                      %include%\webrtc\logging\
xcopy /y /s /i /d %src%\p2p\*.h                          %include%\webrtc\p2p\

call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ . 										
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ pc 										
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ call 										
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ media\base 								
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ media\engine							
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\include							
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\include							
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_capture
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\audio_device\include				
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\audio_processing\include			
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\bitrate_controller\include		
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\congestion_controller\include		
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\remote_bitrate_estimator\include	
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\rtp_rtcp\include					
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\rtp_rtcp\source					
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\utility\include					

call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\include		
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\utility	
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\interface	
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\vp8\include	
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\vp9\include	

call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ common_audio\include						
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ common_video\include						
call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ common_video\libyuv\include					

call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ system_wrappers\include					

call %batchDir%\copy_include_folder %src%\ %include%\ third_party\libyuv\include\libyuv

if "%h264%"==1 then (
    call %batchDir%\copy_include_folder %src%\ %include%\ third_party\openh264\src\codec\api\svc
    call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ common_video\h264					
    call %batchDir%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\h264\include	
)

