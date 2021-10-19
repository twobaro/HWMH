//%attributes = {}
Form:C1466.subForm.current_item:=Form:C1466.current_item
Form:C1466.subForm.current_item:=Form:C1466.current_item
If (Form:C1466.current_item#Null:C1517)
	OBJECT GET SUBFORM:C1139(*; "detail_panel"; $table; $current_panel)
	If ($current_panel#Form:C1466.current_item.panel.name)
		OBJECT SET SUBFORM:C1138(*; "detail_panel"; String:C10(Form:C1466.current_item.panel.name))  // String is mandatory to help the compilator
	Else 
		Form:C1466.subForm:=Form:C1466.subForm
	End if 
	
Else 
	OBJECT SET SUBFORM:C1138(*; "detail_panel"; "sfw_panel_default")
End if 

sfw_main_draw_button_virtual