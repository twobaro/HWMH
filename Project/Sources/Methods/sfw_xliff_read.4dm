//%attributes = {"publishedWeb":true}
#DECLARE ($xliff : Text; $label : Text)->$string : Text

$string:=$label
If ($xliff#Null:C1517)
	$xliff:=Get localized string:C991($xliff)
	If ($xliff#"")
		$string:=$xliff
	Else 
		// wrtie in a log file for missing xliff
	End if 
End if 

