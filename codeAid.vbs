Option Explicit
Dim msgFileo
Dim fileFromInput
Dim msgFilet
Dim countFromInput
Dim count
Dim lines
Dim linesArr
Dim linesc

'入力必要データ
msgFileo="繰り返すフォルダーを入力する:※普通zipB,(zipAはOT-STのみ)"
fileFromInput=Inputbox(msgFileo) 
msgFilet="繰り返す回数入力する:※普通2,(80はOT-STのみ)"
countFromInput=Inputbox(msgFilet) 

Msgbox "file is : " & fileFromInput& " ; " & "count is :" &countFromInput

count = getCount(fileFromInput)
lines = getArr(countFromInput,count,fileFromInput)
call writeftpConDel(fileFromInput,lines)
call writeScript(fileFromInput,lines)
call writeFinish(fileFromInput,lines)

REM 1
Function getCount(fn)
	Dim fso,f,a,fname,k
	Set fso = CreateObject("Scripting.FileSystemObject")
	fname= ".\ftp\" & fn & "FinishList.txt"
	if  Not fso.FileExists(fname) then
		fso.createTextFile fname
	end if
	Set f=fso.OpenTextFile(fname,1)
	getCount=0
	DO While f.AtEndOfStream <> True
		a=f.ReadLine 
		getCount=getCount+1
	loop
	f.close
	set fso=Nothing
End Function

REM 2
Function getArr(c,k,fn)
	Dim fso,f,a,fname,cc,kk,j
	Set fso = CreateObject("Scripting.FileSystemObject")
	fname=".\" & fn & ".txt"
	getArr=""
	Set f=fso.OpenTextFile(fname,1)
	j=0
	cc=c+k
	kk=k
	DO While f.AtEndOfStream <> True
		a = f.ReadLine
		j=j+1
		if j>kk and j<=cc then
			getArr= getArr & Mid(Trim(a),10,8) & ","
		end if	
	loop
	f.close
	set fso=Nothing
End Function

REM 3
Sub writeftpConDel(fn,arr)
	Dim f,conDel,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\ot\ftpConDel.bat"
	Else
		fname=".\ftp\st\ftpConDel.bat"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if
	set conDel = f.opentextfile(fname,2)   
	conDel.writeline "@echo off" & chr(9)
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			conDel.writeLine linefc & chr(9)
		end if 
	next
	conDel.writeline "pause" & chr(9)
	conDel.close
	set f=Nothing
End Sub

REM 4
Sub writeScript(fn,arr)
	Dim f,sc,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\ot\script.bat"
	Else
		fname=".\ftp\st\script.bat"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if
	set sc = f.opentextfile(fname,2)   
	sc.writeline "@echo off" & chr(9)
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			sc.writeLine linefc & chr(9)
		end if 
	next
	sc.writeline "pause" & chr(9)
	sc.close
	set f=Nothing
End Sub

REM 5
Sub writeFinish(fn,arr)
	Dim f,sc,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\zipBFinishList.txt"
	Else
		fname=".\ftp\zipAFinishList.txt"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if

	set sc = f.opentextfile(fname,8)   
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			sc.writeLine linefc & chr(9)
		end if 
	next
	sc.close
	set f=Nothing
End Sub
