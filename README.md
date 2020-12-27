ftp put

```bash
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
```

```bash
open 192.168.100.5
ftp
123123
cd pub
binary

put D:\tmp\zipA\A202012270001.zip  ./A202012270001.zip 
put D:\tmp\zipA\A202012270002.zip  ./A202012270002.zip 

bye
```

ZIP1

```powershell
param($source)

#$Source="D:\tmp\tesf"
Write-Output $Source

[System.Reflection.Assembly]::Load("WindowsBase,Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35")

$partCnt=1
[long]$BreakSize=0

$destZip = "D:\tmp\zipA\A" + (Get-Date).ToString('yyyyMMdd') +$partCnt.ToString("0000") +".zip" 
if (Test-Path($destZip))
{
	Remove-Item $destZip
}

$ZipPackage=[System.IO.Packaging.ZipPackage]::Open($destZip,[System.IO.FileMode]"OpenOrCreate", [System.IO.FileAccess]"ReadWrite")

$outline=$destZip+"----"+(Get-Date).ToString('yyyyMMddhhmmss') 
Write-Output $outline | out-file -Append zipA.log
Write-Host "destZip:"+$destZip +"FullName:"

$files = Get-ChildItem -path $Source -Recurse | ForEach-Object -Process{
    if($_-is[System.IO.FileInfo]){
        $BreakSize+=$_.Length
        if($BreakSize/1024/1024/1024 -ge 1){
            $BreakSize = 0
            $partCnt += 1
            ####xml File delete Start####
            
            ####xml File delete End #####
            $ZipPackage.close()

            $destZip = "D:\tmp\zipA\A" + (Get-Date).ToString('yyyyMMdd')+$partCnt.ToString("0000") + ".zip" 
            if (Test-Path($destZip))
            {
	            Remove-Item $destZip
            }

            $ZipPackage=[System.IO.Packaging.ZipPackage]::Open($destZip,[System.IO.FileMode]"OpenOrCreate", [System.IO.FileAccess]"ReadWrite")
            $outline=$destZip+"----"+(Get-Date).ToString('yyyyMMddhhmmss') 
            Write-Output $outline | out-file -Append zipA.log
            Write-Host "destZip:"+$destZip +"FullName:"+$_.FullName
        }
        
        #$UriPath=$_.FullName.Replace("G:","").Replace("\","/")
        $UriPath=$_.FullName.Replace($source,"").Replace("\","/")
        $partName=New-Object System.Uri($UriPath, [System.UriKind]"Relative")
        $pkgPart=$ZipPackage.CreatePart($partName, "application/zip",[System.IO.Packaging.CompressionOption]::NotCompressed)
        $bytes=[System.IO.File]::ReadAllBytes($_.FullName)
	    $stream=$pkgPart.GetStream()
	    $stream.Write($bytes, 0, $bytes.Length)
	    $stream.Close() 
        #Remove-Item $file.FullName
    }
}

$ZipPackage.close()

#.\zip.ps1 D:\tmp\tesf
```

ZIP2

```powershell
#$countにより、作成ファイル数決まる
param($count)

#システム組件LOAD
[System.Reflection.Assembly]::Load("WindowsBase,Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35")

#対象フォルダー
$zipAPath="D:\tmp\zipA"
$Di=New-Object System.IO.DirectoryInfo($zipAPath);

##事前フォルダー有無判定、有の場合スッキプすます。
$partCnt=0;
for($i=1 ; $i -le 1000;$i++){
    $testCnt=$partCnt+1
    $testPath="D:\tmp\zipB\B" + (Get-Date).ToString('yyyyMMdd') + $testCnt.ToString("000") + ".zip" ;
    if (Test-Path($testPath))
    {
	    $partCnt+=1;
    }
    else{
        break;
    }
}
Write-Host $partCnt

#書庫か作業
for($i=1 ; $i -le $count;$i++)
{ 
    $partCnt += 1
    $ZipPath="D:\tmp\zipB\B" + (Get-Date).ToString('yyyyMMdd') + $partCnt.ToString("000") + ".zip" 

    $outline=$ZipPath+"----"+(Get-Date).ToString('yyyyMMddhhmmss') 
    Write-Output $outline | out-file -Append zipB.log
    Write-Host $ZipPath

    $pkg=[System.IO.Packaging.ZipPackage]::Open($ZipPath,[System.IO.FileMode]"OpenOrCreate", [System.IO.FileAccess]"ReadWrite")
    $files = $Di.GetFiles()
    [long]$BreakSize=0
    $n = 0
    ForEach ($file In $files)
    {
        $n+=1
        $BreakSize+=$file.Length
	    $uriString="/" +$file.Name
    
	    $partName=New-Object System.Uri($uriString, [System.UriKind]"Relative")
	    $pkgPart=$pkg.CreatePart($partName, "application/zip",[System.IO.Packaging.CompressionOption]"NotCompressed")
	    $bytes=[System.IO.File]::ReadAllBytes($file.FullName)
	    $stream=$pkgPart.GetStream()
	    $stream.Write($bytes, 0, $bytes.Length)
	    $stream.Close()
        Remove-Item $file.FullName
        
        if($file-is[System.IO.FileInfo]){
            if($n -ge 4 -or $BreakSize/1024/1024/1024/2 -ge 1){
                $BreakSize = 0
                $pkg.close()
                break
            }
        }
    }
    $pkg.close()
}

#.\zip2.ps1 2
```

VBS CMD CREATE

```vbscript
Option Explicit

Sub WrtiteTxt()
    Dim i, k As Integer
    Dim str As String
    
    Open "D:\tes\vbat\conftp.bat" For Output As #1
    Print #1, "@echo off"
    Print #1, "::FTP go to"
    Print #1, "echo %date% %time% >> run.log"
    Print #1, "ftp -i -s:script.bat"
    Print #1, "echo %date%%time% >> run.log "
    Print #1, "::file del"
   
    k = 1
    While Trim(Cells(k, 2)) <> ""
     Print #1, "put "; Mid(Trim(Cells(k, 2)), 1, 29); " ./"; Mid(Trim(Cells(k, 2)), 13, 17)
     k = k + 1
    Wend
    
    Print #1, "echo %date%%time% >> run.log "
    Print #1, "pause"

    Close #1

End Sub

```

