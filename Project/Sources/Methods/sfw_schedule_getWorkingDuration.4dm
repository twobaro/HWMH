//%attributes = {}
#DECLARE ($workingRangesParam : Collection)->$workingDuration : Integer

$quarters:=sfw_schedule_getWorkingQuarters($workingRangesParam)

$workingDuration:=$quarters.countValues(1)*900