Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Form:C1466.member:=New object:C1471
Form:C1466.member.UUID_Group:=Form:C1466.current_item.UUID
Form:C1466.member.UUID_Person:=("0"*32)
Form:C1466.member.startDate:=Current date:C33
Form:C1466.member.endDate:=Add to date:C393(Current date:C33; 1; 0; 0)
Form:C1466.lb_members.push(Form:C1466.member)

Form:C1466.lb_members:=Form:C1466.lb_members

$position:=Form:C1466.lb_members.length
LISTBOX SELECT ROW:C912(*; "lb_members"; $position; lk replace selection:K53:1)
Form:C1466.member:=Form:C1466.lb_members[$position-1]
Form:C1466.member_position:=$position