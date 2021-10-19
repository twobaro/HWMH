//%attributes = {}

If (Form:C1466.UUID_ConsultationKind="")
	OBJECT SET TITLE:C194(*; "Pup_consultationKind"; sfw_xliff_read("consultationKind.selectAConsultationKind"; "Select a consultation kind"))
	Form:C1466.objects.Pup_medicalHouse.disabled:=True:C214
Else 
	OBJECT SET TITLE:C194(*; "Pup_consultationKind"; ConsultationKind_getFromCache(Form:C1466.UUID_ConsultationKind).name)
	Form:C1466.objects.Pup_medicalHouse.disabled:=False:C215
	
	$UUIDMedicalHouses:=ds:C1482.MedicalCapability.query("UUID_ConsultationKind = :1"; Form:C1466.UUID_ConsultationKind).medicalHouse.UUID
	If ($UUIDMedicalHouses.indexOf(Form:C1466.UUID_MedicalHouse)=-1)
		Form:C1466.UUID_MedicalHouse:=""
	End if 
End if 

If (Form:C1466.UUID_MedicalHouse="")
	OBJECT SET TITLE:C194(*; "Pup_medicalHouse"; sfw_xliff_read("medicalHouse.selectAMedicalHouse"; "Select a medical house"))
	Form:C1466.objects.Pup_medicalStaff.disabled:=True:C214
Else 
	OBJECT SET TITLE:C194(*; "Pup_medicalHouse"; MedicalHouse_getFromCache(Form:C1466.UUID_MedicalHouse).name)
	Form:C1466.objects.Pup_medicalStaff.disabled:=False:C215
	
End if 

If (Form:C1466.UUID_MedicalStaff="")
	OBJECT SET TITLE:C194(*; "Pup_medicalStaff"; sfw_xliff_read("medicalStaff.selectADoctor"; "Select a doctor"))
Else 
	OBJECT SET TITLE:C194(*; "Pup_medicalStaff"; MedicalStaff_getFullName(ds:C1482.MedicalStaff.get(Form:C1466.UUID_MedicalStaff)))
	
	$UUIDMedicalStaff:=ds:C1482.MedicalCapability.query("UUID_ConsultationKind = :1 & UUID_MedicalHouse = :2"; Form:C1466.UUID_ConsultationKind; Form:C1466.UUID_MedicalHouse).medicalStaff.UUID
	If ($UUIDMedicalStaff.indexOf(Form:C1466.UUID_MedicalStaff)=-1)
		Form:C1466.UUID_MedicalStaff:=""
	End if 
	
End if 

For each ($object; Form:C1466.objects)
	
	OBJECT SET ENABLED:C1123(*; $object; Not:C34(Bool:C1537(Form:C1466.objects[$object].disabled)))
	
End for each 


OBJECT SET VISIBLE:C603(*; "pup_person"; (Form:C1466.searchPersonES#Null:C1517))
If (Form:C1466.UUID_Person#"")
	$e:=ds:C1482.Person.get(Form:C1466.UUID_Person)
	Form:C1466.inputPersonLastName:=$e.lastName
	Form:C1466.inputPersonFirstName:=$e.firstName
Else 
	Form:C1466.inputPersonLastName:=""
	Form:C1466.inputPersonFirstName:=""
End if 

OBJECT SET TITLE:C194(*; "pup_duration"; String:C10(Time:C179(Form:C1466.duration); HH MM:K7:2))

For each ($oSlot; Form:C1466.lb_slots)
	$entity:=$oSlot.entity
	$entity.drop()
End for each 
Form:C1466.lb_slots:=New collection:C1472

$calculateSlots:=False:C215
Case of 
	: (Form:C1466.UUID_MedicalStaff="")
	: (Form:C1466.UUID_MedicalHouse="")
	: (Form:C1466.UUID_Person="")
	: (Form:C1466.UUID_ConsultationKind="")
	Else 
		$calculateSlots:=True:C214
End case 

If ($calculateSlots)
	$options:=New object:C1471
	$options.duration:=Form:C1466.duration
	$options.date:=Form:C1466.dateFrom
	$options.nbSlots:=10
	$options.dontMoveDate:=Bool:C1537(Form:C1466.onlyThisDate)
	$slots:=Appointment_FindSlots(Form:C1466.UUID_MedicalStaff; Form:C1466.UUID_MedicalHouse; Form:C1466.UUID_Person; Form:C1466.UUID_ConsultationKind; $options)
	For each ($slot; $slots)
		$oSlot:=New object:C1471
		$oSlot.entity:=$slot
		$oSlot.date:=sfw_stmp_read_date($slot.startStmp)
		$oSlot.time:=sfw_Time(sfw_stmp_read_time($slot.startStmp)+0)
		Form:C1466.lb_slots.push($oSlot)
	End for each 
	Form:C1466.lb_slots:=Form:C1466.lb_slots
	LISTBOX SELECT ROW:C912(*; "lb_slots"; 0; lk replace selection:K53:1)
	Form:C1466.current_slot:=Null:C1517
	Form:C1466.current_slot_position:=0
End if 

OBJECT SET ENABLED:C1123(*; "bSave"; (Num:C11(Form:C1466.current_slot_position)#0))
