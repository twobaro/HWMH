//%attributes = {}
#DECLARE ($medicalStaff : cs:C1710.MedicalStaffEntity)->$fullName

$parts:=New collection:C1472($medicalStaff.firstName; $medicalStaff.lastName)
$fullName:=$parts.join(" "; ck ignore null or empty:K85:5)