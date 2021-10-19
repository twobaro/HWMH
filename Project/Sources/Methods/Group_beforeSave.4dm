//%attributes = {}
#DECLARE ($subForm : Object)
var $eMember : cs:C1710.GroupMemberEntity
var $entity : 4D:C1709.Entity

//creation or update of the members 
If ($subForm.lb_members#Null:C1517)
	For each ($member; $subForm.lb_members)
		
		If (String:C10($member.UUID)="")  //if the uuid ist blank or not present, that's a new member
			$eMember:=ds:C1482.GroupMember.new()
		Else 
			$eMember:=ds:C1482.GroupMember.get($member.UUID)
		End if 
		If ($member.UUID_Group="")
			$member.UUID_Group:=$subForm.current_item.UUID
		End if 
		$eMember.UUID_Group:=$member.UUID_Group
		$eMember.UUID_Person:=$member.UUID_Person
		$eMember.startDate:=$member.startDate
		$eMember.endDate:=$member.endDate
		$eMember.save()
		
	End for each 
End if 

//deletion of the removed members
If ($subForm.uuid_membersToDelete#Null:C1517)
	For each ($uuid; $subForm.uuid_membersToDelete)
		$eMember:=ds:C1482.GroupMember.get($uuid)
		If ($eMember#Null:C1517)
			$eMember.drop()
		End if 
	End for each 
End if 


$subForm:=$subForm