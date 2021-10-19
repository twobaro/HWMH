Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		// init the necessary elements
		If (Form:C1466.months=Null:C1517)
			Form:C1466.months:=Split string:C1554(sfw_xliff_read("dateAndTime.months"; "January;Febuary;March;April;May;June;July;August;September;October;November;December"); ";")
			Form:C1466.days:=Split string:C1554(sfw_xliff_read("dateAndTime.days"; "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday"); ";")
		End if 
		For ($d; 1; 31)
			OBJECT SET TITLE:C194(*; "dayNum_"+String:C10($d); String:C10($d))
		End for 
		OBJECT GET COORDINATES:C663(*; "month_1"; $gmonth1; $hmonth1; $dmonth1; $bmonth1)
		For ($m; 1; 12)
			OBJECT SET TITLE:C194(*; "month_"+String:C10($m); Form:C1466.months[$m-1])
			OBJECT SET COORDINATES:C1248(*; "month_"+String:C10($m); \
				$gmonth1; \
				$hmonth1+(($m-1)*25); \
				$dmonth1; \
				$hmonth1+(($m-1)*25)+14)
		End for 
		
		If (Form:C1466.calculation=Null:C1517)
			Form:C1466.calculation:=New object:C1471
		End if 
		Form:C1466.calculation.duration:=Milliseconds:C459
		$year:=Year of:C25(Current date:C33)
		$date:=Add to date:C393(!00-00-00!; $year; 1; 1)
		
		$from:=sfw_stmp_build($date; ?00:00:00?)
		$to:=sfw_stmp_build(Add to date:C393($date; 1; 0; 0); ?00:00:00?)
		
		$settings:=New object:C1471
		$settings.parameters:=New object:C1471
		$criteras:=New collection:C1472
		$criteras.push("startStmp >= :from")
		$settings.parameters.from:=$from
		$criteras.push("startStmp < :to")
		$settings.parameters.to:=$to
		$criteras.push("idStatus >0")
		
		$criterasString:=$criteras.join(" & ")
		$stmps:=ds:C1482.Appointment.query($criterasString; $settings).toCollection("startStmp").extract("startStmp")
		
		$appointmentDates:=New collection:C1472
		For each ($stmp; $stmps)
			$appDate:=sfw_stmp_read_date($stmp)
			$indices:=$appointmentDates.indices("date = :1"; $appDate)
			If ($indices.length=0)
				$appointmentDate:=New object:C1471
				$appointmentDate.date:=$appDate
				$appointmentDate.nb:=0
				$appointmentDates.push($appointmentDate)
			Else 
				$appointmentDate:=$appointmentDates[$indices[0]]
			End if 
			$appointmentDate.nb:=$appointmentDate.nb+1
		End for each 
		
		OBJECT SET VISIBLE:C603(*; "day_@"; False:C215)
		OBJECT GET COORDINATES:C663(*; "day_1"; $gday1; $hday1; $dday1; $bday1)
		$dnum:=0
		FORM GET OBJECTS:C898($_names)
		$maxValues:=$appointmentDates.max("nb")
		$format_day_1:=OBJECT Get format:C894(*; "day_1")
		While (Year of:C25($date)=$year)
			$buttonName:="day_"+String:C10($dnum)
			If (Find in array:C230($_names; $buttonName)=-1)
				OBJECT DUPLICATE:C1111(*; "day_1"; $buttonName)
			End if 
			OBJECT SET VISIBLE:C603(*; $buttonName; True:C214)
			$dayNum:=Day of:C23($date)
			$monthNum:=Month of:C24($date)
			OBJECT SET COORDINATES:C1248(*; $buttonName; \
				$gday1+(($dayNum-1)*25); \
				$hday1+(($monthNum-1)*25); \
				$gday1+(($dayNum-1)*25)+24; \
				$hday1+(($monthNum-1)*25)+24)
			$indices:=$appointmentDates.indices("date = :1"; $date)
			If ($indices.length=0)
				$nb:=0
			Else 
				$nb:=$appointmentDates[$indices[0]].nb
			End if 
			$range:=(($nb/$maxValues*100)\10)*10
			
			OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233($format_day_1; "red_000"; "red_"+String:C10($range; "000")))
			OBJECT SET TITLE:C194(*; $buttonName; String:C10($nb; "###0;;-"))
			If ($range>50)
				OBJECT SET RGB COLORS:C628(*; $buttonName; "white")
			Else 
				OBJECT SET RGB COLORS:C628(*; $buttonName; "black")
			End if 
			OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($date; System date long:K1:3))
			$date:=$date+1
			$dnum:=$dnum+1
		End while 
		
		Form:C1466.calculation.duration:=Milliseconds:C459-Form:C1466.calculation.duration
		
End case 

