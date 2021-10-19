//%attributes = {}
#DECLARE ($date : Date)->$result : Text

$result:=""
Case of 
	: ($date=Current date:C33)
		$result:=Get localized string:C991("explo.date.today")
	: ($date=(Current date:C33-1))
		$result:=Get localized string:C991("explo.date.yesterday")
	: ($date=(Current date:C33-2))
		$result:=Get localized string:C991("explo.date.beforeyesterday")
	: ($date=(Current date:C33+1))
		$result:=Get localized string:C991("explo.date.tomorrow")
	: ($date=(Current date:C33+2))
		$result:="après-demain"
	: ($date>(Current date:C33-7)) & ($date<(Current date:C33-2))
		$jour:=Day number:C114($date)
		Case of 
			: ($Jour=1)
				$result:=Get localized string:C991("explo.date.sunday")
			: ($Jour=2)
				$result:=Get localized string:C991("explo.date.monday")
			: ($Jour=3)
				$result:=Get localized string:C991("explo.date.tuesday")
			: ($Jour=4)
				$result:=Get localized string:C991("explo.date.wednesday")
			: ($Jour=5)
				$result:=Get localized string:C991("explo.date.thursday")
			: ($Jour=6)
				$result:=Get localized string:C991("explo.date.friday")
			: ($Jour=7)
				$result:=Get localized string:C991("explo.date.saturday")
		End case 
		
	: ($date<(Current date:C33+7)) & ($date>(Current date:C33+2))
		$jour:=Day number:C114($date)
		Case of 
			: ($Jour=1)
				$result:=Get localized string:C991("explo.date.nextsunday")
			: ($Jour=2)
				$result:=Get localized string:C991("explo.date.nextmonday")
			: ($Jour=3)
				$result:=Get localized string:C991("explo.date.nexttuesday")
			: ($Jour=4)
				$result:=Get localized string:C991("explo.date.nextwednesday")
			: ($Jour=5)
				$result:=Get localized string:C991("explo.date.nextthursday")
			: ($Jour=6)
				$result:=Get localized string:C991("explo.date.nextfriday")
			: ($Jour=7)
				$result:=Get localized string:C991("explo.date.nextsaturday")
		End case 
	Else 
		$result:=String:C10($date; System date abbreviated:K1:2)
End case 

