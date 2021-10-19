

$menu:=Create menu:C408()


APPEND MENU ITEM:C411($menu; sfw_xliff_read("dateAndTime.duration.onemonth"; "one month"))
SET MENU ITEM PARAMETER:C1004($menu; -1; "1M")

APPEND MENU ITEM:C411($menu; sfw_xliff_read("dateAndTime.duration.threemonths"; "three month"))
SET MENU ITEM PARAMETER:C1004($menu; -1; "3M")

APPEND MENU ITEM:C411($menu; sfw_xliff_read("dateAndTime.duration.sixmonths"; "six month"))
SET MENU ITEM PARAMETER:C1004($menu; -1; "6M")

APPEND MENU ITEM:C411($menu; sfw_xliff_read("dateAndTime.duration.ninemonths"; "nine month"))
SET MENU ITEM PARAMETER:C1004($menu; -1; "9M")

APPEND MENU ITEM:C411($menu; sfw_xliff_read("dateAndTime.duration.oneyear"; "one year"))
SET MENU ITEM PARAMETER:C1004($menu; -1; "1Y")

$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)


Case of 
	: ($choose="")
	: ($choose="1M")
		Form:C1466.member.endDate:=Add to date:C393(Form:C1466.member.startDate; 0; 1; 0)
	: ($choose="3M")
		Form:C1466.member.endDate:=Add to date:C393(Form:C1466.member.startDate; 0; 3; 0)
	: ($choose="6M")
		Form:C1466.member.endDate:=Add to date:C393(Form:C1466.member.startDate; 0; 6; 0)
	: ($choose="9M")
		Form:C1466.member.endDate:=Add to date:C393(Form:C1466.member.startDate; 0; 9; 0)
	: ($choose="1Y")
		Form:C1466.member.endDate:=Add to date:C393(Form:C1466.member.startDate; 1; 0; 0)
End case 
Form:C1466.lb_members:=Form:C1466.lb_members
Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
