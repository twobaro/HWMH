//%attributes = {}
If (Storage:C1525.cache=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.cache:=New shared object:C1526
	End use 
End if 
If (Storage:C1525.cache.sfw_country=Null:C1517)
	$countriesColl:=ds:C1482.sfw_Country.all().toCollection("name, iso_code_2, address_format").orderBy("name")
	Use (Storage:C1525.cache)
		Storage:C1525.cache.sfw_country:=$countriesColl.copy(ck shared:K85:29; Storage:C1525.cache)
	End use 
End if 