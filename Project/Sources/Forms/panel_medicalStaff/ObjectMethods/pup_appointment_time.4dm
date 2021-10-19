$menu:=Create menu:C408()


ARRAY INTEGER:C220($_quarter; 96)
$workingRanges:=Form:C1466.workingPeriods.workingRanges.copy()
While ($workingRanges.length>0)
	$start:=$workingRanges.shift()/900
	$end:=$workingRanges.shift()/900
	Repeat 
		$_quarter{$start}:=1
		$start:=$start+1
	Until ($start>=$end)
End while 
For each ($appointment; Form:C1466.lb_appointments)
	If (Form:C1466.current_appointment.time#$appointment.time)
		$start:=$appointment.time/900
		$end:=$start+($appointment.duration/900)
		Repeat 
			$_quarter{$start}:=2
			$start:=$start+1
		Until ($start>=$end)
	End if 
End for each 

$workingRanges:=Form:C1466.workingPeriods.workingRanges.copy()
While ($workingRanges.length>0)
	$start:=$workingRanges.shift()
	$end:=$workingRanges.shift()
	Repeat 
		$timeString:=sfw_Time($start)
		APPEND MENU ITEM:C411($menu; $timeString)
		SET MENU ITEM PARAMETER:C1004($menu; -1; $timeString)
		If ($_quarter{$start/900}=2)
			DISABLE MENU ITEM:C150($menu; -1)
		End if 
		If ($start=Form:C1466.current_appointment.time)
			SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
		End if 
		$start:=$start+900
	Until ($start>=$end)
	APPEND MENU ITEM:C411($menu; "-")
End while 


$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.current_appointment.time:=Time:C179($choose)
		Form:C1466.current_appointment.startStmp:=sfw_stmp_build(Form:C1466.current_appointment.date; Form:C1466.current_appointment.time)
		Form:C1466.lb_appointments:=Form:C1466.lb_appointments
		Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		$indices:=Form:C1466.lb_appointments_toSave.indices("UUID = :1"; Form:C1466.current_appointment.UUID)
		If ($indices.length>0)
			Form:C1466.lb_appointments_toSave[$indices[0]]:=Form:C1466.current_appointment
		Else 
			Form:C1466.lb_appointments_toSave.push(Form:C1466.current_appointment)
		End if 
		Form:C1466.workingPeriods:=sfw_schedule_getWorkingPeriods(Form:C1466.planning.date; Form:C1466.current_item.UUID)
		$quarters:=sfw_quarters_fillWWorkingRanges(Form:C1466.workingPeriods.workingRanges; Form:C1466.lb_appointments)
		(OBJECT Get pointer:C1124((Object named:K67:5); "working_ranges_pict")->):=sfw_schedule_drawWorkingRanges($quarters)
End case 