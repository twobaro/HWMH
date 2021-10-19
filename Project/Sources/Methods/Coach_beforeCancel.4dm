//%attributes = {}
#DECLARE ($subForm : Object)


If ($subForm.lb_appointments_toSave#Null:C1517)
	$subForm.lb_appointments_toSave:=New collection:C1472
End if 


$subForm.calendar.lastUUIDforDrawing:=""

