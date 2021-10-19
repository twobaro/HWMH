//%attributes = {}
var $ep : cs:C1710.PersonEntity

ARRAY TEXT:C222($_file; 0)

$file:=Select document:C905(12345; ""; "Selectionner les fichiers d'import"; Use sheet window:K24:11; $_file)
If (ok=1)
	$text:=Document to text:C1236($_file{1}; "UTF-8")
	$persons:=JSON Parse:C1218($text)
	
	TRUNCATE TABLE:C1051([Person:3])
	$prg:=Progress New()
	$p:=0
	For each ($person; $persons)
		$p:=$p+1
		Progress SET PROGRESS($prg; $p/$persons.length; $person.lastName)
		
		Case of 
			: (ds:C1482.MedicalHouse.get($person.UUID)#Null:C1517)
			: (ds:C1482.MedicalStaff.get($person.UUID)#Null:C1517)
			: (ds:C1482.Coach.get($person.UUID)#Null:C1517)
			Else 
				$ep:=ds:C1482.Person.get($person.UUID)
				If ($ep=Null:C1517)
					$ep:=ds:C1482.Person.new()
					$ep.UUID:=$person.UUID
				End if 
				$ep.civility:=$person.civility
				$ep.lastName:=$person.lastName
				$ep.firstName:=$person.firstName
				$ep.address:=$person.address
				
				$ep.save()
		End case 
	End for each 
	Progress QUIT($prg)
End if 
