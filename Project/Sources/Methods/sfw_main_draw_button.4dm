//%attributes = {}

Case of 
	: (Form:C1466.current_item=Null:C1517)
		If (Form:C1466.lb_items.length=0)
			Form:C1466.situation.mode:="none"
		Else 
			Form:C1466.situation.mode:="view"
		End if 
End case 
Form:C1466.situation.changeToSaveOrCancel:=""

$visibleButtons:=New collection:C1472
$enableButtons:=New collection:C1472
Case of 
	: (Form:C1466.situation.mode="none")
		$bModeFormat:=sfw_xliff_read("crud.mode.chooseAMode"; "Choose a mode")+";#image/skin/rainbow/btn4states/mode-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
		If (Form:C1466.current_item#Null:C1517)
			$visibleButtons.push("bItemReload")
			$enableButtons.push("bItemReload")
		End if 
		
	: (Form:C1466.situation.mode="view")
		$bModeFormat:=sfw_xliff_read("crud.mode.visualization"; "Visualization")+";#image/skin/rainbow/btn4states/eye-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
		If (Form:C1466.current_item#Null:C1517)
			$visibleButtons.push("bItemReload")
			$enableButtons.push("bItemReload")
		End if 
		
	: (Form:C1466.situation.mode="add")
		$bModeFormat:=sfw_xliff_read("crud.mode.creation"; "Creation")+";#image/skin/rainbow/btn4states/add-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
		$visibleButtons.push("bItemRenounce")
		$visibleButtons.push("bItemCreate")
		$enableButtons.push("bItemRenounce")
		Form:C1466.situation.changeToSaveOrCancel:="add"
		If (Bool:C1537(Form:C1466.subForm.canValidate))
			$enableButtons.push("bItemCreate")
		End if 
		
	: (Form:C1466.situation.mode="delete")
		$bModeFormat:=sfw_xliff_read("crud.mode.deletion"; "Deletion")+";#image/skin/rainbow/btn4states/trash-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
		$visibleButtons.push("bItemDelete")
		$enableButtons.push("bItemDelete")
		
	Else 
		Form:C1466.situation.mode:="modify"
		$bModeFormat:=sfw_xliff_read("crud.mode.modification"; "Modification")+";#image/skin/rainbow/btn4states/edit-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
		$visibleButtons.push("bItemCancel")
		$visibleButtons.push("bItemSave")
		If (Form:C1466.current_item.touched())
			Form:C1466.situation.changeToSaveOrCancel:="modify"
			$enableButtons.push("bItemCancel")
			If (Bool:C1537(Form:C1466.subForm.canValidate))
				$enableButtons.push("bItemSave")
				
			End if 
		End if 
		
End case 
OBJECT SET FORMAT:C236(*; "bMode"; $bModeFormat)

OBJECT SET VISIBLE:C603(*; "bItem@"; False:C215)
OBJECT SET VISIBLE:C603(*; "bAction@"; False:C215)

OBJECT GET COORDINATES:C663(*; "bMode"; $gbMode; $hbMode; $dbMode; $bbmode)
OBJECT GET BEST SIZE:C717(*; "bMode"; $optimalWidth; $optimalHeight)
$optimalWidth:=$optimalWidth+10  //for the popup indicator
OBJECT SET COORDINATES:C1248(*; "bMode"; $gbMode; $hbMode; $gbMode+$optimalWidth; $bbmode)
$gapBITem:=10
$left:=$gbMode+$optimalWidth+$gapBITem
For each ($button; $visibleButtons)
	OBJECT SET VISIBLE:C603(*; $button; True:C214)
	OBJECT GET BEST SIZE:C717(*; $button; $optimalWidth; $optimalHeight)
	OBJECT SET COORDINATES:C1248(*; $button; $left; $hbMode; $left+$optimalWidth; $bbmode)
	$left:=$left+$optimalWidth+$gapBITem
End for each 

OBJECT SET ENABLED:C1123(*; "bItem@"; False:C215)
For each ($button; $enableButtons)
	OBJECT SET ENABLED:C1123(*; $button; True:C214)
End for each 


$nothingToSaveOrCancel:=(String:C10(Form:C1466.situation.changeToSaveOrCancel)="")
OBJECT SET ENABLED:C1123(*; "searchbox_cross"; $nothingToSaveOrCancel)
OBJECT SET ENTERABLE:C238(*; "searchbox_variable"; $nothingToSaveOrCancel)
OBJECT SET BORDER STYLE:C1262(*; "searchbox_roundRectangle"; Border None:K42:27)
If ($nothingToSaveOrCancel)
	OBJECT SET RGB COLORS:C628(*; "searchbox_roundRectangle"; "lightgrey"; "white")
Else 
	OBJECT SET RGB COLORS:C628(*; "searchbox_roundRectangle"; "lightgrey"; "#eaeaea")
End if 

