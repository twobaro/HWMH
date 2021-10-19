//%attributes = {}
#DECLARE ()->$stmp : Integer
var $heure_en_seconde; $seconde; $minute_en_seconde; $jours_en_seconde : Integer

$date_ref:=Current date:C33
$heure_ref:=Current time:C178

$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)
$heure_en_seconde:=$heure_ref+0
$jours_en_seconde:=($date_ref-$date_reference)*86400

$seconde:=$jours_en_seconde+$heure_en_seconde
