

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
		Form:C1466.member.UUID_Person:=$choose
		$e:=ds:C1482.Person.get($choose)
		Form:C1466.member.civility:=$e.civility
		Form:C1466.member.firstName:=$e.firstName
		Form:C1466.member.lastName:=$e.lastName
		Form:C1466.lb_members:=Form:C1466.lb_members
		
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		
End case 