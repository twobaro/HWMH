sfw_panel_formMethod

Case of 
	: (Form:C1466.current_item=Null:C1517)
	: (FORM Get current page:C276(*)=1)
		If (String:C10(Form:C1466.current_item.UUID)#"")
			If (String:C10(Form:C1466.calculation.loadlbDoctorsForUUID)#Form:C1466.current_item.UUID)
				Form:C1466.calculation.loadlbDoctorsForUUID:=Form:C1466.current_item.UUID
				If (Form:C1466.current_item.medicalCapabilities#Null:C1517)
					Form:C1466.lb_doctors:=Form:C1466.current_item.medicalCapabilities.medicalStaff.toCollection()
				Else 
					Form:C1466.lb_doctors:=New collection:C1472
				End if 
				Form:C1466.doctor_position:=0
			End if 
		Else 
			If (Form:C1466.lb_doctors=Null:C1517)
				Form:C1466.lb_doctors:=New collection:C1472
			End if 
		End if 
		
	: (FORM Get current page:C276(*)=2)
		
End case 
