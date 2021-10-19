var $es : cs:C1710.PersonSelection
var $e : cs:C1710.PersonEntity


Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		
End case 

