Case of 
	: (sfw_checkIsInModification=False:C215)
	: (Form:C1466.capability=Null:C1517)
	: (Form:C1466.scheduleSubForm=Null:C1517)
	: (Form:C1466.scheduleSubForm.schedule=Null:C1517)
	: (FORM Event:C1606.code=-98001)
		Form:C1466.capability.schedule:=Form:C1466.scheduleSubForm.schedule
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		sfw_main_redraw_button
End case 
