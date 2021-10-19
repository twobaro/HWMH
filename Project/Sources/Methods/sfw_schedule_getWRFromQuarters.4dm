//%attributes = {}
#DECLARE ($quarters : Collection)->$workingRange : Collection

$previous:=-1
$workingRange:=New collection:C1472
For ($q; 0; 95)
	If ($previous#$quarters[$q])
		If ($previous=1)
			$qend:=$q
			$workingRange.push($qstart*900)
			$workingRange.push($qend*900)
		End if 
		$previous:=$quarters[$q]
		$qstart:=$q
	End if 
End for 

If ($previous=1)
	$qend:=$q
	$workingRange.push($qstart*900)
	$workingRange.push($qend*900)
End if 

