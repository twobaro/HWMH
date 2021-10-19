//%attributes = {}
$isInModification:=sfw_checkIsInModification
OBJECT SET ENABLED:C1123(*; "bCapabilitiesAdd"; $isInModification)
OBJECT SET ENABLED:C1123(*; "bCapabilitiesDelete"; $isInModification & (Form:C1466.capability_position#0))


$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupConsultationKind:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_consultationKind")

If (Size of array:C274($ptrPupMedicalHouse->)=0)
	MedicalHouse_load_cache
	For each ($house; Storage:C1525.cache.medicalHouse)
		APPEND TO ARRAY:C911($ptrPupMedicalHouse->; $house.name)
	End for each 
End if 
//
If (Size of array:C274($ptrPupConsultationKind->)=0)
	ConsultationKind_load_cache
	For each ($consultationKind; Storage:C1525.cache.consultationKind)
		APPEND TO ARRAY:C911($ptrPupConsultationKind->; $consultationKind.name)
	End for each 
End if 


If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadLbCapabilitiesForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadLbCapabilitiesForUUID:=Form:C1466.current_item.UUID
		If (Form:C1466.current_item.medicalCapabilities#Null:C1517)
			Form:C1466.lb_capabilities:=Form:C1466.current_item.medicalCapabilities.toCollection()
			$dayNames:=Split string:C1554(sfw_xliff_read("dateAndTime.days"; "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday"); ";")
			For each ($capabilities; Form:C1466.lb_capabilities)
				$days:=New collection:C1472
				$dayNums:=New collection:C1472
				If ($capabilities.schedule.default.except#Null:C1517)
					$excepts:=$capabilities.schedule.default.except
				Else 
					$excepts:=New collection:C1472()
				End if 
				For ($d; 1; 7)
					If ($excepts.countValues($d)=0)
						$dayNums.push($d)
						$days.push(Substring:C12($dayNames[$d-1]; 1; 2))
					End if 
				End for 
				$capabilities.dayNums:=$dayNums.join(", ")
				$capabilities.daysDefault:=$days.join(", ")
				$capabilities.duration:=sfw_Time(sfw_schedule_getWorkingDuration($capabilities.schedule.default.work))
			End for each 
			Form:C1466.lb_capabilities:=Form:C1466.lb_capabilities.orderBy("dayNums")
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

If (String:C10(FORM Event:C1606.objectName)#"pup_consultationKind")
	$ptrPupConsultationKind->:=0
	If (Form:C1466.capability#Null:C1517)
		$indices:=Storage:C1525.cache.consultationKind.indices("UUID = :1"; Form:C1466.capability.UUID_ConsultationKind)
		If ($indices.length>0)
			$ptrPupConsultationKind->:=$indices[0]+1
		End if 
	End if 
End if 

OBJECT SET VISIBLE:C603(*; "pup_medicalHouse"; (Form:C1466.capability_position#0))
OBJECT SET VISIBLE:C603(*; "pup_consultationKind"; (Form:C1466.capability_position#0))
OBJECT SET VISIBLE:C603(*; "scheduleSubform"; (Form:C1466.capability_position#0))
OBJECT SET ENABLED:C1123(*; "pup_medicalHouse"; $isInModification)
OBJECT SET ENABLED:C1123(*; "pup_consultationKind"; $isInModification)

sfw_schedule_subForm_update(Form:C1466.capability)
