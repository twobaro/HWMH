//%attributes = {}
var $orderBy : Text
var $orderByFormula : Object

Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		If (sfw_main_nothingToSaveOrCancel)
			Form:C1466.previous_current_lb_item_pos:=Form:C1466.current_lb_item_pos
		Else 
			$pos:=Num:C11(Form:C1466.previous_current_lb_item_pos)
			LISTBOX SELECT ROW:C912(*; "lb_items"; $pos; lk replace selection:K53:1)
			Form:C1466.lb_items_dontPlayOnSelectionChange:=True:C214
		End if 
		
	: (FORM Event:C1606.code=On Selection Change:K2:29) & (Bool:C1537(Form:C1466.lb_items_dontPlayOnSelectionChange))
		Form:C1466.lb_items_dontPlayOnSelectionChange:=False:C215
		
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		If (Form:C1466.current_lb_item#Null:C1517)
			// current situation
			Form:C1466.current_item:=Form:C1466.current_lb_item
			sfw_lb_items_selectionChange
			
		Else 
			// after a deletion in another process
			If (Form:C1466.current_lb_item_pos>0)
				Form:C1466.lb_items:=Form:C1466.lb_items.slice(0; Form:C1466.current_lb_item_pos-1).or(Form:C1466.lb_items.slice(Form:C1466.current_lb_item_pos))
				sfw_lb_items_sort
				LISTBOX SELECT ROW:C912(*; "lb_items"; 0; lk remove from selection:K53:3)
			End if 
			sfw_lb_items_selectionChange
		End if 
		
	: (FORM Event:C1606.code=On Header Click:K2:40)
		$headerButton:=OBJECT Get pointer:C1124(Object named:K67:5; FORM Event:C1606.headerName)
		$columnNum:=Num:C11(Split string:C1554(FORM Event:C1606.headerName; "_").pop())
		$column:=Form:C1466.entry.lb_items.columns[$columnNum-1]
		
		$orderBy:=""
		If ($column.orderBy#Null:C1517)
			Case of 
				: ($column.orderBy.path#Null:C1517)
					$orderBy:=$column.orderBy.path
				: ($column.orderBy.formula#Null:C1517)
					$orderByFormula:=Formula from string:C1601($column.orderBy.formula)
			End case 
		Else 
			$orderBy:=$column.attribute
		End if 
		If ($orderByFormula=Null:C1517)
			Case of 
				: ($headerButton->=0) | ($headerButton->=2)
					$headerButton->:=1
					Form:C1466.lb_items:=Form:C1466.lb_items.orderBy($orderBy)
				: ($headerButton->=1)
					$orderBy:=$orderBy+" desc"
					$headerButton->:=2
					Form:C1466.lb_items:=Form:C1466.lb_items.orderBy($orderBy)
			End case 
		Else 
			Case of 
				: ($headerButton->=0) | ($headerButton->=2)
					$headerButton->:=1
					Form:C1466.lb_items:=Form:C1466.lb_items.orderByFormula($orderByFormula)
				: ($headerButton->=1)
					$headerButton->:=2
					Form:C1466.lb_items:=Form:C1466.lb_items.orderByFormula($orderByFormula; dk descending:K85:32)
			End case 
		End if 
		
End case 