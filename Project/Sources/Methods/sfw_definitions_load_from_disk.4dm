//%attributes = {}
var $file : Object
var $options : Object
var $jsonBrut; $json : Object
var $resolveResult : Object

$definitionFolder:=Folder:C1567(fk resources folder:K87:11).folder("sfw/definition")
$file:=$definitionFolder.file("visions_entries.json")
$text:=$file.getText()

$jsonBrut:=JSON Parse:C1218($text)
$options:=New object:C1471("merge"; True:C214)
$resolveResult:=JSON Resolve pointers:C1478($jsonBrut; $options)
$json:=$resolveResult.value

Use (Storage:C1525)
	Storage:C1525.sfwDefinition:=New shared object:C1526
End use 
Use (Storage:C1525.sfwDefinition)
	For each ($attribute; $json)
		Case of 
			: (OB Get type:C1230($json; $attribute)=Is object:K8:27)
				Storage:C1525.sfwDefinition[$attribute]:=OB Copy:C1225($json[$attribute]; ck shared:K85:29; Storage:C1525.sfwDefinition)
				
			: (OB Get type:C1230($json; $attribute)=Is collection:K8:32)
				Storage:C1525.sfwDefinition[$attribute]:=$json[$attribute].copy(ck shared:K85:29; Storage:C1525.sfwDefinition)
				
		End case 
	End for each 
End use 


