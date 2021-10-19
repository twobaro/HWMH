//%attributes = {}
// sfw_stmp_build (date : date ; time : time ) -> Integer

#DECLARE ($date : Date; $heure : Time)->$stmp : Integer

var $heure_en_seconde; $seconde; $minute_en_seconde; $jours_en_seconde : Integer

Case of 
	: (Count parameters:C259=0)
		$date:=Current date:C33
		$heure:=Current time:C178
	: (Count parameters:C259=1)
		$heure:=Current time:C178
End case 

$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)
$heure_en_seconde:=$heure+0
$jours_en_seconde:=($date-$date_reference)*86400

$stmp:=$jours_en_seconde+$heure_en_seconde
