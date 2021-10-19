//%attributes = {}
var $esCoach : cs:C1710.CoachSelection
var $eCoach : cs:C1710.CoachEntity
var $esMedicalHouse : cs:C1710.MedicalHouseSelection
var $eMedicalHouse : cs:C1710.MedicalHouseEntity
var $eLessonCapability : cs:C1710.LessonCapabilityEntity


var $formula : Object
var $quarters : Collection

$definitionFolder:=Folder:C1567(fk resources folder:K87:11).folder("sfw/definition")
$file:=$definitionFolder.file("lessonCapabilities_generator.json")
$text:=$file.getText()

$jsonBrut:=JSON Parse:C1218($text)

$activities:=$jsonBrut.activities

$activities:=$activities.orderBy("exclusiveActivity")

TRUNCATE TABLE:C1051([LessonCapability:8])
$esCoach:=ds:C1482.Coach.all()
For each ($eCoach; $esCoach)
	$exclusive:=False:C215
	$workingDurationMax:=3600*((Random:C100%10)+30)
	$workingDurationAffected:=0
	$mh:=0
	
	$quartersByDays:=New collection:C1472()
	$quartersByDays[7]:=New collection:C1472()
	$quartersByDays.fill(New collection:C1472)
	For ($i; 1; 7)
		$quarters:=New collection:C1472
		$quarters[95]:=0
		$quarters.fill(0)
		$quartersByDays[$i]:=$quarters
	End for 
	
	
	For each ($activity; $activities.query("nbCoach >0")) While ($workingDurationAffected<$workingDurationMax)
		If ($activity.minDuration=Null:C1517)
			$activity.minDuration:=900
		End if 
		Case of 
			: ($exclusive)
				$continue:=Not:C34(Bool:C1537($activity.exclusiveActivity))
			: (Bool:C1537($activity.exclusiveActivity))
				$continue:=True:C214
				$exclusive:=True:C214
			Else 
				$continue:=True:C214
		End case 
		
		If ($continue)
			$nbMedicalHouse:=Num:C11($activity.nbMedicalHouse)
			If ($nbMedicalHouse=0)
				$nbMedicalHouse:=ds:C1482.MedicalHouse.all().length
			End if 
			$formula:=Formula:C1597((Random:C100%1000)+(This:C1470.level*500))
			$esMedicalHouse:=ds:C1482.MedicalHouse.all().orderByFormula($formula).slice(0; $nbMedicalHouse)
			
			Case of 
				: ($activity.schedule.morning#Null:C1517) & ($activity.schedule.afternoon#Null:C1517)
					
					$workingDurationMorning:=sfw_schedule_getWorkingDuration($activity.schedule.morning.work)
					$workingQuartersMorning:=sfw_schedule_getWorkingQuarters($activity.schedule.morning.work)
					$workingDurationAfternoon:=sfw_schedule_getWorkingDuration($activity.schedule.afternoon.work)
					$workingQuartersAfternoon:=sfw_schedule_getWorkingQuarters($activity.schedule.afternoon.work)
					If ($activity.schedule.fullday=Null:C1517)
						$activity.schedule.fullday:=New object:C1471
						$activity.schedule.fullday.work:=$activity.schedule.morning.work.concat($activity.schedule.afternoon.work)
					End if 
					$workingDuration:=sfw_schedule_getWorkingDuration($activity.schedule.fullday.work)
					$workingQuarters:=sfw_schedule_getWorkingQuarters($activity.schedule.fullday.work)
					
					$halfdayIndices:=New collection:C1472
					$daysmorning:=New collection:C1472
					While ($daysmorning.length<5)
						$d:=Random:C100%5+2
						If ($daysmorning.indexOf($d)=-1)
							$daysmorning.push($d)
						End if 
					End while 
					$daysafternoon:=New collection:C1472
					While ($daysafternoon.length<5)
						$d:=Random:C100%5+2
						If ($daysafternoon.indexOf($d)=-1)
							$daysafternoon.push($d)
						End if 
					End while 
					
					For ($i; 1; 10)
						$morning:=($i%2=1)
						
						If ($morning)
							$quatersAvailable:=$workingQuartersMorning.copy()
							$dayToTest:=$daysmorning.shift()
						Else 
							$quatersAvailable:=$workingQuartersAfternoon.copy()
							$dayToTest:=$daysafternoon.shift()
						End if 
						$quartersAlreadyUsed:=$quartersByDays[$dayToTest].copy()
						For ($q; 0; 95)
							If ($quartersAlreadyUsed[$q]=1)
								$quatersAvailable[$q]:=0
							End if 
						End for 
						$ok:=False:C215
						If ($quatersAvailable.countValues(1)>=($activity.minDuration/900))
							$max:=sfw_schedule_getMaxIRQuarters($quatersAvailable)
							If ($max>=($activity.minDuration/900))
								$ok:=True:C214
							End if 
						End if 
						If ($ok)
							$triplet:=New object:C1471("dayNum"; $dayToTest; "mh"; $mh; "morning"; $morning; "quarters"; $quatersAvailable)
							$mh:=$mh+1
							If ($mh>=$nbMedicalHouse)
								$mh:=0
							End if 
							$ok:=False:C215
							Case of 
								: ($halfdayIndices.indices("dayNum = :1 & mh = :2 & morning = :3"; $triplet.dayNum; $triplet.mh; $triplet.morning).length=1)
								: ($halfdayIndices.countValues($triplet.dayNum; "dayNum")=2)
								Else 
									$ok:=True:C214
							End case 
						End if 
						If ($ok)
							$halfdayIndices.push($triplet)
						End if 
					End for 
					$halfdayIndicesTempo:=$halfdayIndices.orderBy("dayNum, mh, morning")
					$halfdayIndices:=New collection:C1472()
					While (($halfdayIndicesTempo.length%2=0) & ($halfdayIndicesTempo.length>0))
						$triplet1:=$halfdayIndicesTempo.shift()
						$triplet2:=$halfdayIndicesTempo.shift()
						If ($triplet1.dayNum=$triplet2.dayNum) & ($triplet1.mh=$triplet2.mh)
							OB REMOVE:C1226($triplet1; "morning")
							$triplet1.fullday:=True:C214
							For ($q; 0; 95)
								If ($triplet2.quarters[$q]=1)
									$triplet1.quarters[$q]:=1
								End if 
							End for 
							$halfdayIndices.push($triplet1)
						Else 
							$halfdayIndices.push($triplet1; $triplet2)
						End if 
					End while 
					While ($halfdayIndicesTempo.length>0)
						$halfdayIndices.push($halfdayIndicesTempo.shift())
					End while 
					
					If ($halfdayIndices.length>0)
						$quarters:=$halfdayIndices[0].quarters
						$workingNextDuration:=$quarters.countValues(1)*900
						$workingRanges:=sfw_schedule_getWRFromQuarters($quarters)
						While (($workingDurationAffected+$workingNextDuration)<=$workingDurationMax) & ($halfdayIndices.length#0)
							$triplet:=$halfdayIndices.shift()
							
							$eLessonCapability:=ds:C1482.LessonCapability.new()
							$eLessonCapability.UUID_Activity:=$activity.UUID
							$eLessonCapability.UUID_Coach:=$eCoach.UUID
							$eLessonCapability.UUID_MedicalHouse:=$esMedicalHouse[$triplet.mh].UUID
							$eLessonCapability.schedule:=New object:C1471("default"; New object:C1471)
							$eLessonCapability.schedule.default.min:=$activity.minDuration
							$eLessonCapability.schedule.default.work:=$workingRanges
							
							$excepts:=New collection:C1472(1; 2; 3; 4; 5; 6; 7)
							$indexOfCurrentDayNum:=$excepts.indexOf($triplet.dayNum)
							$excepts.remove($indexOfCurrentDayNum)
							$workingDurationAffected:=$workingDurationAffected+$workingNextDuration
							
							$eLessonCapability.schedule.default.except:=$excepts
							$eLessonCapability.save()
							
							For ($i; 1; 7)
								If ($excepts.indexOf($i)=-1)
									For ($q; 0; 95)
										If ($quarters[$q]=1)
											$quartersByDays[$i][$q]:=1
										End if 
									End for 
								End if 
							End for 
							
							If ($halfdayIndices.length#0)
								$quarters:=$halfdayIndices[0].quarters
								$workingNextDuration:=$quarters.countValues(1)*900
								$workingRanges:=sfw_schedule_getWRFromQuarters($quarters)
							End if 
						End while 
					End if 
					
				: ($activity.schedule.fullday#Null:C1517)
					
					
					$daysIndices:=New collection:C1472()
					While ($daysIndices.length<5)
						$workingQuarters:=sfw_schedule_getWorkingQuarters($activity.schedule.fullday.work)
						If ($activity.schedule.fullday1#Null:C1517)
							If (Random:C100%2=1)
								$workingQuarters:=sfw_schedule_getWorkingQuarters($activity.schedule.fullday1.work)
							End if 
						End if 
						$d:=Random:C100%5+2
						If ($daysIndices.countValues($d; "dayNum")=0)
							$mh:=$mh+1
							If ($mh>=$nbMedicalHouse)
								$mh:=0
							End if 
							$triplet:=New object:C1471("dayNum"; $d; "mh"; $mh)
							$quartersAlreadyUsed:=$quartersByDays[$d].copy()
							$quatersAvailable:=$workingQuarters.copy()
							For ($q; 0; 95)
								If ($quartersAlreadyUsed[$q]=1)
									$quatersAvailable[$q]:=0
								End if 
							End for 
							$triplet.quarters:=$quatersAvailable
							If ($quatersAvailable.countValues(1)>=($activity.minDuration/900))
								$max:=sfw_schedule_getMaxIRQuarters($quatersAvailable)
								If ($max>=($activity.minDuration/900))
									$daysIndices.push($triplet)
								End if 
							End if 
						End if 
					End while 
					
					If ($daysIndices.length>0)
						$indexOfDayNum:=0
						$dayNum:=$daysIndices[$indexOfDayNum].dayNum
						$quarters:=$daysIndices[$indexOfDayNum].quarters
						$workingRanges:=sfw_schedule_getWRFromQuarters($quarters)
						$workingNextDuration:=$quarters.countValues(1)*900
						While (($workingDurationAffected+$workingNextDuration)<=$workingDurationMax) & ($indexOfDayNum<$daysIndices.length)
							
							$eLessonCapability:=ds:C1482.LessonCapability.new()
							$eLessonCapability.UUID_Activity:=$activity.UUID
							$eLessonCapability.UUID_Coach:=$eCoach.UUID
							$eLessonCapability.UUID_MedicalHouse:=$esMedicalHouse[$daysIndices[$indexOfDayNum].mh].UUID
							$eLessonCapability.schedule:=New object:C1471("default"; New object:C1471)
							$eLessonCapability.schedule.default.min:=$activity.minDuration
							$eLessonCapability.schedule.default.work:=$workingRanges
							
							$excepts:=New collection:C1472(1; 2; 3; 4; 5; 6; 7)
							$indexOfCurrentDayNum:=$excepts.indexOf($dayNum)
							$excepts.remove($indexOfCurrentDayNum)
							$workingDurationAffected:=$workingDurationAffected+$workingNextDuration
							
							
							$eLessonCapability.schedule.default.except:=$excepts
							$eLessonCapability.save()
							
							
							For ($q; 0; 95)
								If ($quarters[$q]=1)
									$quartersByDays[$dayNum][$q]:=1
								End if 
							End for 
							
							$indexOfDayNum:=$indexOfDayNum+1
							If ($indexOfDayNum<$daysIndices.length)
								$dayNum:=$daysIndices[$indexOfDayNum].dayNum
								$quarters:=$daysIndices[$indexOfDayNum].quarters
								$workingRanges:=sfw_schedule_getWRFromQuarters($quarters)
								$workingNextDuration:=$quarters.countValues(1)*900
							End if 
						End while 
						
					End if 
					
			End case 
			
			$activity.nbCoach:=$activity.nbCoach-1
		End if 
		
	End for each 
	
End for each 


