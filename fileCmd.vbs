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
