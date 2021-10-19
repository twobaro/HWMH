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

$menu:=Create menu:C408()

$start:=Form:C1466.current_appointment.time/900
$nb:=1
$stop:=False:C215
Repeat 
	$durationString:=sfw_Time($nb*900)
	APPEND MENU ITEM:C411($menu; $durationString)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $durationString)
	$nb:=$nb+1
	If (($start+$nb)>96)
		$stop:=True:C214
	Else 
		If ($_quarter{$start+$nb}#1)
			$stop:=True:C214
			$durationString:=sfw_Time($nb*900)
			APPEND MENU ITEM:C411($menu; $durationString)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $durationString)
		End if 
	End if 
Until ($stop)

$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)


Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.current_appointment.duration:=Time:C179($choose)
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