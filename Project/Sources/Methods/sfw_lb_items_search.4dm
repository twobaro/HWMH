//%attributes = {}
If (Form:C1466.searchbox="")
	Form:C1466.lb_items:=ds:C1482[Form:C1466.entry.dataclass].all().copy()
Else 
	$value:=Form:C1466.searchbox+"@"
	$querySettings:=New object:C1471
	$querySettings.parameters:=New object:C1471
	$queryCriteras:=New collection:C1472
	For each ($field; Form:C1466.entry.searchbox.fields)
		If ($field.fieldPlaceHolder#Null:C1517)
			$querySettings.parameters[$field.fieldPlaceHolder]:=$value
			$queryCriteras.push($field.attribute+" = :"+$field.fieldPlaceHolder)
		Else 
			$querySettings.parameters[$field.attribute]:=$value
			$queryCriteras.push($field.attribute+" = :"+$field.attribute)
		End if 
	End for each 
	$querystring:=$queryCriteras.join(" or ")
	Form:C1466.lb_items:=ds:C1482[Form:C1466.entry.dataclass].query($querystring; $querySettings).copy()
End if 

If (Form:C1466.entry.lb_items.counter#Null:C1517)
	$counterFormat:=Form:C1466.entry.lb_items.counter.format
	If (Form:C1466.lb_items.length=1)
		$counterFormat:=Replace string:C233($counterFormat; "^1"; sfw_xliff_read(Form:C1466.entry.lb_items.counter.unit1xliff; Form:C1466.entry.lb_items.counter.unit1))
	Else 
		$counterFormat:=Replace string:C233($counterFormat; "^1"; sfw_xliff_read(Form:C1466.entry.lb_items.counter.unitNxliff; Form:C1466.entry.lb_items.counter.unitN))
	End if 
Else 
	$counterFormat:="###,###,##0;;"
End if 
OBJECT SET FORMAT:C236(*; "lb_items_counter"; $counterFormat)
Form:C1466.current_item:=Null:C1517
sfw_lb_items_selectionChange

