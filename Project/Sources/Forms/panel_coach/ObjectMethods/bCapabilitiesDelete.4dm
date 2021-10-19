If (String:C10(Form:C1466.capability.UUID)#"")
	If (Form:C1466.uuid_capabilitiesToDelete=Null:C1517)
		Form:C1466.uuid_capabilitiesToDelete:=New collection:C1472
	End if 
	Form:C1466.uuid_capabilitiesToDelete.push(Form:C1466.capability.UUID)
End if 
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities.remove(Form:C1466.capability_position-1)
Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities
Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
If (Form:C1466.capability_position>Form:C1466.lb_capabilities.length)
	Form:C1466.capability_position:=Form:C1466.lb_capabilities.length
End if 
LISTBOX SELECT ROW:C912(*; "lb_capabilities"; Form:C1466.capability_position; lk replace selection:K53:1)