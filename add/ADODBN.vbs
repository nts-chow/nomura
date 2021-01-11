'入力ファイル名（読み出したいファイル）
Dim inputFileName
inputFileName = input.txt
'出力ファイル名（書き出し先ファイル）
Dim outputFileName
outputFileName = output.txt

'入力ストリームの生成・設定（テキスト、UTF-8）
Dim inStream
Set inStream = CreateObject("ADODB.Stream")
inStream.type = 2 　'1:バイナリデータ 2:テキストデータ
inStream.charset = "UTF-8" 　'入力ファイルの文字コード設定
inStream.open
inStream.LoadFromFile inputFileName 　'入力ファイルを読み込む

'出力ストリームの生成・設定（テキスト、UTF-8）
Dim outStream
Set outStream =CreateObject("ADODB.Stream")
outStream.type = 2
outStream.charset = "UTF-8" 　'出力ファイルの文字コード設定
outStream.open 

'入力ファイルから一行ずつ読み出して、出力ストリームへ書き出す
Dim records
Do While inStream.EOS = False
　　'読み込んだレコードをカンマ区切りで配列に格納
　　records = Split(inStream.ReadText(-2), ",") 　'ReadTextの第一引数：-1:全部読み込む -2:一行読み込む
　　'必要な情報を出力ストリームへ書き出す
　　'この例では、CSVファイルの4項目目だけを抽出している
　　outStream.WriteText records(3), 1 　'WriteTextの第二引数：0:文字列のみ書き込む 1:文字列＋改行を書き込む
Loop

'出力ファイル生成
outStream.SaveToFile outputFileName, 2 　'1:ファイルがない場合はファイル作成 2:ファイルがある場合は上書き

'ストリームを閉じる
inStream.Close
outStream.Close

'オブジェクトを解放 
Set inStream = Nothing
Set outStream = Nothing