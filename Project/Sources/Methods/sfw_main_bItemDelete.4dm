//%attributes = {}
CONFIRM:C162(\
sfw_xliff_read("deletion.message"; "Do you really want to delete this item?"); \
sfw_xliff_read("deletion.button.delete"; "Delete"); \
sfw_xliff_read("deletion.button.keep"; "Keep"))

If (ok=1)
	//$indexInEntitySelection:=Form.current_item.indexOf(Form.lb_items)
	Form:C1466.lb_items:=Form:C1466.lb_items.minus(Form:C1466.current_item)
	Form:C1466.current_item.drop()
	sfw_lb_items_sort
	Form:C1466.situation.mode:="view"
	Form:C1466.current_item:=Null:C1517
	Form:C1466.subForm.calculation:=New object:C1471
	Form:C1466.subForm:=Form:C1466.subForm
	
	sfw_lb_items_selectionChange
	sfw_main_draw_button
End if 