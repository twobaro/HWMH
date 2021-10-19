$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupActivy:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_activity")

Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Form:C1466.capability:=New object:C1471

Form:C1466.capability.UUID_Coach:=Form:C1466.current_item.UUID
Form:C1466.capability.UUID_MedicalHouse:=Storage:C1525.cache.medicalHouse[0].UUID
Form:C1466.capability.UUID_Activity:=Storage:C1525.cache.activity[0].UUID


Form:C1466.lb_capabilities.push(Form:C1466.capability)
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities

$position:=Form:C1466.lb_capabilities.length
LISTBOX SELECT ROW:C912(*; "lb_capabilities"; $position; lk replace selection:K53:1)