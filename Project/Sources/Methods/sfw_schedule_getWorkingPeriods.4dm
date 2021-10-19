//%attributes = {}
#DECLARE ($date : Date; $itemUUID : Text)->$workingPeriods : Object

var $e : Object

$workingPeriods:=New object:C1471
$workingPeriods.date:=$date
$workingPeriods.itemUUID:=$itemUUID

MedicalHouse_load_cache

Case of 
	: (ds:C1482.MedicalStaff.get($itemUUID)#Null:C1517)
		ConsultationKind_load_cache
		$workingPeriods.isAMedicalStaff:=True:C214
		$capatabilityDataclass:="MedicalCapability"
		$kindDataclass:="ConsultationKind"
		$linkCapabilities:="medicalCapabilities"
		$fieldKindUUID:="UUID_ConsultationKind"
		$kindStorageAttribute:="consultationKind"
		
	: (ds:C1482.Coach.get($itemUUID)#Null:C1517)
		Activity_load_cache
		$workingPeriods.isACoach:=True:C214
		$capatabilityDataclass:="LessonCapabitiy"
		$kindDataclass:="Activity"
		$linkCapabilities:="lessonCapabilities"
		$fieldKindUUID:="UUID_Activity"
		$kindStorageAttribute:="activity"
		
End case 

$capabilities:=Form:C1466.current_item[$linkCapabilities]

$workingPeriods.medicalHouses:=New collection:C1472
$workingPeriods.kinds:=New collection:C1472
$workingPeriods.slots:=New collection:C1472
$workingPeriods.workingRanges:=New collection:C1472
For each ($capability; $capabilities)
	$workingRanges:=sfw_schedule_getWorkingRanges($date; $capability.schedule)
	If ($workingRanges.length>0)
		If ($workingPeriods.medicalHouses.query("UUID = :1"; $capability.UUID_MedicalHouse).length=0)
			$mhColl:=Storage:C1525.cache.medicalHouse.query("UUID = :1"; $capability.UUID_MedicalHouse).copy()
			$workingPeriods.medicalHouses:=$workingPeriods.medicalHouses.concat($mhColl)
		End if 
		If ($workingPeriods.kinds.query("UUID = :1"; $capability[$fieldKindUUID]).length=0)
			$kindColl:=Storage:C1525.cache[$kindStorageAttribute].query("UUID = :1"; $capability[$fieldKindUUID])
			$workingPeriods.kinds:=$workingPeriods.kinds.concat($kindColl)
		End if 
		$slot:=New object:C1471
		$slot.UUID_MedicalHouse:=$capability.UUID_MedicalHouse
		$slot.UUID_Kind:=$capability[$fieldKindUUID]
		$slot.workingRanges:=$workingRanges
		$workingPeriods.slots.push($slot)
	End if 
	$workingPeriods.workingRanges:=$workingPeriods.workingRanges.concat($workingRanges)
End for each 
$workingPeriods.medicalHouses:=$workingPeriods.medicalHouses.orderBy("name")
$workingPeriods.kinds:=$workingPeriods.kinds.orderBy("name")

$workingRanges:=$workingPeriods.workingRanges.copy()
$quarters:=sfw_quarters_fillWWorkingRanges($workingRanges; Form:C1466.lb_appointments)
$duration:=(96-$quarters.countValues(0))*900

//$duration:=0
//While ($workingRanges.length>0)
//$start:=$workingRanges.shift()
//$end:=$workingRanges.shift()
//$duration:=$duration+$end-$start
//End while 
$workingPeriods.workingDuration:=$duration