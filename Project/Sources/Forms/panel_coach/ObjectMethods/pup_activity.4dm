$ptrPupActivy:=OBJECT Get pointer:C1124(Object current:K67:2)
$index:=$ptrPupActivy->
If ($index>0)
	Form:C1466.capability.UUID_Activity:=Storage:C1525.cache.activity[$index-1].UUID
Else 
	Form:C1466.capability.UUID_Activity:=""
End if 
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities

Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
