//%attributes = {}


Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		Form:C1466.previous_current_lb_item_pos:=Form:C1466.current_lb_item_pos
		
	: (FORM Event:C1606.code=On Selection Change:K2:29) & (Bool:C1537(Form:C1466.lb_items_dontPlayOnSelectionChange))
		Form:C1466.lb_items_dontPlayOnSelectionChange:=False:C215
		
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		Form:C1466.current_item:=Form:C1466.current_lb_item
		sfw_virtual_lb_items_selChange
		
		
End case 