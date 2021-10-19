//%attributes = {}
$isInModification:=sfw_checkIsInModification
OBJECT SET ENABLED:C1123(*; "bCapabilitiesAdd"; $isInModification)
OBJECT SET ENABLED:C1123(*; "bCapabilitiesDelete"; $isInModification & (Form:C1466.capability_position#0))


$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupActivy:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_activity")

If (Size of array:C274($ptrPupMedicalHouse->)=0)
	MedicalHouse_load_cache
	For each ($house; Storage:C1525.cache.medicalHouse)
		APPEND TO ARRAY:C911($ptrPupMedicalHouse->; $house.name)
	End for each 
End if 
If (Size of array:C274($ptrPupActivy->)=0)
	Activity_load_cache
	For each ($activity; Storage:C1525.cache.activity)
		APPEND TO ARRAY:C911($ptrPupActivy->; $activity.name)
	End for each 
End if 

If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadLbCapabilitiesForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadLbCapabilitiesForUUID:=Form:C1466.current_item.UUID
		If (Form:C1466.current_item.lessonCapabilities#Null:C1517)
			Form:C1466.lb_capabilities:=Form:C1466.current_item.lessonCapabilities.toCollection()
		Else 
			Form:C1466.lb_capabilities:=New collection:C1472
		End if 
		Form:C1466.capability_position:=0
	End if 
Else 
	If (Form:C1466.lb_capabilities=Null:C1517)
		Form:C1466.lb_capabilities:=New collection:C1472
	End if 
End if 

If (String:C10(FORM Event:C1606.objectName)#"pup_medicalHouse")
	$ptrPupMedicalHouse->:=0
	If (Form:C1466.capability#Null:C1517)
		$indices:=Storage:C1525.cache.medicalHouse.indices("UUID = :1"; Form:C1466.capability.UUID_MedicalHouse)
		If ($indices.length>0)
			$ptrPupMedicalHouse->:=$indices[0]+1
		End if 
	End if 
End if 

If (String:C10(FORM Event:C1606.objectName)#"pup_activity")
	$ptrPupActivy->:=0
	If (Form:C1466.capability#Null:C1517)
		$indices:=Storage:C1525.cache.activity.indices("UUID = :1"; Form:C1466.capability.UUID_Activity)
		If ($indices.length>0)
			$ptrPupActivy->:=$indices[0]+1
		End if 
	End if 
End if 

OBJECT SET VISIBLE:C603(*; "pup_medicalHouse"; (Form:C1466.capability_position#0))
OBJECT SET VISIBLE:C603(*; "pup_activity"; (Form:C1466.capability_position#0))
OBJECT SET VISIBLE:C603(*; "scheduleSubform"; (Form:C1466.capability_position#0))
OBJECT SET ENABLED:C1123(*; "pup_medicalHouse"; $isInModification)
OBJECT SET ENABLED:C1123(*; "pup_activity"; $isInModification)

sfw_schedule_subForm_update(Form:C1466.capability)
