If (String:C10(Form:C1466.member.UUID)#"")
	If (Form:C1466.uuid_membersToDelete=Null:C1517)
		Form:C1466.uuid_membersToDelete:=New collection:C1472
	End if 
	Form:C1466.uuid_membersToDelete.push(Form:C1466.member.UUID)
End if 
Form:C1466.lb_members:=Form:C1466.lb_members.remove(Form:C1466.member_position-1)
Form:C1466.lb_members:=Form:C1466.lb_members
Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
If (Form:C1466.member_position>Form:C1466.lb_members.length)
	Form:C1466.member_position:=Form:C1466.lb_members.length
End if 
LISTBOX SELECT ROW:C912(*; "lb_members"; Form:C1466.member_position; lk replace selection:K53:1)