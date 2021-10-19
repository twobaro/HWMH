


$quarters:=sfw_quarters_fillWWorkingRanges(Form:C1466.workingPeriods.workingRanges; Form:C1466.lb_appointments)
$first:=$quarters.indexOf(1)
If ($first<0)
	ALERT:C41("No more free quarter to create a new appointment !")
	
Else 
	
	$NewAppointment:=New object:C1471
	$NewAppointment.UUID:=Generate UUID:C1066
	$NewAppointment.UUID_Coach:=Form:C1466.current_item.UUID
	$NewAppointment.UUID_MedicalHouse:=Form:C1466.workingPeriods.medicalHouses[0].UUID
	$NewAppointment.UUID_Activity:=Form:C1466.workingPeriods.kinds[0].UUID
	$NewAppointment.UUID_Person:="0"*32
	$NewAppointment.UUID_Group:="0"*32
	$NewAppointment.date:=Form:C1466.planning.date
	$NewAppointment.duration:=?00:15:00?
	$NewAppointment.dataclass:="PrivateLesson"
	$NewAppointment.time:=Time:C179($first*900)
	$NewAppointment.startStmp:=sfw_stmp_build($NewAppointment.date; $NewAppointment.time)
	
	Form:C1466.lb_appointments.push($NewAppointment)
	Form:C1466.current_appointment:=$NewAppointment
	Form:C1466.current_appointment_position:=Form:C1466.lb_appointments.length
	LISTBOX SELECT ROW:C912(*; "lb_appointments"; Form:C1466.current_appointment_position; lk replace selection:K53:1)
	$current:=1
	For each ($appointment; Form:C1466.lb_appointments)
		$current:=$current+1
		$appointment.columnColor:=sfw_shades_getColorWorkingRange($current)
		$appointment.meta:=New object:C1471("cell"; New object:C1471("columnColor"; New object:C1471("fill"; $appointment.columnColor)))
	End for each 
	Form:C1466.lb_appointments:=Form:C1466.lb_appointments
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	Form:C1466.lb_appointments_toSave.push($NewAppointment)
	
	Form:C1466.workingPeriods:=sfw_schedule_getWorkingPeriods(Form:C1466.planning.date; Form:C1466.current_item.UUID)
	$quarters:=sfw_quarters_fillWWorkingRanges(Form:C1466.workingPeriods.workingRanges; Form:C1466.lb_appointments)
	(OBJECT Get pointer:C1124((Object named:K67:5); "working_ranges_pict")->):=sfw_schedule_drawWorkingRanges($quarters)
	
End if 