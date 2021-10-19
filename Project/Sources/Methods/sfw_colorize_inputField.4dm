//%attributes = {}
#DECLARE ($inputFieldParam : Variant; $state : Text)

Case of 
	: (Value type:C1509($inputFieldParam)=Is text:K8:3)
		$inputFields:=New collection:C1472($inputFieldParam)
	: (Value type:C1509($inputFieldParam)=Is collection:K8:32)
		$inputFields:=$inputFieldParam
End case 

Case of 
	: ($state="visible")
		For each ($inputField; $inputFields)
			OBJECT SET RGB COLORS:C628(*; $inputField; "black"; Background color none:K23:10)
			OBJECT SET BORDER STYLE:C1262(*; $inputField; Border None:K42:27)
		End for each 
		
	: ($state="modify")
		For each ($inputField; $inputFields)
			OBJECT SET RGB COLORS:C628(*; $inputField; "black"; Background color:K23:2)
			OBJECT SET BORDER STYLE:C1262(*; $inputField; Border System:K42:33)
		End for each 
		
	: ($state="error")
		For each ($inputField; $inputFields)
			OBJECT SET RGB COLORS:C628(*; $inputField; "black"; 0x00FAA9AB)
			OBJECT SET BORDER STYLE:C1262(*; $inputField; Border System:K42:33)
		End for each 
		//
	Else 
		For each ($inputField; $inputFields)
			OBJECT SET RGB COLORS:C628(*; $inputField; "black"; Background color none:K23:10)
			OBJECT SET BORDER STYLE:C1262(*; $inputField; Border None:K42:27)
		End for each 
End case 