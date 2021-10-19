//%attributes = {}
#DECLARE ($workingRangesParam : Collection; $appointments : Collection)->$quarters : Collection

$workingRanges:=$workingRangesParam.copy()

$quarters:=New collection:C1472
$quarters[95]:=0
$quarters.fill(0)

While ($workingRanges.length>0)
	$start:=$workingRanges.shift()/900
	$end:=$workingRanges.shift()/900
	Repeat 
		$quarters[$start]:=1
		$start:=$start+1
	Until ($start>=$end)
End while 
$val:=2
If ($appointments#Null:C1517)
	For each ($appointment; $appointments)
		$start:=$appointment.time/900
		$end:=$start+($appointment.duration/900)
		Repeat 
			$quarters[$start]:=$val
			$start:=$start+1
		Until ($start>=$end)
		$val:=$val+1
	End for each 
End if 