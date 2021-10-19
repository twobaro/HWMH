//%attributes = {}

var $template : Object

$isInModification:=sfw_checkIsInModification

$folder_itemType:=Get 4D folder:C485(Current resources folder:K5:16)+Replace string:C233("address/itemType/"; "/"; Folder separator:K24:12)
$json_string:=Document to text:C1236($folder_itemType+"itemType.json"; "UTF-8")
$obj_itemTypes:=JSON Parse:C1218($json_string)

$itemTypes:=$obj_itemTypes.types

If (Form:C1466.current_item.address_format.template#Null:C1517)
	$template:=Form:C1466.current_item.address_format.template
Else 
	$json:=Document to text:C1236($folder_itemType+"default_schema.json"; "UTF-8")
	$template:=JSON Parse:C1218($json)
End if 

$lines:=$template.lines

OBJECT SET VISIBLE:C603(*; "address_L@"; False:C215)
OBJECT SET TITLE:C194(*; "address_L@"; "-")

For ($numLine; 1; 7; 1)
	ARRAY TEXT:C222($_item; 0)
	If ($numLine<=$lines.length)
		
		$items:=$lines[$numLine-1].items
		$numColumn:=0
		For each ($item; $items)
			$numColumn:=$numColumn+1
			$btnName:="address_L"+String:C10($numLine)+"C"+String:C10($numColumn)
			$indices:=$itemTypes.indices("kind = :1"; $item)
			If ($indices.length>0)
				$icon:=$itemTypes[$indices[0]].icon
			Else 
				$icon:="street.png"
			End if 
			OBJECT SET VISIBLE:C603(*; $btnName; True:C214)
			If ($isInModification)
				OBJECT SET FORMAT:C236(*; $btnName; $item+";#address/itemType/"+$icon+";0;3;1;1;8;0;0;0;1;0;1")
			Else 
				OBJECT SET FORMAT:C236(*; $btnName; $item+";#address/itemType/"+$icon+";0;3;1;1;0;0;0;0;0;0;1")
			End if 
		End for each 
		
		For ($numColumn; $items.length+1; 4; 1)
			$btnName:="address_L"+String:C10($numLine)+"C"+String:C10($numColumn)
			OBJECT SET VISIBLE:C603(*; $btnName; ($numColumn=($items.length+1)) & $isInModification)
			If (($numColumn=($items.length+1)) & $isInModification)
				OBJECT SET FORMAT:C236(*; $btnName; "-;#address/itemType/question-white.png;0;3;1;1;8;0;0;0;1;0;1")
			End if 
		End for 
	Else 
		For ($numColumn; 1; 4; 1)
			$btnName:="address_L"+String:C10($numLine)+"C"+String:C10($numColumn)
			OBJECT SET VISIBLE:C603(*; $btnName; ($numColumn=1) & ($numLine=($lines.length+1)) & $isInModification)
			If (($numColumn=1) & ($numLine=($lines.length+1)) & $isInModification)
				OBJECT SET FORMAT:C236(*; $btnName; "-;#address/itemType/question-white.png;0;3;1;1;8;0;0;0;1;0;1")
			End if 
		End for 
	End if 
End for 