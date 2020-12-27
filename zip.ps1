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