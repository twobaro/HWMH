//%attributes = {}
$ptrPupYear:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_year")
$ptrPupMedicalHouse:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_medicalHouse")
$ptrPupConsultationKind:=OBJECT Get pointer:C1124(Object named:K67:5; "pup_consultationKind")


Form:C1466.calculation.duration:=Milliseconds:C459

//%W-533.3
$year:=Num:C11($ptrPupYear->{$ptrPupYear->})
//%W+533.3
$date:=Add to date:C393(!00-00-00!; $year; 1; 1)

$from:=sfw_stmp_build($date; ?00:00:00?)
$to:=sfw_stmp_build(Add to date:C393($date; 1; 0; 0); ?00:00:00?)

$settings:=New object:C1471("queryPlan"; True:C214)
$settings.parameters:=New object:C1471
$criteras:=New collection:C1472
$criteras.push("startStmp >= :from")
$settings.parameters.from:=$from
$criteras.push("startStmp < :to")
$settings.parameters.to:=$to
$criteras.push("idStatus >0")
If ($ptrPupMedicalHouse->>2)
	$criteras.push("UUID_MedicalHouse = :uuidmedicalHouse")
	$settings.parameters.uuidmedicalHouse:=Storage:C1525.cache.medicalHouse[$ptrPupMedicalHouse->-3].UUID
End if 
If ($ptrPupConsultationKind->>2)
	$criteras.push("UUID_ConsultationKind = :consultationKind")
	$settings.parameters.consultationKind:=Storage:C1525.cache.consultationKind[$ptrPupConsultationKind->-3].UUID
End if 

$criterasString:=$criteras.join(" & ")
$esAppointment:=ds:C1482.Appointment.query($criterasString; $settings)

$stmps:=$esAppointment.toCollection("startStmp").extract("startStmp")

ARRAY LONGINT:C221($_stmp; 0)
COLLECTION TO ARRAY:C1562($stmps; $_stmp)
ARRAY INTEGER:C220($_nb; 0)
ARRAY DATE:C224($_date; 0)
For ($i; 1; Size of array:C274($_stmp))
	$appDate:=sfw_stmp_read_date($_stmp{$i})
	$p:=Find in array:C230($_date; $appDate)
	If ($p=-1)
		APPEND TO ARRAY:C911($_date; $appDate)
		APPEND TO ARRAY:C911($_nb; 0)
		$p:=Size of array:C274($_nb)
	End if 
	$_nb{$p}:=$_nb{$p}+1
End for 

OBJECT SET VISIBLE:C603(*; "day_@"; False:C215)
OBJECT GET COORDINATES:C663(*; "day_1"; $gday1; $hday1; $dday1; $bday1)
$dnum:=0
FORM GET OBJECTS:C898($_names)
$maxValues:=Max:C3($_nb)
While (Year of:C25($date)=$year)
	$dnum:=$dnum+1
	$buttonName:="day_"+String:C10($dnum)
	If (Find in array:C230($_names; $buttonName)=-1)
		OBJECT DUPLICATE:C1111(*; "day_1"; $buttonName)
	End if 
	OBJECT SET VISIBLE:C603(*; $buttonName; True:C214)
	$dayNum:=Day of:C23($date)
	$monthNum:=Month of:C24($date)
	If ($buttonName#"day_1")
		OBJECT SET COORDINATES:C1248(*; $buttonName; \
			$gday1+(($dayNum-1)*25); \
			$hday1+(($monthNum-1)*25); \
			$gday1+(($dayNum-1)*25)+24; \
			$hday1+(($monthNum-1)*25)+24)
	End if 
	$p:=Find in array:C230($_date; $date)
	If ($p=-1)
		$nb:=0
	Else 
		$nb:=$_nb{$p}
	End if 
	
	$range:=(($nb/$maxValues*100)\10)*10
	
	
	OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.calculation.format_day_1; "red_000"; "red_"+String:C10($range; "000")))
	OBJECT SET TITLE:C194(*; $buttonName; String:C10($nb; "###0;;"))
	If ($range>50)
		OBJECT SET RGB COLORS:C628(*; $buttonName; "white")
	Else 
		OBJECT SET RGB COLORS:C628(*; $buttonName; "black")
	End if 
	OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($date; System date long:K1:3))
	$date:=$date+1
End while 

Form:C1466.calculation.duration:=Milliseconds:C459-Form:C1466.calculation.duration