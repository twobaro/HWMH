sfw_panel_formMethod

If (FORM Event:C1606.code=On Load:K2:1)
	If (Form:C1466.lb_appointments=Null:C1517)
		Form:C1466.lb_appointments:=New collection:C1472
	End if 
End if 


Case of 
	: (FORM Event:C1606.code=On Display Detail:K2:22)
	: (FORM Get current page:C276(*)=2)  // LessonsCapabilty
		
		Person_pageAppointments
		
		
		
End case 