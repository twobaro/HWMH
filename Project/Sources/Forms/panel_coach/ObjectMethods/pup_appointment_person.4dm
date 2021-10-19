

$menu:=Create menu:C408()

For each ($person; Form:C1466.searchPersonES)
	APPEND MENU ITEM:C411($menu; $person.firstName+" "+$person.lastName)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $person.UUID)
End for each 

$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)


Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.current_appointment.UUID_Person:=$choose
		Form:C1466.current_appointment.who:=Person_getFullName($choose)
		
		Form:C1466.lb_appointments:=Form:C1466.lb_appointments
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		$indices:=Form:C1466.lb_appointments_toSave.indices("UUID = :1"; Form:C1466.current_appointment.UUID)
		If ($indices.length>0)
			Form:C1466.lb_appointments_toSave[$indices[0]]:=Form:C1466.current_appointment
		Else 
			Form:C1466.lb_appointments_toSave.push(Form:C1466.current_appointment)
		End if 
End case 