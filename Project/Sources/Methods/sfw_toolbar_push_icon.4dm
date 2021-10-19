//%attributes = {}
var $formData : Object
var $formEvent : Object
var $iconNum : Integer
var $refWindow : Integer


If (Not:C34(Is compiled mode:C492))
	sfw_definitions_load_from_disk
	$identVision:=Form:C1466.vision.ident
	Form:C1466.vision:=Storage:C1525.sfwDefinition.visions.query("ident = :1"; $identVision)[0]
	Form:C1466.entries:=Storage:C1525.sfwDefinition.entries.query("visions[] = :1"; $identVision)
End if 


$formEvent:=FORM Event:C1606
$iconNum:=Num:C11(Substring:C12($formEvent.objectName; 10))

$formData:=New object:C1471()
$formData.vision:=Form:C1466.vision
$formData.entry:=Form:C1466.entries[$iconNum-1]
Case of 
	: ($formData.entry.wizard#Null:C1517)
		$dialogName:=$formData.entry.wizard.panel
	Else 
		$dialogName:="sfw_main"
End case 

$refWindow:=Open form window:C675($dialogName; Plain form window:K39:10)
DIALOG:C40($dialogName; $formData; *)