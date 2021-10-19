//%attributes = {}
#DECLARE ($value : Variant)->$result : Text

var $text : Text
var $search : Text
var $position : Integer

$text:=String:C10($value)
$result:=$text
If (Form:C1466.searchbox#"")
	$search:=Form:C1466.searchbox
	If ("@"=$search[[1]])
		$search:=Substring:C12($search; 2)
	End if 
	If (Length:C16($search)>0)
		If ("@"=$search[[Length:C16($search)]])
			$search:=Substring:C12($search; 1; Length:C16($search)-1)
		End if 
		If (Length:C16($search)>0)
			$position:=Position:C15($search; $text)
			If ($position>0)
				$result:=Substring:C12($text; 1; $position-1)
				$result:=$result+"<SPAN STYLE=\"background-color:aqua\">"+Substring:C12($text; $position; Length:C16($search))+"</SPAN>"
				$result:=$result+Substring:C12($text; $position+Length:C16($search))
			End if 
		End if 
	End if 
End if 