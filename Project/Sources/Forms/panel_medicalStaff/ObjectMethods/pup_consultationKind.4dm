$ptrPupConsultationKind:=OBJECT Get pointer:C1124(Object current:K67:2)
$index:=$ptrPupConsultationKind->
If ($index>0)
	Form:C1466.capability.UUID_ConsultationKind:=Storage:C1525.cache.consultationKind[$index-1].UUID
Else 
	Form:C1466.capability.UUID_ConsultationKind:=""
End if 
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities

Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
