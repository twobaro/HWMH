sfw_panel_formMethod

$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupConsultationKind:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_consultationKind")

If (FORM Event:C1606.code=On Load:K2:1)
	//%W-518.5
	ARRAY TEXT:C222($ptrPupMedicalHouse->; 0)
	ARRAY TEXT:C222($ptrPupConsultationKind->; 0)
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

If (String:C10(Form:C1466.calculation.load_medicalStaff_capabilities_forUUID)#Form:C1466.current_item.UUID)
	ConsultationKind_load_cache
	Form:C1466.calculation.load_medicalStaff_capabilities_forUUID:=Form:C1466.current_item.UUID
	$uuidCapabilities:=Form:C1466.current_item.medicalCapabilities.toCollection("UUID_ConsultationKind").distinct("UUID_ConsultationKind")
	$capabilites:=New collection:C1472
	For each ($uuid; $uuidCapabilities)
		$capabilites.push(ConsultationKind_getFromCache($uuid).name)
	End for each 
	(OBJECT Get pointer:C1124(Object named:K67:5; "medicalStaff_capabilities")->):=$capabilites.join(", ")
End if 

Case of 
	: (FORM Event:C1606.code=On Display Detail:K2:22)
	: (FORM Get current page:C276(*)=2)  // MedicalCapability
		
		MedicalStaff_pageConsultKinds
		
	: (FORM Get current page:C276(*)=3)  //appointments
		
		MedicalStaff_pageAppointments
		
End case 

OBJECT GET SUBFORM CONTAINER SIZE:C1148($width_subform; $height_subform)
OBJECT GET COORDINATES:C663(*; "entryField_photo_full"; $g; $h; $d; $b)
OBJECT SET COORDINATES:C1248(*; "entryField_photo_full"; $g; $h; $width_subform-2; $height_subform-2)