@ECHO OFF

REM https:\\webrtc.googlesource.com\src\+\master\native-api.md
REM the above documentation is not up-to-date with the version of webrtc we are building,
REM so we have to add more include files :(

set "out=webrtc-checkout"
set "src=webrtc-checkout\src"
set "lib=lib"
set "include=include"
set "batchDirectory=%~dp0%"

xcopy /i /d %out%\windows_debug_x64\obj\webrtc.lib    %lib%\windows_debug_x64\
xcopy /i /d %out%\windows_release_x64\obj\webrtc.lib  %lib%\windows_release_x64\

xcopy /s /i /d %src%\api\*.h                          %include%\webrtc\api\

xcopy /s /i /d %src%\third_party\abseil-cpp\absl\*.h  %include%\webrtc\absl\
xcopy /s /i /d %src%\rtc_base\*.h                     %include%\webrtc\rtc_base\
xcopy /s /i /d %src%\logging\*.h                      %include%\webrtc\logging\
xcopy /s /i /d %src%\p2p\*.h                          %include%\webrtc\p2p\

call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ . 										
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ pc 										
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ call 										
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ media\base 								
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ media\engine							
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\include							
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\include							
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_capture
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\audio_device\include				
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\audio_processing\include			
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\bitrate_controller\include		
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\congestion_controller\include		
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\remote_bitrate_estimator\include	
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\rtp_rtcp\include					
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\rtp_rtcp\source					
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\utility\include					
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\include				
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\interface	
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\h264\include	
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\vp8\include	
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ modules\video_coding\codecs\vp9\include	
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ common_audio\include						
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ common_video\include						
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ common_video\libyuv\include						
call %batchDirectory%\copy_include_folder %src%\ %include%\webrtc\ system_wrappers\include					

