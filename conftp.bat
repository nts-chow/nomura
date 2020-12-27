@echo off
::FTP転送
echo %date% %time% >> run.log 
ftp -i -s:script.bat
pause
echo %date%%time% >> run.log 

::ファイル削除
del /s D:\tmp\zipA\A202012270001.zip
del /s D:\tmp\zipA\A202012270002.zip

echo %date%%time% >> run.log 
pause
