//%attributes = {}
var $nil : Pointer
var $table : Pointer
var $current_panel : Text
var $i : Integer
var $column : Object

$i:=0
For each ($column; Form:C1466.entry.lb_items.columns)
	$i:=$i+1
	$columnType:=Is text:K8:3
	$columnFormula:="sfw_lb_items_highlight(This."+$column.attribute+")"
	Case of 
		: ($column.type=Null:C1517)
		: ($column.type="text")
			$columnType:=Is text:K8:3
			If ($column.formula=Null:C1517)
				$columnFormula:="sfw_lb_items_highlight(This."+$column.attribute+")"
			Else 
				$columnFormula:="sfw_lb_items_highlight("+$column.formula+")"
			End if 
		: ($column.type="picture")
			$columnType:=Is picture:K8:10
			If ($column.formula=Null:C1517)
				$columnFormula:="This."+$column.attribute
			Else 
				$columnFormula:=$column.formula
			End if 
	End case 
	LISTBOX INSERT COLUMN FORMULA:C970(*; "lb_items"; 1000; "col_"+String:C10($i); $columnFormula; $columnType; "header_"+String:C10($i); $nil)
	If ($columnType=Is text:K8:3)
		LISTBOX SET PROPERTY:C1440(*; "col_"+String:C10($i); lk multi style:K53:71; lk yes:K53:69)
	End if 
	OBJECT SET TITLE:C194(*; "header_"+String:C10($i); sfw_xliff_read($column.xliff; $column.label))
	If ($column.width#Null:C1517)
		LISTBOX SET COLUMN WIDTH:C833(*; "col_"+String:C10($i); Num:C11($column.width))
	End if 
End for each 
LISTBOX SET PROPERTY:C1440(*; "lb_items"; lk sortable:K53:45; lk no:K53:68)
OBJECT GET SUBFORM:C1139(*; "detail_panel"; $table; $current_panel)
If ($current_panel#"sfw_panel_default")
	OBJECT SET SUBFORM:C1138(*; "detail_panel"; "sfw_panel_default")
End if 

