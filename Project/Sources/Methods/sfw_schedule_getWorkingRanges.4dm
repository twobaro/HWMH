//%attributes = {}
#DECLARE ($date : Date; $scheduleParam : Variant)->$workingRanges : Collection

var $schedule : Object
var $numDay : Integer
var $schedules : Collection

Case of 
	: (Value type:C1509($scheduleParam)=Is collection:K8:32)
		$schedules:=$scheduleParam
	: (Value type:C1509($scheduleParam)=Is object:K8:27)
		$schedules:=New collection:C1472($scheduleParam)
	Else 
		$schedules:=New collection:C1472
End case 
$priorityPeriods:=Split string:C1554("day;month;quarter;year;default"; ";")

$workingRanges:=New collection:C1472
For each ($schedule; $schedules)
	$continue:=True:C214
	For each ($priority; $priorityPeriods) While ($continue)
		For each ($periodName; $schedule) While ($continue)
			Case of 
				: ($periodName=(String:C10(Year of:C25($date))+String:C10(Month of:C24($date); "00")+String:C10(Day of:C23($date); "00"))) & ($priority="day")
					If ($schedule[$periodName].work#Null:C1517)
						$workingRanges:=$workingRanges.concat($schedule[$periodName].work)
					End if 
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date))+String:C10(Month of:C24($date); "00"))) & ($priority="month")
					If ($schedule[$periodName].work#Null:C1517)
						$numDay:=Day number:C114($date)
						$exceptions:=$schedule[$periodName].except
						If ($exceptions.indexOf($numDay)=-1)
							$workingRanges:=$workingRanges.concat($schedule[$periodName].work)
						End if 
					End if 
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date))+"Q"+String:C10((Month of:C24($date)\3)+Num:C11((Month of:C24($date)%3)#0)))) & ($priority="quarter")
					If ($schedule[$periodName].work#Null:C1517)
						$numDay:=Day number:C114($date)
						$exceptions:=$schedule[$periodName].except
						If ($exceptions.indexOf($numDay)=-1)
							$workingRanges:=$workingRanges.concat($schedule[$periodName].work)
						End if 
					End if 
					$continue:=False:C215
					
				: ($periodName=(String:C10(Year of:C25($date)))) & ($priority="year")
					If ($schedule[$periodName].work#Null:C1517)
						$numDay:=Day number:C114($date)
						$exceptions:=$schedule[$periodName].except
						If ($exceptions.indexOf($numDay)=-1)
							$workingRanges:=$workingRanges.concat($schedule[$periodName].work)
						End if 
					End if 
					$continue:=False:C215
					
				: ($periodName="default") & ($priority="default")
					$numDay:=Day number:C114($date)
					$exceptions:=$schedule[$periodName].except
					If ($exceptions.indexOf($numDay)=-1)
						$workingRanges:=$workingRanges.concat($schedule[$periodName].work)
					End if 
					
			End case 
		End for each 
	End for each 
End for each 
