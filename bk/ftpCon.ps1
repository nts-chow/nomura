Function ftp($ftpurl,$username,$ftppwd,$do,$filename,$DownPatch) { 
        if ($do -eq "up")
        {
            Write-Host $filename;
            Write-Host $ftppwd;
            Write-Host $username;
            Write-Host $ftpurl;

            $fileinf=New-Object System.Io.FileInfo("$filename")
            $upFTP = [system.net.ftpwebrequest] [system.net.webrequest]::create("$ftpurl"+$fileinf.name)
            $upFTP.Credentials = New-Object System.Net.NetworkCredential("$username","$ftppwd")
            $upFTP.Method=[system.net.WebRequestMethods+ftp]::UploadFile
            $upFTP.KeepAlive=$false
            $sourceStream = New-Object System.Io.StreamReader($fileInf.fullname)
            $fileContents = [System.Text.Encoding]::UTF8.GetBytes($sourceStream.ReadToEnd())
            $sourceStream.Close();
            $upFTP.ContentLength = $fileContents.Length;

            Write-Host  $upFTP.ContentLength;

            $requestStream = $upFTP.GetRequestStream();
            $requestStream.Write($fileContents, 0, $fileContents.Length);
            $requestStream.Close();
            $response =$upFTP.GetResponse();
            $response.StatusDescription
            $response.Close();
            Write-Host "UpLoad successful"
        }

        if ($do -eq "down")
        {
            $downFTP = [system.net.ftpwebrequest] [system.net.webrequest]::create("$ftpurl"+"$filename")
            $downFTP.Credentials = New-Object System.Net.NetworkCredential("$username","$ftppwd")
            $response = $downFTP.getresponse()
            $stream=$response.getresponsestream()
            $buffer = new-object System.Byte[] 2048
            $outputStream=New-Object System.Io.FileStream("$DownPatch","Create")
            while(($readCount = $stream.Read($buffer, 0, 1024)) -gt 0){
                $outputStream.Write($buffer, 0, $readCount)
            }
            $outputStream.Close()
            $stream.Close()
            $response.Close() 
            if(Test-Path  $DownPatch){
                Write-Host "DownLoad successful"
            }
        }

        if ($do -eq "list")
        {
            $listFTP = [system.net.ftpwebrequest] [system.net.webrequest]::create("$ftpurl")
            $listFTP.Credentials = New-Object System.Net.NetworkCredential("$username","$ftppwd")
            $listFTP.Method=[system.net.WebRequestMethods+ftp]::listdirectorydetails
            $response = $listFTP.getresponse()
            $stream = New-Object System.Io.StreamReader($response.getresponsestream(),[System.Text.Encoding]::UTF8)
            while(-not $stream.EndOfStream){
                $stream.ReadLine()
            }
            $stream.Close()
            $response.Close()     
        }

    }

ftp "ftp://192.168.100.5/" "ftp" "123123" "up" "D:\tmp\tesf\ftpup.txt" 
