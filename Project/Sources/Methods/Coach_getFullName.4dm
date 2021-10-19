//%attributes = {}
#DECLARE ($coach : cs:C1710.CoachEntity)->$fullName

$parts:=New collection:C1472($coach.firstName; $coach.lastName)
$fullName:=$parts.join(" "; ck ignore null or empty:K85:5)