//%attributes = {}
var $eStaff : cs:C1710.MedicalStaffEntity
var $eAppointment : cs:C1710.AppointmentEntity
var $esMedicalStaff : cs:C1710.MedicalStaffSelection
var $eMedicalStaff : cs:C1710.MedicalStaffEntity
var $esMedicalHouse : cs:C1710.MedicalHouseSelection
var $esPerson : cs:C1710.PersonSelection
var $ePerson : cs:C1710.PersonEntity

var $consultationKinds : Collection
var $consultationKind : Object

$definitionFolder:=Folder:C1567(fk resources folder:K87:11).folder("sfw/definition")
$file:=$definitionFolder.file("appointments_generator.json")
$text:=$file.getText()

//$jsonBrut:=JSON Parse($text)

//$consultationKinds:=$jsonBrut.consultationKinds

//$bankHolidays:=New collection
//For each ($stringDate; $jsonBrut.bankHolidays)
//$segments:=Split string($stringDate; "/")
//$date:=Add to date(!00-00-00!; Num($segments[0]); Num($segments[1]); Num($segments[2]))
//$bankHolidays.push($date)
//End for each 

$dateStart:=!2020-01-01!
$nbOfDateToGenerate:=Current date:C33-$dateStart+100
$randomFormula:=Formula:C1597(Random:C100)
TRUNCATE TABLE:C1051([Appointment:2])

$pCK:=Progress New
$pMS:=Progress New
$pDate:=Progress New
Progress SET PROGRESS($pDate; 0; "")
$ipCK:=0
For each ($consultationKind; $consultationKinds)
	$ipCK:=$ipCK+1
	Progress SET PROGRESS($pCK; $ipCK/$consultationKinds.length; $consultationKind.name)
	$esMedicalStaff:=ds:C1482.ConsultationKind.get($consultationKind.UUID).medicalCapabilities.medicalStaff
	
	$ipMS:=0
	For each ($eMedicalStaff; $esMedicalStaff)
		$ipMS:=$ipMS+1
		Progress SET PROGRESS($pMS; $ipMS/$esMedicalStaff.length; $eMedicalStaff.lastName)
		$esMedicalHouse:=$eMedicalStaff.medicalCapabilities.query("UUID_ConsultationKind = :1"; $consultationKind.UUID).medicalHouse
		$nbPatientsMin:=$consultationKind.nbPatients[0]
		$nbPatientsMax:=$consultationKind.nbPatients[1]
		$nbPatients:=(Random:C100%($nbPatientsMax-$nbPatientsMin+1))+$nbPatientsMin
		$appointmentTargets:=New collection:C1472
		While ($appointmentTargets.length<$nbPatients)
			$mhIndices:=Random:C100%($esMedicalHouse.length)
			$mhCity:=$esMedicalHouse[$mhIndices].address.address[0].detail.city
			$esPerson:=ds:C1482.Person.query("address.address[].detail.city = :1"; $mhCity)
			$esPersonWithAppointment:=ds:C1482.Appointment.query("UUID_ConsultationKind = :1"; $consultationKind.UUID).person
			$esPerson:=$esPerson.minus($esPersonWithAppointment).orderByFormula($randomFormula)
			$i:=-1
			Repeat 
				$i:=$i+1
				$stop:=True:C214
				Case of 
					: ($i>=$esPerson.length)
					: ($appointmentTargets.countValues($esPerson[$i].UUID; "UUID_Person")=0)
					Else 
						$stop:=False:C215
				End case 
			Until ($stop)
			If ($i<$esPerson.length)
				$appointmentTarget:=New object:C1471
				$appointmentTarget.UUID_Person:=$esPerson[$i].UUID
				$appointmentTarget.UUID_MedicalHouse:=$esMedicalHouse[$mhIndices].UUID
				$appointmentTarget.UUID_MedicalStaff:=$eMedicalStaff.UUID
				$appointmentTarget.nextDate:=$dateStart+2+(Random:C100%10)
				$appointmentTargets.push($appointmentTarget)
			End if 
		End while 
		
		
		$dateToTreat:=$dateStart
		$dateStop:=$dateToTreat+$nbOfDateToGenerate
		$ipDate:=0
		While ($dateToTreat<$dateStop)
			$ipDate:=$ipDate+1
			Progress SET PROGRESS($pDate; $ipDate/$nbOfDateToGenerate; String:C10($dateToTreat))
			
			
			//gestion de quelques annulations
			$from:=sfw_stmp_build($dateToTreat; ?00:00:00?)
			$esAppointmentCancellable:=ds:C1482.Appointment.query("UUID_MedicalStaff = :1 & UUID_MedicalHouse = :2 & UUID_ConsultationKind = :3 & UUID_Person = :4 & startStmp > :5 & idStatus=1"; $appointmentTarget.UUID_MedicalStaff; $appointmentTarget.UUID_MedicalHouse; $consultationKind.UUID; $appointmentTarget.UUID_Person; $from)
			If ($esAppointmentCancellable.length>0)
				For each ($eAppointment; $esAppointmentCancellable)
					If (Random:C100%400=0)
						$chrono:=New object:C1471
						$chrono.status:=-111-Num:C11(Random:C100%10=0)
						$chrono.date:=$dateToTreat
						$chrono.stmp:=sfw_stmp_build($dateToTreat; ?00:00:00?)+(5*3600)+(Random:C100%22000)+(Random:C100%22000)
						$chrono.origin:=1+Num:C11(Random:C100%5=0)+Num:C11(Random:C100%4=0)
						$eAppointment.idStatus:=$chrono.status
						$eAppointment.chronoStatus.histo.push($chrono)
						$eAppointment.chronoStatus:=$eAppointment.chronoStatus
						$info:=$eAppointment.save()
					End if 
				End for each 
			End if 
			
			$appointmentsByDay:=$consultationKind.appointmentsByDay
			$appointmentsToSet:=New collection:C1472
			For each ($appointmentByDay; $appointmentsByDay)
				$nbMin:=$appointmentByDay.nbByDays[0]
				$nbMax:=$appointmentByDay.nbByDays[1]
				$nbToSet:=(Random:C100%($nbMax-$nbMin+1))+$nbMin
				$appointmentToSet:=New object:C1471
				$appointmentToSet.duration:=$appointmentByDay.duration
				$appointmentToSet.delay:=$appointmentByDay.delay
				For ($i; 1; $nbToSet)
					$appointmentToSet:=OB Copy:C1225($appointmentToSet)
					$appointmentToSet.random:=Random:C100
					$appointmentsToSet.push($appointmentToSet)
				End for 
			End for each 
			$appointmentsToSet:=$appointmentsToSet.orderBy("random")
			
			$appointmentTargetsToTreat:=$appointmentTargets.query("nextDate <= :1"; $dateToTreat).orderBy("nextDate")
			
			$indice:=0
			While ($indice<$appointmentsToSet.length) & ($indice<$appointmentTargetsToTreat.length)
				$appointmentTarget:=$appointmentTargetsToTreat[$indice]
				$appointmentToSet:=$appointmentsToSet[$indice]
				$options:=New object:C1471
				$options.delay:=$appointmentToSet.delay
				$options.duration:=$appointmentToSet.duration
				$options.date:=$dateToTreat
				$slots:=Appointment_FindSlots($appointmentTarget.UUID_MedicalStaff; $appointmentTarget.UUID_MedicalHouse; $appointmentTarget.UUID_Person; $consultationKind.UUID; $options)
				$eSlot:=$slots.shift()
				$eSlot.idStatus:=1
				
				$chrono:=New object:C1471
				$chrono.status:=1
				$chrono.date:=$dateToTreat
				$chrono.stmp:=sfw_stmp_build($dateToTreat; ?00:00:00?)+(5*3600)+(Random:C100%22000)+(Random:C100%22000)
				$chrono.origin:=1+Num:C11(Random:C100%5=0)+Num:C11(Random:C100%4=0)
				$eSlot.chronoStatus.histo.push($chrono)
				$eSlot.chronoStatus:=$eSlot.chronoStatus
				OB REMOVE:C1226($eSlot.chronoStatus; "expiration")
				$info:=$eSlot.save()
				
				$appointmentTarget.nextDate:=sfw_stmp_read_date($eSlot.startStmp)+(Random:C100%60)+5
				
				$indice:=$indice+1
			End while 
			
			$dateToTreat:=$dateToTreat+1
		End while 
		Progress SET PROGRESS($pDate; 0; "")
		
		
	End for each 
	
End for each 
Progress QUIT($pCK)
Progress QUIT($pMS)
Progress QUIT($pDate)

ALERT:C41("done : "+Current method name:C684)