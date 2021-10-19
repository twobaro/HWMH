//%attributes = {}
$activeObjectName:=String:C10(FORM Event:C1606.objectName)

$isInModification:=sfw_checkIsInModification
$show_detail:=False:C215


If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadLbMembersForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadLbMembersForUUID:=Form:C1466.current_item.UUID
		If (Form:C1466.current_item.groupMembers#Null:C1517)
			Form:C1466.lb_members:=Form:C1466.current_item.groupMembers.toCollection("*, person.*").extract("UUID"; "UUID"; "UUID_Person"; "UUID_Person"; "UUID_Group"; "UUID_Group"; "startDate"; "startDate"; "endDate"; "endDate"; "person.civility"; "civility"; "person.lastName"; "lastName"; "person.firstName"; "firstName")
		Else 
			Form:C1466.lb_members:=New collection:C1472
		End if 
		Form:C1466.member_position:=0
	End if 
Else 
	If (Form:C1466.lb_members=Null:C1517)
		Form:C1466.lb_members:=New collection:C1472
	End if 
End if 

If (Num:C11(Form:C1466.member_position)=0)
	OBJECT SET VISIBLE:C603(*; "@member_@"; False:C215)
Else 
	OBJECT SET VISIBLE:C603(*; "@member_@"; True:C214)
End if 

If ($activeObjectName="lb_members") & ((FORM Event:C1606.code=On Selection Change:K2:29) | (FORM Event:C1606.code=On Clicked:K2:4))
	$initESPerson:=True:C214
End if 

If ($initESPersonGroup)
	Form:C1466.searchPersonES:=Null:C1517
	Form:C1466.searchPersonLastName:=""
	Form:C1466.searchPersonFirstName:=""
End if 
If (Form:C1466.member#Null:C1517) & ((FORM Event:C1606.code=On Clicked:K2:4) | (FORM Event:C1606.code=On Bound Variable Change:K2:52))
	$showDetail:=True:C214
End if 

If ($showDetail)
	Case of 
		: ($activeObjectName="member_@input@")
		Else 
			Form:C1466.inputPersonFirstName:=""
			Form:C1466.inputPersonLastName:=""
			If (Form:C1466.member.UUID_Person#("0"*32))
				$p:=ds:C1482.Person.get(Form:C1466.member.UUID_Person)
				If ($p#Null:C1517)
					Form:C1466.inputPersonFirstName:=$p.firstName
					Form:C1466.inputPersonLastName:=$p.lastName
				End if 
			End if 
			OBJECT SET ENABLED:C1123(*; "member_person_inputFirstName"; $isInModification)
			OBJECT SET ENABLED:C1123(*; "member_person_inputLastName"; $isInModification)
			
	End case 
	
	
	
End if 

If (Form:C1466.member#Null:C1517)
	OBJECT SET VISIBLE:C603(*; "pup_member_person"; $isInModification & (Form:C1466.searchPersonES#Null:C1517) & (Form:C1466.member#Null:C1517) & (Form:C1466.member_position#0))
	Case of 
		: (Form:C1466.member=Null:C1517)
			$state:="notVisible"
		: (String:C10(Form:C1466.member.UUID_Person)=("0"*32))
			$state:="error"
		: (($isInModification))
			$state:="modify"
		Else 
			$state:="visible"
	End case 
	sfw_colorize_inputField(New collection:C1472("member_person_inputFirstName"; "member_person_inputLastName"); $state)
	
End if 
OBJECT SET VISIBLE:C603(*; "pup_date@"; $isInModification & (Form:C1466.member#Null:C1517) & (Form:C1466.member_position#0))



$cadranVisible:=False:C215
$isNotFull:=True:C214
If (Num:C11(Form:C1466.current_item.maxMembers)>0)
	$cadranVisible:=True:C214
	(OBJECT Get pointer:C1124(Object named:K67:5; "CadranNbMembers")->):=Num:C11(Form:C1466.lb_members.length)/Num:C11(Form:C1466.current_item.maxMembers)*100
	$isNotFull:=Num:C11(Form:C1466.lb_members.length)<Num:C11(Form:C1466.current_item.maxMembers)
End if 
OBJECT SET VISIBLE:C603(*; "CadranNbMembers"; $cadranVisible)

OBJECT SET ENABLED:C1123(*; "bMemberAdd"; $isInModification & $isNotFull)
OBJECT SET ENABLED:C1123(*; "bMemberDelete"; (Form:C1466.member_position#0) & $isInModification)