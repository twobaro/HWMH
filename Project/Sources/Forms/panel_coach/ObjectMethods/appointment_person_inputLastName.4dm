var $es : cs:C1710.PersonSelection
var $e : cs:C1710.PersonEntity

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		Form:C1466.searchPersonLastName:=Form:C1466.inputPersonLastName
		$search:=Form:C1466.searchPersonLastName+"@"
		
		Form:C1466.searchPersonES:=ds:C1482.Person.query("lastName = :1"; $search)
		If (Form:C1466.searchPersonES.length>0)
			$e:=Form:C1466.searchPersonES.first()
			Form:C1466.inputPersonLastName:=$e.lastName
			Form:C1466.inputPersonFirstName:=$e.firstName
			Form:C1466.current_appointment.UUID_Person:=$e.UUID
			Form:C1466.current_appointment.who:=Person_getFullName($e)
			Form:C1466.lb_appointments:=Form:C1466.lb_appointments
			
		Else 
			Form:C1466.searchPersonES:=Null:C1517
			Form:C1466.current_appointment.UUID_Person:="0"*32
		End if 
		OBJECT SET VISIBLE:C603(*; "pup_appointment_person"; sfw_checkIsInModification & (Form:C1466.searchPersonES#Null:C1517))
		
End case 
