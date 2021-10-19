//%attributes = {}
#DECLARE ($stmp : Integer)->$answer : Text

$answer:=""
$now:=sfw_stmp_now
If ($now-$stmp<(24*60*60))
	$answer:=sfw_stmp_duration_relative($now-$stmp; 1)
Else 
	$answer:=sfw_stmp_date_relative($stmp)
End if 