//%attributes = {}
#DECLARE ($identVision : Text)

var $color : Text
var $entry : Object
var $i : Integer
var $iconNum : Integer
var $format : Text

Form:C1466.currentTB:=$identVision

Form:C1466.vision:=Storage:C1525.sfwDefinition.visions.query("ident = :1"; $identVision)[0]

$color:=Form:C1466.vision.toolbar.color

OBJECT SET RGB COLORS:C628(*; "bkgd_toolbar"; $color; $color)

Form:C1466.entries:=Storage:C1525.sfwDefinition.entries.query("visions[] = :1"; $identVision)

$format:=OBJECT Get format:C894(*; "bToolbar_1")
$iconNum:=1
For each ($entry; Form:C1466.entries)
	OBJECT SET FORMAT:C236(*; "bToolbar_"+String:C10($iconNum); sfw_xliff_read($entry.xliff; $entry.label)+";#"+$entry.icon+";0;0;0;1;0;0;0;0;0;0;1")
	OBJECT SET VISIBLE:C603(*; "bToolbar_"+String:C10($iconNum); True:C214)
	OBJECT SET HELP TIP:C1181(*; "bToolbar_"+String:C10($iconNum); sfw_xliff_read($entry.xliff; $entry.label))
	$iconNum:=$iconNum+1
End for each 
For ($i; $iconNum; 16)
	OBJECT SET VISIBLE:C603(*; "bToolbar_"+String:C10($i); False:C215)
End for 
