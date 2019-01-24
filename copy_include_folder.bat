@echo off
if not exist %2%3 (
    mkdir %2%3
)

xcopy /d /i %1%3\*.h %2%3\



