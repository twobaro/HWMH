//%attributes = {}
#DECLARE($index : Integer)->$color : Text

$colors:=New collection:C1472


$colors.push("#E67E22")
$colors.push("#85C1E9")
$colors.push("#C39BD3")
$colors.push("#F5B7B1")
$colors.push("#5499C7")
$colors.push("#DC7633")
$colors.push("#F1C40F")
$colors.push("#618a9c")
$colors.push("#ef5a78")
$colors.push("#f89a1c")
$colors.push("#c09e3d")
$colors.push("#faef07")
$colors.push("#9cd1bd")
$colors.push("#dfd284")
$colors.push("#4eb947")
$colors.push("#b8a181")
$colors.push("#ef2d36")
$colors.push("#df9846")
$colors.push("#b65671")
$colors.push("#97839c")

$nbColors:=$colors.length
Case of 
	: ($index=1)
		$color:="#E5E7E9"
	Else 
		$color:=$colors[$index%$nbColors]
End case 
