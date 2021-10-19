sfw_panel_formMethod


$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupActivy:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_activity")

If (FORM Event:C1606.code=On Load:K2:1)
	//%W-518.5
	ARRAY TEXT:C222($ptrPupMedicalHouse->; 0)
	ARRAY TEXT:C222($ptrPupActivy->; 0)
	//%W+518.5
	Form:C1466.scheduleSubForm:=New object:C1471()
	If (Form:C1466.lb_appointments=Null:C1517)
		Form:C1466.lb_appointments:=New collection:C1472
	End if 
	If (Form:C1466.lb_appointments_toSave=Null:C1517)
		Form:C1466.lb_appointments_toSave:=New collection:C1472
	End if 
	Form:C1466.format_button_displayDay:=OBJECT Get format:C894(*; "button_displayDay_1")
End if 

Case of 
	: (FORM Event:C1606.code=On Display Detail:K2:22)
	: (FORM Get current page:C276(*)=2)  // LessonsCapabilty
		
		Coach_pageActivities
		
		
	: (FORM Get current page:C276(*)=3)  //appointments
		
		Coach_pageAppointments
		
End case 


OBJECT GET SUBFORM CONTAINER SIZE:C1148($width_subform; $height_subform)
OBJECT GET COORDINATES:C663(*; "entryField_photo_full"; $g; $h; $d; $b)
OBJECT SET COORDINATES:C1248(*; "entryField_photo_full"; $g; $h; $width_subform-2; $height_subform-2)
