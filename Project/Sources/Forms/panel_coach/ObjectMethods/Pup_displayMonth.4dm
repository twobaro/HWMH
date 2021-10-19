$refmenus:=New collection:C1472()
$menu:=Create menu:C408
$refmenus.push($menu)
$m:=0
For each ($month; Form:C1466.months)
	$m:=$m+1
	APPEND MENU ITEM:C411($menu; $month)
	$ref:=String:C10($m; "00")
	SET MENU ITEM PARAMETER:C1004($menu; -1; $ref)
End for each 


$ref:=Dynamic pop up menu:C1006($menu)

For each ($menu; $refmenus)
	RELEASE MENU:C978($menu)
End for each 

Case of 
	: ($ref="")
	: ($ref#"")
		Form:C1466.calendar.display.month:=Num:C11($ref)
		Form:C1466.calendar.display.date:=Add to date:C393(!00-00-00!; Form:C1466.calendar.display.year; Form:C1466.calendar.display.month; Form:C1466.calendar.display.day)
		Form:C1466.calendar.display.year:=Year of:C25(Form:C1466.calendar.display.date)
		Form:C1466.calendar.display.month:=Month of:C24(Form:C1466.calendar.display.date)
		Form:C1466.calendar.display.day:=Day of:C23(Form:C1466.calendar.display.date)
		
End case 
