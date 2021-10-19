var $color : Text

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.searchbox:=""
		Form:C1466.subForm:=New object:C1471()
		Form:C1466.situation:=New object:C1471()
		Form:C1466.situation.isInModification:=False:C215
		
		Form:C1466.situation.mode:="view"  // modify, add, delete, view
		
		Form:C1466.subForm.vision:=Form:C1466.vision
		Form:C1466.subForm.entry:=Form:C1466.entry
		Form:C1466.subForm.situation:=Form:C1466.situation
		
		OBJECT SET VISIBLE:C603(*; "searchbox_@"; (Form:C1466.entry.searchbox#Null:C1517))
		OBJECT SET BORDER STYLE:C1262(*; "searchbox_roundRectangle"; Border None:K42:27)
		
		OBJECT SET FORMAT:C236(*; "bIcon_entry"; Form:C1466.entry.label+";#"+Form:C1466.entry.icon+";0;0;0;1;0;0;0;0;0;0;1")
		
		$color:=Form:C1466.vision.toolbar.color
		OBJECT SET RGB COLORS:C628(*; "bkgd_topBar"; $color; $color)
		
		Case of 
			: (Form:C1466.entry.dataclass#Null:C1517)
				sfw_lb_items_define
				
				sfw_lb_items_search
				sfw_lb_items_sort
				sfw_main_draw_button
				
				
				
			: (String:C10(Form:C1466.entry.virtual)="collection")
				
				sfw_virtual_lb_items_define
				sfw_virtual_lb_items_fill
				sfw_main_draw_button_virtual
				
		End case 
		
	: (FORM Event:C1606.code=On Resize:K2:27)
		Form:C1466.subForm:=Form:C1466.subForm
		
		
	: (FORM Event:C1606.code=On Close Box:K2:21)
		
		
		If (sfw_main_nothingToSaveOrCancel)
			ACCEPT:C269
		End if 
		
End case 


