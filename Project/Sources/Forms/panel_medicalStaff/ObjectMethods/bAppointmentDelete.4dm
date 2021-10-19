If (Form:C1466.lb_appointments_toDelete=Null:C1517)
	Form:C1466.lb_appointments_toDelete:=New collection:C1472()
End if 
Form:C1466.lb_appointments_toDelete.push(Form:C1466.current_appointment.UUID)
Form:C1466.lb_appointments.remove(Form:C1466.current_appointment_position-1)
$current:=1
For each ($appointment; Form:C1466.lb_appointments)
	$current:=$current+1
	$appointment.columnColor:=sfw_shades_getColorWorkingRange($current)
	$appointment.meta:=New object:C1471("cell"; New object:C1471("columnColor"; New object:C1471("fill"; $appointment.columnColor)))
End for each 
Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
Form:C1466.lb_appointments:=Form:C1466.lb_appointments

Form:C1466.workingPeriods:=sfw_schedule_getWorkingPeriods(Form:C1466.planning.date; Form:C1466.current_item.UUID)
$quarters:=sfw_quarters_fillWWorkingRanges(Form:C1466.workingPeriods.workingRanges; Form:C1466.lb_appointments)
(OBJECT Get pointer:C1124((Object named:K67:5); "working_ranges_pict")->):=sfw_schedule_drawWorkingRanges($quarters)
