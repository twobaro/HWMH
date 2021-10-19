//%attributes = {}
#DECLARE ($subForm : Object)
var $eCapabilty : cs:C1710.MedicalCapability
var $entity : 4D:C1709.Entity

//creation or update of the capabilities 
If ($subForm.lb_capabilities#Null:C1517)
	For each ($capabilty; $subForm.lb_capabilities)
		
		If (String:C10($capabilty.UUID)="")  //if the uuid ist blank or not present, that's a new capability
			$eCapabilty:=ds:C1482.MedicalCapability.new()
		Else 
			$eCapabilty:=ds:C1482.MedicalCapability.get($capabilty.UUID)
		End if 
		If ($capabilty.UUID_MedicalStaff="")
			$capabilty.UUID_MedicalStaff:=$subForm.current_item.UUID
		End if 
		$eCapabilty.UUID_MedicalStaff:=$capabilty.UUID_MedicalStaff
		$eCapabilty.UUID_MedicalHouse:=$capabilty.UUID_MedicalHouse
		$eCapabilty.UUID_ConsultationKind:=$capabilty.UUID_ConsultationKind
		$eCapabilty.schedule:=$capabilty.schedule
		$eCapabilty.save()
		
	End for each 
End if 

//deletion of the removed capabilities
If ($subForm.uuid_capabilitiesToDelete#Null:C1517)
	For each ($uuid; $subForm.uuid_capabilitiesToDelete)
		$eCapabilty:=ds:C1482.MedicalCapability.get($uuid)
		If ($eCapabilty#Null:C1517)
			If ($eCapabilty#Null:C1517)
				$eCapabilty.drop()
			End if 
		End if 
	End for each 
End if 

If ($subForm.lb_appointments_toSave#Null:C1517)
	For each ($appointment; $subForm.lb_appointments_toSave)
		If ($subForm.lb_appointments_toDelete.indexOf($appointment.UUID)=-1)
			$entity:=ds:C1482[$appointment.dataclass].get($appointment.UUID)
			If ($entity=Null:C1517)
				$entity:=ds:C1482[$appointment.dataclass].new()
			End if 
			$entity.fromObject($appointment)
			$info:=$entity.save()
		End if 
	End for each 
	$subForm.lb_appointments_toSave:=New collection:C1472
End if 

If ($subForm.lb_appointments_toDelete#Null:C1517)
	For each ($uuidToDelete; $subForm.lb_appointments_toDelete)
		$entity:=ds:C1482.Appointment.get($uuidToDelete)
		If ($entity#Null:C1517)
			$entity.drop()
		End if 
	End for each 
	$subForm.lb_appointments_toDelete:=New collection:C1472()
End if 

$subForm.calendar.lastUUIDforDrawing:=""

$subForm:=$subForm