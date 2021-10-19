//%attributes = {}

var $esAppointment : cs:C1710.AppointmentSelection
var $eAppointment : cs:C1710.AppointmentEntity
var $i : Integer
var $date : Date

$before:=sfw_stmp_build(Current date:C33; ?00:00:00?)

$esAppointment:=ds:C1482.Appointment.query("startStmp < :1 & idStatus = 1"; $before)

$p:=Progress New
$i:=0
For each ($eAppointment; $esAppointment)
	$i:=$i+1
	$date:=sfw_stmp_read_date($eAppointment.startStmp)
	Progress SET PROGRESS($p; $i/($esAppointment.length); String:C10($date))
	
	$noShow:=(Random:C100%300=0)
	Case of 
		: ($noShow)
			$chrono:=New object:C1471
			$chrono.status:=-10
			$chrono.date:=$date
			$chrono.stmp:=$eAppointment.startStmp
			$chrono.origin:=1
			$eAppointment.idStatus:=$chrono.status
			$eAppointment.chronoStatus.histo.push($chrono)
			
		Else 
			$chrono:=New object:C1471
			$chrono.status:=2
			$chrono.date:=$date
			$chrono.stmp:=$eAppointment.startStmp-(((Random:C100%30)-2)*60)
			$chrono.origin:=1
			$eAppointment.chronoStatus.histo.push($chrono)
			$lastStmp:=$chrono.stmp
			
			$chrono:=New object:C1471
			$chrono.status:=3
			$chrono.date:=$date
			$chrono.stmp:=$lastStmp+((Random:C100%30)*60)
			$chrono.origin:=1
			$eAppointment.chronoStatus.histo.push($chrono)
			$lastStmp:=$chrono.stmp
			
			$chrono:=New object:C1471
			$chrono.status:=4
			$chrono.date:=$date
			$chrono.stmp:=$lastStmp+(((Random:C100%(($eAppointment.duration/60)-5+1))+5)*60)
			$chrono.origin:=1
			$eAppointment.chronoStatus.histo.push($chrono)
			$lastStmp:=$chrono.stmp
			
			$chrono:=New object:C1471
			$chrono.status:=10
			$chrono.date:=$date
			$chrono.stmp:=$lastStmp+(((Random:C100%2)+1)*60)
			$chrono.origin:=1
			$eAppointment.idStatus:=$chrono.status
			$eAppointment.chronoStatus.histo.push($chrono)
			
	End case 
	
	$eAppointment.chronoStatus:=$eAppointment.chronoStatus
	$info:=$eAppointment.save()
End for each 

Progress QUIT($p)