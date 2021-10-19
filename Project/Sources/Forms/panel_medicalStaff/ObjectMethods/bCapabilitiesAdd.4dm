Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Form:C1466.capability:=New object:C1471

Form:C1466.capability.UUID_MedicalStaff:=Form:C1466.current_item.UUID
Form:C1466.capability.UUID_MedicalHouse:=Storage:C1525.cache.medicalHouse[0].UUID
Form:C1466.capability.UUID_ConsultationKind:=Storage:C1525.cache.consultationKind[0].UUID


Form:C1466.lb_capabilities.push(Form:C1466.capability)
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities

$position:=Form:C1466.lb_capabilities.length
LISTBOX SELECT ROW:C912(*; "lb_capabilities"; $position; lk replace selection:K53:1)