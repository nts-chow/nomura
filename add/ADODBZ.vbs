Call Main 
Sub Main() 
    Call WriteFileUTF8("D:\tmp\work\test\zipB.txt", "AND") 
End Sub 

' Valid Charset values for ADODB.Stream 
Const cdoShift_JIS   = "shift-jis" 
Const CdoUTF_8       = "utf-8" 
Const adTypeBinary          = 1 
Const adTypeText            = 2 
Const adSaveCreateNotExist  = 1 
Const adSaveCreateOverWrite = 2 

Function WriteFileUTF8(FileName, str) 
    dim adodbStream 
    Set adodbStream = CreateObject("ADODB.Stream") 
    adodbStream.Type = adTypeText 
    adodbStream.Open 
    adodbStream.Charset = cdoShift_JIS 
    adodbStream.WriteText str , 1
    adodbStream.SaveToFile FileName & flnm, 2 
    adodbStream.Close() 
    set adodbStream = nothing 
End Function 

Function UTF8( myFileIn, myFileOut ) 
    Dim objStream 
    On Error Resume Next 
    Set objStream = CreateObject( "ADODB.Stream" ) 
    objStream.Open 
    objStream.Type = adTypeText 
    objStream.Position = 0 
    objStream.Charset = CdoUTF_8 
    objStream.LoadFromFile myFileIn 
    objStream.SaveToFile myFileOut, adSaveCreateOverWrite 
    objStream.Close 
    Set objStream = Nothing 
    If Err Then 
        UTF8 = False 
    Else 
        UTF8 = True 
    End If 
      
    On Error Goto 0 
End Function 
