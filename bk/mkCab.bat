@echo off
::makecab
echo %date%%time% >> run.log 
makecab /f D:\tmp\work\list.txt /d expresstype=mszip /d expressmemory=21 /d maxdisksize=1024000000 /d diskdirectorytemplate=D:\tmp\zipB\ /d cabinetnametemplate=20210312.cab
echo %date%%time% >> run.log 
pause