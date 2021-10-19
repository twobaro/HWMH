$menu:=Create menu:C408()
APPEND MENU ITEM:C411($menu; "Private Lesson")
SET MENU ITEM PARAMETER:C1004($menu; -1; "PrivateLesson")

APPEND MENU ITEM:C411($menu; "Group Lesson")
SET MENU ITEM PARAMETER:C1004($menu; -1; "GroupLesson")


$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.current_appointment.dataclass:=$choose
		Form:C1466.lb_appointments:=Form:C1466.lb_appointments
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		$indices:=Form:C1466.lb_appointments_toSave.indices("UUID = :1"; Form:C1466.current_appointment.UUID)
		If ($indices.length>0)
			Form:C1466.lb_appointments_toSave[$indices[0]]:=Form:C1466.current_appointment
		Else 
			Form:C1466.lb_appointments_toSave.push(Form:C1466.current_appointment)
		End if 
End case 
