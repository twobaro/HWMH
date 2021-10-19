//%attributes = {}
#DECLARE ($stmp : Integer)->$nbSecondes : Integer


//%R-

$seconde:=$stmp%60
$Minute:=(Int:C8($stmp))%60
$heure:=(Int:C8($stmp/3600))%24
//%R+

$nbSecondes:=((($heure*60)+$minute)*60)+$seconde