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