//%attributes = {}
#DECLARE ($uuid : Text)->$mh : Object

$indices:=Storage:C1525.cache.medicalHouse.indices("UUID = :1"; $uuid)
If ($indices.length>0)
	$mh:=Storage:C1525.cache.medicalHouse[$indices[0]]
Else 
	$mh:=New object:C1471
End if 
