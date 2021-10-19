//%attributes = {}
var $pict : Picture

$activeObjectName:=String:C10(FORM Event:C1606.objectName)

// set calculation stage flags
$isInModification:=sfw_checkIsInModification
$initESPersonGroup:=False:C215
$showDetail:=False:C215
$bypassCalendarDrawing:=False:C215
$noWorkingsToDisplay:=False:C215
$calculateLB_appointment:=False:C215


// init the necessary elements
If (Form:C1466.months=Null:C1517)
	Form:C1466.months:=Split string:C1554(sfw_xliff_read("dateAndTime.months"; "January;Febuary;March;April;May;June;July;August;September;October;November;December"); ";")
	Form:C1466.days:=Split string:C1554(sfw_xliff_read("dateAndTime.days"; "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday"); ";")
End if 
If (Form:C1466.calendar=Null:C1517)
	Form:C1466.calendar:=New object:C1471
End if 
If (Form:C1466.lb_appointments_toDelete=Null:C1517)
	Form:C1466.lb_appointments_toDelete:=New collection:C1472()
End if 
If (Form:C1466.calendar.display=Null:C1517)
	Form:C1466.calendar.display:=New object:C1471
	Form:C1466.calendar.display.date:=Current date:C33
	Form:C1466.calendar.display.year:=Year of:C25(Form:C1466.calendar.display.date)
	Form:C1466.calendar.display.month:=Month of:C24(Form:C1466.calendar.display.date)
	Form:C1466.calendar.display.day:=Day of:C23(Form:C1466.calendar.display.date)
End if 
If (Form:C1466.planning=Null:C1517)
	Form:C1466.planning:=New object:C1471()
End if 
If (Form:C1466.planning.date=Null:C1517)
	Form:C1466.planning.date:=!00-00-00!
End if 


// check if the calendar must be draw or redraw
Case of 
	: ($activeObjectName="Pup_displayYear@")
	: ($activeObjectName="Pup_displayMonth@")
	: (FORM Event:C1606.code=On Page Change:K2:54)
	: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		Form:C1466.lb_appointments:=Null:C1517
		Form:C1466.current_appointment:=Null:C1517
		Form:C1466.current_appointment_position:=0
		(OBJECT Get pointer:C1124((Object named:K67:5); "working_ranges_pict")->):=$pict
		
	: (String:C10(Form:C1466.calendar.lastUUIDforDrawing)#String:C10(Form:C1466.current_item.UUID))
	Else 
		$bypassCalendarDrawing:=True:C214
End case 

// calendar drawing
If (Not:C34($bypassCalendarDrawing))
	Form:C1466.calendar.lastUUIDforDrawing:=Form:C1466.current_item.UUID
	OBJECT SET TITLE:C194(*; "Pup_displayYear"; String:C10(Form:C1466.calendar.display.year))
	OBJECT SET TITLE:C194(*; "Pup_displayMonth"; Form:C1466.months[Form:C1466.calendar.display.month-1])
	$nextMonth:=Form:C1466.calendar.display.month+1
	If ($nextMonth=13)
		$nextMonth:=1
		$nextYear:=Form:C1466.calendar.display.year+1
	Else 
		$nextYear:=Form:C1466.calendar.display.year
	End if 
	OBJECT SET TITLE:C194(*; "Pup_displayYearNext"; String:C10($nextYear))
	OBJECT SET TITLE:C194(*; "Pup_displayMonthNext"; Form:C1466.months[$nextMonth-1])
	$offsetX:=55
	$offsetY:=138
	$dayWidth:=24
	$dayHeight:=24
	OBJECT SET VISIBLE:C603(*; "button_displayDay_@"; False:C215)
	OBJECT SET ENABLED:C1123(*; "button_displayDay_@"; False:C215)
	OBJECT SET FORMAT:C236(*; "button_displayDay_@"; Form:C1466.format_button_displayDay)
	OBJECT SET RGB COLORS:C628(*; "button_displayDay_@"; "black"; Background color none:K23:10)
	$day:=Add to date:C393(!00-00-00!; Form:C1466.calendar.display.year; Form:C1466.calendar.display.month; 1)
	$column:=Day number:C114($day)
	$line:=1
	$dayCounter:=0
	$noWorkingsToDisplay:=True:C214
	For ($passe; 0; 1)
		$monthInDrawing:=Form:C1466.calendar.display.month+$passe
		If ($monthInDrawing=13)
			$monthInDrawing:=1
		End if 
		While (Month of:C24($day)=($monthInDrawing))
			$dayCounter:=$dayCounter+1
			$buttonName:="button_displayDay_"+String:C10($dayCounter)
			OBJECT SET VISIBLE:C603(*; $buttonName; True:C214)
			OBJECT SET TITLE:C194(*; $buttonName; String:C10(Day of:C23($day)))
			OBJECT SET COORDINATES:C1248(*; $buttonName; \
				$offsetX+(($column-1)*$dayWidth); \
				$offsetY+(($line-1)*$dayHeight); \
				$offsetX+($column*$dayWidth); \
				$offsetY+($line*$dayHeight))
			
			Case of 
				: (Form:C1466.current_item=Null:C1517)
				: (Form:C1466.current_item.lessonCapabilities=Null:C1517)
				Else 
					$workingPeriods:=sfw_schedule_getWorkingPeriods($day; Form:C1466.current_item.UUID)
					If ($workingPeriods.workingRanges.length>0)
						$from:=sfw_stmp_build($day; ?00:00:00?)
						$to:=sfw_stmp_build($day+1; ?00:00:00?)
						$duration:=Form:C1466.current_item.privateLessons.query("startStmp >= :1 & startStmp < :2"; $from; $to).sum("duration")
						$duration:=$duration+Form:C1466.current_item.groupLessons.query("startStmp >= :1 & startStmp < :2"; $from; $to).sum("duration")
						If ($duration#0)
							$pourMille:=Int:C8($duration/$workingPeriods.workingDuration*1000)
							$m:=($pourMille\125)*125
							OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.format_button_displayDay; "BkgdLightGrey"; String:C10($m; "0000")))
							OBJECT SET TITLE:C194(*; $buttonName; String:C10(Day of:C23($day)))
							If ($m=875) | ($m=1000)
								OBJECT SET RGB COLORS:C628(*; $buttonName; "white"; Background color none:K23:10)
							End if 
						End if 
						If ($day=Form:C1466.calendar.display.date)
							OBJECT SET FONT STYLE:C166(*; $buttonName; Bold and Underline:K14:10)
						Else 
							OBJECT SET FONT STYLE:C166(*; $buttonName; Plain:K14:1)
						End if 
						OBJECT SET ENABLED:C1123(*; $buttonName; True:C214)
						$noWorkingsToDisplay:=False:C215
					End if 
			End case 
			$day:=$day+1
			$column:=$column+1
			If ($column=8)
				$column:=1
				$line:=$line+1
			End if 
		End while 
		If ($passe=0)
			If ($column#1)
				$line:=$line+1
			End if 
			$line:=$line+0.4
			OBJECT GET COORDINATES:C663(*; "Pup_displayYearNext"; $go; $ho; $do; $bo)
			OBJECT SET COORDINATES:C1248(*; "Pup_displayYearNext"; $go; $offsetY+(($line-1)*$dayHeight); $do; $bo-$ho+$offsetY+(($line-1)*$dayHeight))
			OBJECT GET COORDINATES:C663(*; "Pup_displayMonthNext"; $go; $ho; $do; $bo)
			OBJECT SET COORDINATES:C1248(*; "Pup_displayMonthNext"; $go; $offsetY+(($line-1)*$dayHeight); $do; $bo-$ho+$offsetY+(($line-1)*$dayHeight))
			$line:=$line+1
			For ($dd; 1; 7)
				OBJECT SET COORDINATES:C1248(*; "header_day_"+String:C10($dd+7); \
					$offsetX+(($dd-1)*$dayWidth); \
					$offsetY+(($line-1)*$dayHeight); \
					$offsetX+($dd*$dayWidth); \
					$offsetY+($line*$dayHeight))
			End for 
			$line:=$line+1
		End if 
	End for 
	
End if 

OBJECT SET VISIBLE:C603(*; "warningNoWorkings"; $noWorkingsToDisplay)

If ($activeObjectName="button_displayDay_@") & (FORM Event:C1606.code=On Clicked:K2:4)
	$numSelectedDay:=Num:C11(Substring:C12(FORM Event:C1606.objectName; 19))
	Form:C1466.planning.date:=Add to date:C393(!00-00-00!; Form:C1466.calendar.display.year; Form:C1466.calendar.display.month; $numSelectedDay)
	$initESPersonGroup:=True:C214
End if 

If (Form:C1466.planning.date=!00-00-00!) | ($noWorkingsToDisplay)
	OBJECT SET VISIBLE:C603(*; "planning_date"; False:C215)
	OBJECT SET VISIBLE:C603(*; "working_ranges_@"; False:C215)
	OBJECT SET VISIBLE:C603(*; "lb_appointments"; False:C215)
	OBJECT SET VISIBLE:C603(*; "bAppointment@"; False:C215)
	OBJECT SET VISIBLE:C603(*; "@appointment_@"; False:C215)
Else 
	OBJECT SET VISIBLE:C603(*; "planning_date"; True:C214)
	OBJECT SET VISIBLE:C603(*; "working_ranges_@"; True:C214)
	OBJECT SET VISIBLE:C603(*; "lb_appointments"; True:C214)
	OBJECT SET VISIBLE:C603(*; "bAppointment@"; True:C214)
	OBJECT SET ENABLED:C1123(*; "bAppointmentAdd"; $isInModification)
	OBJECT SET ENABLED:C1123(*; "bAppointmentDelete"; $isInModification & (Form:C1466.current_appointment_position#0))
	$calculateLB_appointment:=True:C214
	Case of 
		: ($activeObjectName="button_displayDay_@") & (FORM Event:C1606.code=On Clicked:K2:4)
		: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		Else 
			$calculateLB_appointment:=False:C215
	End case 
End if 

If ($calculateLB_appointment)
	Form:C1466.lb_appointments:=New collection:C1472
	$from:=sfw_stmp_build(Form:C1466.planning.date; ?00:00:00?)
	$to:=sfw_stmp_build(Form:C1466.planning.date+1; ?00:00:00?)
	For each ($privateLesson; ds:C1482.PrivateLesson.query("UUID_Coach = :1 & startStmp >= :2 & startStmp < :3"; Form:C1466.current_item.UUID; $from; $to))
		If (Form:C1466.lb_appointments_toDelete.indexOf($privateLesson.UUID)=-1)
			$appointment:=New object:C1471
			$appointment:=$privateLesson.toObject()
			$appointment.date:=sfw_stmp_read_date($appointment.startStmp)
			$appointment.time:=sfw_stmp_read_time($appointment.startStmp)
			$appointment.dataclass:="PrivateLesson"
			$appointment.who:=Person_getFullName($appointment.UUID_Person)
			Form:C1466.lb_appointments.push($appointment)
		End if 
	End for each 
	For each ($groupLesson; ds:C1482.GroupLesson.query("UUID_Coach = :1 & startStmp >= :2 & startStmp < :3"; Form:C1466.current_item.UUID; $from; $to))
		If (Form:C1466.lb_appointments_toDelete.indexOf($groupLesson.UUID)=-1)
			$appointment:=New object:C1471
			$appointment:=$groupLesson.toObject()
			$appointment.date:=sfw_stmp_read_date($appointment.startStmp)
			$appointment.time:=sfw_stmp_read_time($appointment.startStmp)
			$appointment.dataclass:="GroupLesson"
			$appointment.who:=Group_getFullName($appointment.UUID_Group)
			Form:C1466.lb_appointments.push($appointment)
		End if 
	End for each 
	
	For each ($appointment; Form:C1466.lb_appointments_toSave.query("UUID_Coach = :1 & startStmp >= :2 & startStmp < :3"; Form:C1466.current_item.UUID; $from; $to))
		$indices:=Form:C1466.lb_appointments.indices("UUID = :1"; $appointment.UUID)
		If ($indices.length=0)
			Form:C1466.lb_appointments.push($appointment)
		End if 
	End for each 
	Form:C1466.lb_appointments:=Form:C1466.lb_appointments.orderBy("time")
	$current:=1
	For each ($appointment; Form:C1466.lb_appointments)
		$current:=$current+1
		$appointment.columnColor:=sfw_shades_getColorWorkingRange($current)
		$appointment.meta:=New object:C1471("cell"; New object:C1471("columnColor"; New object:C1471("fill"; $appointment.columnColor)))
	End for each 
	Form:C1466.current_appointment_position:=0
	
	Form:C1466.workingPeriods:=sfw_schedule_getWorkingPeriods(Form:C1466.planning.date; Form:C1466.current_item.UUID)
	$quarters:=sfw_quarters_fillWWorkingRanges(Form:C1466.workingPeriods.workingRanges; Form:C1466.lb_appointments)
	(OBJECT Get pointer:C1124((Object named:K67:5); "working_ranges_pict")->):=sfw_schedule_drawWorkingRanges($quarters)
	
End if 


If (Num:C11(Form:C1466.current_appointment_position)=0)
	OBJECT SET VISIBLE:C603(*; "@appointment_@"; False:C215)
Else 
	OBJECT SET VISIBLE:C603(*; "@appointment_@"; True:C214)
	Case of 
		: (Form:C1466.current_appointment.dataclass="PrivateLesson")
			OBJECT SET VISIBLE:C603(*; "appointment_group@"; False:C215)
			OBJECT SET VISIBLE:C603(*; "appointment_person@"; True:C214)
			
		: (Form:C1466.current_appointment.dataclass="GroupLesson")
			OBJECT SET VISIBLE:C603(*; "appointment_group@"; True:C214)
			OBJECT SET VISIBLE:C603(*; "appointment_person@"; False:C215)
			
	End case 
End if 

If ($activeObjectName="lb_appointments") & ((FORM Event:C1606.code=On Selection Change:K2:29) | (FORM Event:C1606.code=On Clicked:K2:4))
	$initESPersonGroup:=True:C214
End if 

If ($initESPersonGroup)
	Form:C1466.searchPersonES:=Null:C1517
	Form:C1466.searchPersonLastName:=""
	Form:C1466.searchPersonFirstName:=""
	Form:C1466.searchGroupES:=Null:C1517
	Form:C1466.searchGroupName:=""
End if 

If (Form:C1466.current_appointment#Null:C1517) & ((FORM Event:C1606.code=On Clicked:K2:4) | (FORM Event:C1606.code=On Bound Variable Change:K2:52))
	$showDetail:=True:C214
End if 
If ($showDetail)
	Case of 
		: ($activeObjectName="appointment_@input@")
		: (Form:C1466.current_appointment.dataclass="PrivateLesson")
			OBJECT SET TITLE:C194(*; "pup_appointment_typeLesson"; "Private lesson")  //XLIFF
			Form:C1466.inputPersonFirstName:=""
			Form:C1466.inputPersonLastName:=""
			Form:C1466.inputGroupName:=""
			If (Form:C1466.current_appointment.UUID_Person#("0"*32))
				$p:=ds:C1482.Person.get(Form:C1466.current_appointment.UUID_Person)
				If ($p#Null:C1517)
					Form:C1466.inputPersonFirstName:=$p.firstName
					Form:C1466.inputPersonLastName:=$p.lastName
				End if 
			End if 
			OBJECT SET ENABLED:C1123(*; "appointment_person_inputFirstName"; $isInModification)
			OBJECT SET ENABLED:C1123(*; "appointment_person_inputLastName"; $isInModification)
			
		: (Form:C1466.current_appointment.dataclass="GroupLesson")
			OBJECT SET TITLE:C194(*; "pup_appointment_typeLesson"; "Group lesson")  //XLIFF
			Form:C1466.inputGroupName:=Form:C1466.current_appointment.who
			Form:C1466.inputPersonFirstName:=""
			Form:C1466.inputPersonLastName:=""
			OBJECT SET ENABLED:C1123(*; "appointment_group_input"; $isInModification)
			
	End case 
	OBJECT SET ENABLED:C1123(*; "pup_appointment_typeLesson"; $isInModification)
	
	$indicesMH:=Form:C1466.workingPeriods.medicalHouses.indices("UUID = :1"; String:C10(Form:C1466.current_appointment.UUID_MedicalHouse))
	If ($indicesMH.length>0)
		OBJECT SET TITLE:C194(*; "pup_appointment_medicalHouse"; Form:C1466.workingPeriods.medicalHouses[$indicesMH[0]].name)
	End if 
	OBJECT SET ENABLED:C1123(*; "pup_appointment_medicalHouse"; $isInModification)
	
	$indicesKind:=Form:C1466.workingPeriods.kinds.indices("UUID = :1"; String:C10(Form:C1466.current_appointment.UUID_Activity))
	If ($indicesKind.length>0)
		OBJECT SET TITLE:C194(*; "pup_appointment_kind"; Form:C1466.workingPeriods.kinds[$indicesKind[0]].name)
	End if 
	OBJECT SET ENABLED:C1123(*; "pup_appointment_kind"; $isInModification)
	
	OBJECT SET TITLE:C194(*; "pup_appointment_time"; sfw_Time(Form:C1466.current_appointment.time))
	OBJECT SET ENABLED:C1123(*; "pup_appointment_time"; $isInModification)
	OBJECT SET TITLE:C194(*; "pup_appointment_duration"; sfw_Time(Form:C1466.current_appointment.duration))
	OBJECT SET ENABLED:C1123(*; "pup_appointment_duration"; $isInModification)
	
End if 

If (Form:C1466.current_appointment#Null:C1517)
	OBJECT SET VISIBLE:C603(*; "pup_appointment_person"; $isInModification & (Form:C1466.searchPersonES#Null:C1517) & (Form:C1466.current_appointment#Null:C1517))
	Case of 
		: (Form:C1466.current_appointment=Null:C1517)
			$state:="notVisible"
		: (String:C10(Form:C1466.current_appointment.UUID_Person)=("0"*32))
			$state:="error"
		: (($isInModification))
			$state:="modify"
		Else 
			$state:="visible"
	End case 
	sfw_colorize_inputField("appointment_person_input@"; $state)
	OBJECT SET VISIBLE:C603(*; "pup_appointment_group"; $isInModification & (Form:C1466.searchGroupES#Null:C1517) & (Form:C1466.current_appointment#Null:C1517))
	Case of 
		: (Form:C1466.current_appointment=Null:C1517)
			$state:="notVisible"
		: (String:C10(Form:C1466.current_appointment.UUID_Group)=("0"*32))
			$state:="error"
		: (($isInModification))
			$state:="modify"
		Else 
			$state:="visible"
	End case 
	sfw_colorize_inputField("appointment_group_input@"; $state)
End if 

OBJECT GET SUBFORM CONTAINER SIZE:C1148($width_subform; $height_subform)
OBJECT GET COORDINATES:C663(*; "lb_appointments"; $g; $h; $d; $b)
OBJECT SET COORDINATES:C1248(*; "lb_appointments"; $g; $h; $width_subform-4; $b)

