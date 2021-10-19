//%attributes = {}
#DECLARE ($workingRangesParam : Collection)->$quarters : Collection

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