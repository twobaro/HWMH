//%attributes = {}
If (Storage:C1525.cache=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.cache:=New shared object:C1526
	End use 
End if 
If (Storage:C1525.cache.consultationKind=Null:C1517)
	$activityColl:=ds:C1482.ConsultationKind.all().toCollection("UUID, name").orderBy("name")
	Use (Storage:C1525.cache)
		Storage:C1525.cache.consultationKind:=$activityColl.copy(ck shared:K85:29; Storage:C1525.cache)
	End use 
End if 