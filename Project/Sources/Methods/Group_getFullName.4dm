//%attributes = {}
#DECLARE ($target : Variant)->$fullName : Text

var $g : cs:C1710.GroupEntity

$fullName:=""
Case of 
	: (Value type:C1509($target)=Is text:K8:3)
		$g:=ds:C1482.Group.get($target)
		
	: (Value type:C1509($target)=Is object:K8:27)
		$g:=$target
End case 

If ($g#Null:C1517)
	$fullName:=$g.name
End if 