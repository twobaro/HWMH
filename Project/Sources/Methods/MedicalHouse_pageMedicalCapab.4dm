//%attributes = {}


If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadmedicalCapabilitiesForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadmedicalCapabilitiesForUUID:=Form:C1466.current_item.UUID
		If (Form:C1466.current_item.medicalCapabilities#Null:C1517)
			ConsultationKind_load_cache
			Form:C1466.lb_medicalCapabilities:=Form:C1466.current_item.medicalCapabilities.toCollection("*, medicalStaff.*").extract("UUID"; "UUID"; "UUID_Coach"; "UUID_Coach"; "UUID_ConsultationKind"; "UUID_ConsultationKind"; "medicalStaff.civility"; "civility"; "medicalStaff.lastName"; "lastName"; "medicalStaff.firstName"; "firstName"; "schedule"; "schedule")
			For each ($medicalCapability; Form:C1466.lb_medicalCapabilities)
				$medicalCapability.consultationKind:=ConsultationKind_getFromCache($medicalCapability.UUID_ConsultationKind).name
			End for each 
		Else 
			Form:C1466.lb_medicalCapabilities:=New collection:C1472
		End if 
		Form:C1466.medicalCapability_position:=0
	End if 
Else 
	If (Form:C1466.lb_medicalCapabilities=Null:C1517)
		Form:C1466.lb_medicalCapabilities:=New collection:C1472
	End if 
End if 

OBJECT SET VISIBLE:C603(*; "scheduleSubform_ms"; (Form:C1466.medicalCapability_position#0))

sfw_schedule_subForm_update(Form:C1466.medicalCapability; "notEditable"; "attribute:scheduleSubForm_ms")
