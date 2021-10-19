//%attributes = {}
var $ePerson : cs:C1710.PersonEntity

$pyramideAges:=New collection:C1472

$pyramideAges.push(New object:C1471("ageMax"; 4; "man"; 2.7; "woman"; 2.6))
$pyramideAges.push(New object:C1471("ageMax"; 9; "man"; 3; "woman"; 2.9))
$pyramideAges.push(New object:C1471("ageMax"; 14; "man"; 3.1; "woman"; 3))
$pyramideAges.push(New object:C1471("ageMax"; 19; "man"; 3.1; "woman"; 3))
$pyramideAges.push(New object:C1471("ageMax"; 24; "man"; 2.8; "woman"; 2.7))
$pyramideAges.push(New object:C1471("ageMax"; 29; "man"; 2.7; "woman"; 2.8))
$pyramideAges.push(New object:C1471("ageMax"; 34; "man"; 2.9; "woman"; 3))
$pyramideAges.push(New object:C1471("ageMax"; 39; "man"; 3; "woman"; 3.2))
$pyramideAges.push(New object:C1471("ageMax"; 44; "man"; 2.9; "woman"; 3))
$pyramideAges.push(New object:C1471("ageMax"; 49; "man"; 3.3; "woman"; 3.3))
$pyramideAges.push(New object:C1471("ageMax"; 54; "man"; 3.2; "woman"; 3.3))
$pyramideAges.push(New object:C1471("ageMax"; 59; "man"; 3.1; "woman"; 3.3))
$pyramideAges.push(New object:C1471("ageMax"; 64; "man"; 2.9; "woman"; 3.2))
$pyramideAges.push(New object:C1471("ageMax"; 69; "man"; 2.7; "woman"; 3))
$pyramideAges.push(New object:C1471("ageMax"; 74; "man"; 2.4; "woman"; 2.8))
$pyramideAges.push(New object:C1471("ageMax"; 79; "man"; 1.4; "woman"; 1.8))
$pyramideAges.push(New object:C1471("ageMax"; 84; "man"; 1.1; "woman"; 1.6))
$pyramideAges.push(New object:C1471("ageMax"; 89; "man"; 0.7; "woman"; 1.3))
$pyramideAges.push(New object:C1471("ageMax"; 94; "man"; 0.2; "woman"; 0.7))
$pyramideAges.push(New object:C1471("ageMax"; 99; "man"; 0.06; "woman"; 0.3))

$cumulMan:=0
$cumulWoman:=0
For each ($tranche; $pyramideAges)
	$cumulMan:=$cumulMan+$tranche.man
	$cumulWoman:=$cumulWoman+$tranche.woman
	$tranche.cumulMan:=$cumulMan
	$tranche.cumulWoman:=$cumulWoman
End for each 


$cumulMaxMan:=$pyramideAges[$pyramideAges.length-1].cumulMan+0.1
$cumulMaxWoman:=$pyramideAges[$pyramideAges.length-1].cumulWoman+0.1
For each ($ePerson; ds:C1482.Person.all())
	If ($ePerson.civility="Mr")
		$attribute:="cumulMan"
		$cumulMax:=$cumulMaxMan
	Else 
		$attribute:="cumulWoman"
		$cumulMax:=$cumulMaxWoman
	End if 
	$random:=(Random:C100%($cumulMax*1000))/1000
	$tranches:=$pyramideAges.query($attribute+" < :1"; $random)
	If ($tranches.length<$pyramideAges.length)
		$ageMax:=$pyramideAges[$tranches.length+1].ageMax
		$ageMin:=$ageMax-4
	Else 
		$ageMin:=100
		$ageMax:=104
	End if 
	
	$yearBirth:=Year of:C25(Current date:C33)-(Random:C100%5)-$ageMin
	$birthdate:=Add to date:C393(!00-00-00!; $yearBirth; 1; (Random:C100%365)+1)
	If ($birthdate>Current date:C33)
		$birthdate:=$birthdate-365
	End if 
	$ePerson.birthdate:=$birthdate
	$ePerson.save()
End for each 
