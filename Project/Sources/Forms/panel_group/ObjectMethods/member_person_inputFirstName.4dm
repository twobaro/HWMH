var $es : cs:C1710.PersonSelection
var $e : cs:C1710.PersonEntity

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		Form:C1466.searchPersonFirstName:=Form:C1466.inputPersonFirstName
		$search:=Form:C1466.searchPersonFirstName+"@"
		
		Form:C1466.searchPersonES:=ds:C1482.Person.query("firstName = :1"; $search)
		If (Form:C1466.searchPersonES.length>0)
			$e:=Form:C1466.searchPersonES.first()
			Form:C1466.inputPersonLastName:=$e.lastName
			Form:C1466.inputPersonFirstName:=$e.firstName
			Form:C1466.member.UUID_Person:=$e.UUID
			Form:C1466.member.civility:=$e.civility
			Form:C1466.member.firstName:=$e.firstName
			Form:C1466.member.lastName:=$e.lastName
			Form:C1466.lb_members:=Form:C1466.lb_members
			
		Else 
			Form:C1466.searchPersonES:=Null:C1517
			Form:C1466.member.UUID_Person:="0"*32
		End if 
		OBJECT SET VISIBLE:C603(*; "pup_member_person"; sfw_checkIsInModification & (Form:C1466.searchPersonES#Null:C1517))
		
End case 
