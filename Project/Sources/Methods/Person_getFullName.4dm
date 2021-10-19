//%attributes = {}
#DECLARE ($target : Variant)->$fullName : Text

var $p : cs:C1710.PersonEntity

$fullName:=""
Case of 
	: (Value type:C1509($target)=Is text:K8:3)
		$p:=ds:C1482.Person.get($target)
	: (Value type:C1509($target)=Is object:K8:27)
		$p:=$target
End case 
If ($p#Null:C1517)
	$coll:=New collection:C1472($p.civility; $p.firstName; $p.lastName)
	$fullName:=$coll.join(" "; ck ignore null or empty:K85:5)
End if 