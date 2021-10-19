//%attributes = {}
#DECLARE ($quarters : Collection)->$max : Integer

$max:=0
$previous:=-1
$nb:=0
For each ($quarter; $quarters)
	If ($previous#$quarter)
		If ($previous=1)
			If ($nb>$max)
				$max:=$nb
			End if 
		End if 
		$previous:=$quarter
		$nb:=1
	Else 
		$nb:=$nb+1
	End if 
End for each 

