//%attributes = {}
var $item : Object
var $xliff : Text

Form:C1466.lb_items:=Form:C1466.entry.items.copy()

For each ($item; Form:C1466.lb_items)
	$item.name:=sfw_xliff_read($item.xliff; $item.name)
End for each 