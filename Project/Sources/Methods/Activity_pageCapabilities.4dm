//%attributes = {}



If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadlessonCapabilitiesForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadlessonCapabilitiesForUUID:=Form:C1466.current_item.UUID
		If (Form:C1466.current_item.lessonCapabilities#Null:C1517)
			MedicalHouse_load_cache
			Form:C1466.lb_lessonCapabilities:=Form:C1466.current_item.lessonCapabilities.toCollection("*, coach.*").extract("UUID"; "UUID"; "UUID_Coach"; "UUID_Coach"; "UUID_MedicalHouse"; "UUID_MedicalHouse"; "coach.civility"; "civility"; "coach.lastName"; "lastName"; "coach.firstName"; "firstName"; "schedule"; "schedule")
			For each ($lessonCapability; Form:C1466.lb_lessonCapabilities)
				$lessonCapability.medicalHouse:=MedicalHouse_getFromCache($lessonCapability.UUID_MedicalHouse).name
			End for each 
		Else 
			Form:C1466.lb_lessonCapabilities:=New collection:C1472
		End if 
		Form:C1466.lessonCapability_position:=0
	End if 
Else 
	If (Form:C1466.lb_lessonCapabilities=Null:C1517)
		Form:C1466.lb_lessonCapabilities:=New collection:C1472
	End if 
End if 

OBJECT SET VISIBLE:C603(*; "scheduleSubform"; (Form:C1466.lessonCapability_position#0))

sfw_schedule_subForm_update(Form:C1466.lessonCapability; "notEditable")
