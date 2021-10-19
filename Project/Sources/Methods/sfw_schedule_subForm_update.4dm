//%attributes = {}
#DECLARE ($source : Object)

If (FORM Event:C1606.code=On Clicked:K2:4)
	
	$scheduleSubFormAttribute:="scheduleSubForm"
	For ($i; 2; Count parameters:C259)
		$param:=${$i}
		Case of 
			: ($param="notEditable")
				Form:C1466[$scheduleSubFormAttribute].notEditable:=True:C214
			: ($param="attribute:@")
				$scheduleSubFormAttribute:=Split string:C1554($param; ":").pop()
		End case 
	End for 
	
	Form:C1466[$scheduleSubFormAttribute].current_item:=Form:C1466.current_item
	Form:C1466[$scheduleSubFormAttribute].situation:=Form:C1466.situation
	
	
	If ($source#Null:C1517)
		Form:C1466[$scheduleSubFormAttribute].schedule:=$source.schedule
		If ($source.schedule=Null:C1517)
			$source.schedule:=New object:C1471
		End if 
		Form:C1466[$scheduleSubFormAttribute].isNewSelection:=True:C214
		
	Else 
		Form:C1466[$scheduleSubFormAttribute].schedule:=New object:C1471()
	End if 
	
	Form:C1466[$scheduleSubFormAttribute]:=Form:C1466[$scheduleSubFormAttribute]
End if 