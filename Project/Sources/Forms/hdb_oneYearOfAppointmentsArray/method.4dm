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
		
		$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
		//%W-518.5
		ARRAY TEXT:C222($ptrPupMedicalHouse->; 0)
		//%W+518.5
		APPEND TO ARRAY:C911($ptrPupMedicalHouse->; sfw_xliff_read("appointment.allMedicalHouses"; "All medical houses"))
		APPEND TO ARRAY:C911($ptrPupMedicalHouse->; "-")
		MedicalHouse_load_cache
		For each ($house; Storage:C1525.cache.medicalHouse)
			APPEND TO ARRAY:C911($ptrPupMedicalHouse->; $house.name)
		End for each 
		$ptrPupMedicalHouse->:=1
		
		$ptrPupConsultationKind:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_consultationKind")
		//%W-518.5
		ARRAY TEXT:C222($ptrPupConsultationKind->; 0)
		//%W+518.5
		APPEND TO ARRAY:C911($ptrPupConsultationKind->; sfw_xliff_read("appointment.allConsultationKinds"; "All consultation kind"))
		APPEND TO ARRAY:C911($ptrPupConsultationKind->; "-")
		ConsultationKind_load_cache
		For each ($consultationKind; Storage:C1525.cache.consultationKind)
			APPEND TO ARRAY:C911($ptrPupConsultationKind->; $consultationKind.name)
		End for each 
		$ptrPupConsultationKind->:=1
		
		$ptrPupYear:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_year")
		//%W-518.5
		ARRAY TEXT:C222($ptrPupYear->; 0)
		//%W+518.5
		$year:=Year of:C25(Current date:C33)
		For ($y; $year-3; $year+10)
			APPEND TO ARRAY:C911($ptrPupYear->; String:C10($y))
		End for 
		$ptrPupYear->:=4
		
		Form:C1466.calculation.format_day_1:=OBJECT Get format:C894(*; "day_1")
		
		hdb_oneYarOfAppointments
		
		
End case 