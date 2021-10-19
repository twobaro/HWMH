//%attributes = {}
OBJECT SET VISIBLE:C603(*; "bItem@"; False:C215)
OBJECT SET VISIBLE:C603(*; "bAction@"; False:C215)


$bModeFormat:=sfw_xliff_read("crud.mode.actions"; "Actions")+";#image/skin/rainbow/btn4states/action-32x32.png;;3;1;1;0;;;;1;;4"  //XLIFF
OBJECT SET FORMAT:C236(*; "bMode"; $bModeFormat)
OBJECT SET VISIBLE:C603(*; "bMode"; (Form:C1466.current_item.actions#Null:C1517))

