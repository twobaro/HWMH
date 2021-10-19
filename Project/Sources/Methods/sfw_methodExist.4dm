//%attributes = {}
#DECLARE ($nameToTest : Text)->$exist : Boolean

ARRAY TEXT:C222($_names; 0)
METHOD GET NAMES:C1166($_names; $nameToTest)

$exist:=(Find in array:C230($_names; $nameToTest)>0)