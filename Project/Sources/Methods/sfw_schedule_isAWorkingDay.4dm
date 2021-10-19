//%attributes = {}
#DECLARE ($date : Date; $schedules : Collection)->$isAWorkingDay : Boolean

var $schedule : Object
var $numDay : Integer

$isAWorkingDay:=False:C215
$continue:=True:C214
$typePeriods:=Split string:C1554("day;month;quarter;year;default"; ";")
For each ($typePeriod; $typePeriods) While ($continue)
	For each ($schedule; $schedules) While ($continue)
		For each ($periodName; $schedule) While ($continue)
			Case of 
				: ($periodName=(String:C10(Year of:C25($date))+String:C10(Month of:C24($date); "00")+String:C10(Day of:C23($date); "00"))) & ($typePeriod="day")
					$isAWorkingDay:=$isAWorkingDay | ($schedule[$periodName].work#Null:C1517)
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date))+String:C10(Month of:C24($date); "00"))) & ($typePeriod="month")
					$isAWorkingDay:=$isAWorkingDay | ($schedule[$periodName].work#Null:C1517)
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date))+"Q"+String:C10((Month of:C24($date)\3)+Num:C11((Month of:C24($date)%3)#0)))) & ($typePeriod="quarter")
					$isAWorkingDay:=$isAWorkingDay | ($schedule[$periodName].work#Null:C1517)
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date)))) & ($typePeriod="year")
					$isAWorkingDay:=$isAWorkingDay | ($schedule[$periodName].work#Null:C1517)
					$continue:=False:C215
					
				: ($periodName="default") & ($typePeriod="default")
					$numDay:=Day number:C114($date)
					$exceptions:=$schedule[$periodName].except
					$isAWorkingDay:=$isAWorkingDay | ($exceptions.indexOf($numDay)=-1)
					
			End case 
		End for each 
	End for each 
End for each 