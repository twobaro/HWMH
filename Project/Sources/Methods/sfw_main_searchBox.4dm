//%attributes = {}
Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		sfw_lb_items_search
		sfw_lb_items_sort
		
		
	: (FORM Event:C1606.code=On Getting Focus:K2:7)
		OBJECT SET BORDER STYLE:C1262(*; "searchbox_roundRectangle"; Border Plain:K42:28)
		$focusRingColor:="#60A9EF"
		If (Form:C1466.vision.toolbar.focusRing#Null:C1517)
			$focusRingColor:=String:C10(Form:C1466.vision.toolbar.focusRing)
		End if 
		OBJECT SET RGB COLORS:C628(*; "searchbox_roundRectangle"; $focusRingColor; "white")
	: (FORM Event:C1606.code=On Losing Focus:K2:8)
		OBJECT SET BORDER STYLE:C1262(*; "searchbox_roundRectangle"; Border None:K42:27)
End case 
