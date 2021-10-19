//%attributes = {}
// Appointment_FindSlots ( UUID_MedicalStaff; UUID_MedicalHouse; UUID_Person; UUID_ConsultationKind ; options)
// possible options : duration:integer, delay, integer, nbSlots, integer, date : date, dontMoveDate : boolean
#DECLARE ($UUID_MedicalStaff : Text; $UUID_MedicalHouse : Text; $UUID_Person : Text; $UUID_ConsultationKind : Text; $options : Object)->$slots : Collection


var $eMedicalCapabilities : cs:C1710.MedicalCapabilityEntity
var $esMedicalCapabilities : cs:C1710.MedicalCapabilitySelection
var $eAppointmentForTheDay : cs:C1710.AppointmentEntity
var $esAppointmentForTarget; $esAppointmentForTheDay : cs:C1710.AppointmentSelection
var $eSlot : cs:C1710.AppointmentEntity

var $appointment : Object
var $appointments : Collection

$slots:=New collection:C1472()

$duration:=(Num:C11($options.duration)\900)*900
If ($duration=0)
	$duration:=900
End if 
$delay:=Num:C11($options.delay)
$nbSlots:=Num:C11($options.nbSlots)
If ($nbSlots=0)
	$nbSlots:=1
End if 
If ($options.date#Null:C1517)
	$date:=Date:C102($options.date)
Else 
	$date:=Current date:C33
End if 
$dontMoveDate:=(Num:C11($options.dontMoveDate)=1)

$esMedicalCapabilities:=ds:C1482.MedicalCapability.query("UUID_MedicalStaff = :1 & UUID_MedicalHouse = :2 & UUID_ConsultationKind = :3"; $UUID_MedicalStaff; $UUID_MedicalHouse; $UUID_ConsultationKind)

While (Semaphore:C143("FindSlots"; 5000))
	IDLE:C311
End while 
$esAppointmentForTarget:=ds:C1482.Appointment.query("UUID_MedicalStaff = :1 & UUID_MedicalHouse = :2 & UUID_ConsultationKind = :3 & idStatus>-100"; $UUID_MedicalStaff; $UUID_MedicalHouse; $UUID_ConsultationKind).copy()  //to use .add after

$schedules:=$esMedicalCapabilities.schedule
If ($esMedicalCapabilities.length>0)
	$dateToStudy:=$date+$delay
	
	Repeat 
		
		If (sfw_schedule_isAWorkingDay($dateToStudy; $schedules))
			$workingRanges:=sfw_schedule_getWorkingRanges($dateToStudy; $schedules)
			If ($workingRanges.length>0)
				$from:=sfw_stmp_build($dateToStudy; ?00:00:00?)
				$to:=$from+86400
				$esAppointmentForTheDay:=$esAppointmentForTarget.query("startStmp >= :1 & startStmp < :2"; $from; $to)
				$appointments:=New collection:C1472
				For each ($eAppointmentForTheDay; $esAppointmentForTheDay)
					$appointment:=New object:C1471
					$appointment.date:=sfw_stmp_read_date($eAppointmentForTheDay.startStmp)
					$appointment.time:=sfw_stmp_read_time($eAppointmentForTheDay.startStmp)
					$appointment.duration:=$eAppointmentForTheDay.duration
					$appointments.push($appointment)
				End for each 
				$quarters:=sfw_quarters_fillWWorkingRanges($workingRanges; $appointments)
				$max:=sfw_schedule_getMaxIRQuarters($quarters)
				If ($max>=($duration/900))
					$index:=$quarters.indexOf(1)
					$time:=Time:C179($index*900)
					
					$eSlot:=ds:C1482.Appointment.new()
					$eSlot.UUID_MedicalStaff:=$UUID_MedicalStaff
					$eSlot.UUID_MedicalHouse:=$UUID_MedicalHouse
					$eSlot.UUID_ConsultationKind:=$UUID_ConsultationKind
					$eSlot.UUID_Person:=$UUID_Person
					$eSlot.startStmp:=sfw_stmp_build($dateToStudy; $time)
					$eSlot.duration:=$duration
					$eSlot.idStatus:=-1
					$eSlot.chronoStatus:=New object:C1471("histo"; New collection:C1472; "expiration"; sfw_stmp_build(Current date:C33; Current time:C178+?00:15:00?))
					$eSlot.save()
					$esAppointmentForTarget.add($eSlot)
					
					$slots.push($eSlot)
				Else 
					$dateToStudy:=$dateToStudy+1
				End if 
			Else 
				$dateToStudy:=$dateToStudy+1
			End if 
		Else 
			$dateToStudy:=$dateToStudy+1
		End if 
		$stop:=True:C214
		Case of 
			: ($dontMoveDate) & ($dateToStudy#($date+$delay))
				
				
			: ($slots.length>=$nbSlots)
			Else 
				$stop:=False:C215
		End case 
	Until ($stop)
	
	
End if 

CLEAR SEMAPHORE:C144("FindSlots")
