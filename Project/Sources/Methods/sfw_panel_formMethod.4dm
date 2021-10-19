//%attributes = {}
var $resetWidgetDesign : Boolean
var $runValidationRules : Boolean

$resetWidgetDesign:=False:C215
$runValidationRules:=False:C215
Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		$resetWidgetDesign:=True:C214
		$runValidationRules:=True:C214
		Form:C1466.canValidate:=True:C214
		FORM GET OBJECTS:C898($_objectNames)
		Form:C1466.useAddressSubSubForm:=(Find in array:C230($_objectNames; "address_subsubform")>0)
		Form:C1466.usePageTab:=(Find in array:C230($_objectNames; "page_tab")>0)
		Form:C1466.useHeaderBkgd:=(Find in array:C230($_objectNames; "header_bkgd")>0)
		Form:C1466.useTabBar:=(Find in array:C230($_objectNames; "vTabBar_subform")>0)
		
		If (Form:C1466.useTabBar)
			If (Form:C1466.vTabBar=Null:C1517)
				Form:C1466.vTabBar:=New object:C1471
			End if 
			
			Form:C1466.vTabBar.buttons:=Form:C1466.entry.panel.pages
			Form:C1466.vTabBar.currentPage:=Form:C1466.entry.panel.currentPage
		End if 
		
		If (Form:C1466.calculation=Null:C1517)
			Form:C1466.calculation:=New object:C1471
		End if 
		
		
	: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		$resetWidgetDesign:=True:C214
		$runValidationRules:=True:C214
		Form:C1466.canValidate:=True:C214
		
	: (FORM Event:C1606.code=On Data Change:K2:15)
		$runValidationRules:=True:C214
		Form:C1466.canValidate:=True:C214
		
		
End case 

OBJECT GET SUBFORM CONTAINER SIZE:C1148($width_subform; $height_subform)

If ($resetWidgetDesign)
	$isInModification:=sfw_checkIsInModification
	
	OBJECT SET ENTERABLE:C238(*; "@entryField@"; $isInModification)
	If ($isInModification)
		$runValidationRules:=True:C214
		OBJECT SET RGB COLORS:C628(*; "@entryField@"; "black"; Background color:K23:2)
		OBJECT SET BORDER STYLE:C1262(*; "@entryField@"; Border System:K42:33)
	Else 
		$runValidationRules:=False:C215
		OBJECT SET RGB COLORS:C628(*; "@entryField@"; 0x00333333; Background color none:K23:10)
		OBJECT SET BORDER STYLE:C1262(*; "@entryField@"; Border None:K42:27)
	End if 
End if 

If ($runValidationRules) & (Form:C1466.current_item#Null:C1517)
	If (Form:C1466.entry.validationRules#Null:C1517)
		OBJECT SET RGB COLORS:C628(*; "@entryField@"; "black"; Background color:K23:2)
		For each ($rule; Form:C1466.entry.validationRules)
			$type:=OB Get type:C1230(Form:C1466.current_item; $rule.field)
			If (Bool:C1537($rule.uppercase)) & ($type=Is text:K8:3) & (FORM Event:C1606.code=On Data Change:K2:15)
				Form:C1466.current_item[$rule.field]:=Uppercase:C13(Form:C1466.current_item[$rule.field])
			End if 
			If (Bool:C1537($rule.lowercase)) & ($type=Is text:K8:3) & (FORM Event:C1606.code=On Data Change:K2:15)
				Form:C1466.current_item[$rule.field]:=Lowercase:C14(Form:C1466.current_item[$rule.field])
			End if 
			
			If (Bool:C1537($rule.mandatory))
				Case of 
					: ($type=Is text:K8:3)
						If (Form:C1466.current_item[$rule.field]="")
							$widget:=String:C10($rule.widget)
							OBJECT SET RGB COLORS:C628(*; $widget; "black"; 0x00FAA9AB)
							Form:C1466.canValidate:=False:C215
						End if 
				End case 
			End if 
			
		End for each 
	End if 
End if 

If (Bool:C1537(Form:C1466.useAddressSubSubForm))
	If (FORM Event:C1606.code=On Load:K2:1) | (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		If (Form:C1466.addressSubForm=Null:C1517)
			Form:C1466.addressSubForm:=New object:C1471
		End if 
		
		If (Form:C1466.current_item#Null:C1517)
			If (Form:C1466.current_item.address#Null:C1517)
				Form:C1466.addressSubForm.address:=Form:C1466.current_item.address
			End if 
		End if 
		Form:C1466.addressSubForm.situation:=Form:C1466.situation
		Form:C1466.addressSubForm:=Form:C1466.addressSubForm
		
		OBJECT GET COORDINATES:C663(*; "address_subsubform"; $g; $h; $d; $b)
		OBJECT SET COORDINATES:C1248(*; "address_subsubform"; 5+(50*Num:C11(Bool:C1537(Form:C1466.useTabBar))); $h; $width_subform-5; $h+180)
		
	End if 
End if 

If (Bool:C1537(Form:C1466.usePageTab))
	OBJECT GET COORDINATES:C663(*; "page_tab"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "page_tab"; 0; $h; $width_subform; $b)
	OBJECT SET COORDINATES:C1248(*; "line_tab"; 0; ($b+$h)/2; $width_subform; ($b+$h)/2)
	
	
End if 

If (Bool:C1537(Form:C1466.useHeaderBkgd))
	OBJECT GET COORDINATES:C663(*; "header_bkgd"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "header_bkgd"; 0; 0; $width_subform; $b)
	
End if 

If (Bool:C1537(Form:C1466.useTabBar))
	OBJECT GET COORDINATES:C663(*; "vTabBar_subform"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "vTabBar_subform"; 0; $h; $d; $height_subform)
	
End if 

sfw_main_redraw_button

