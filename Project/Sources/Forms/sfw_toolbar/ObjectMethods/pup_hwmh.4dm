



$menuHWMH:=Create menu:C408

For each ($vision; Storage:C1525.sfwDefinition.visions)
	
	$label:=sfw_xliff_read($vision.xliff; $vision.label)
	APPEND MENU ITEM:C411($menuHWMH; $label)
	SET MENU ITEM PARAMETER:C1004($menuHWMH; -1; "--tb:"+$vision.ident)
	If (Form:C1466.currentTB=$vision.ident)
		SET MENU ITEM MARK:C208($menuHWMH; -1; Char:C90(18))
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($menuHWMH)
RELEASE MENU:C978($menuHWMH)

Case of 
	: ($choose="--tb:@")
		$params:=Split string:C1554($choose; ":")
		sfw_toolbar_draw($params[1])
		
		
		
End case 

