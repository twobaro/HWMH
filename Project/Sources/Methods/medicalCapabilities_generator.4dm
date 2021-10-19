//%attributes = {}
var $esStaff : cs:C1710.MedicalStaffSelection
var $eStaff : cs:C1710.MedicalStaffEntity
var $esMedicalHouse : cs:C1710.MedicalHouseSelection
var $eMedicalHouse : cs:C1710.MedicalHouseEntity
var $eMedicalCapability : cs:C1710.MedicalCapabilityEntity

var $formula : Object
var $quarters : Collection

$definitionFolder:=Folder:C1567(fk resources folder:K87:11).folder("sfw/definition")
$file:=$definitionFolder.file("medicalCapabilities_generator.json")
$text:=$file.getText()

$jsonBrut:=JSON Parse:C1218($text)

$consultationKinds:=$jsonBrut.consultationKinds

$consultationKinds:=$consultationKinds.orderBy("exclusiveKind")

TRUNCATE TABLE:C1051([MedicalCapability:5])
$esStaff:=ds:C1482.MedicalStaff.all()
For each ($eStaff; $esStaff)
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
	
	
	For each ($consultationKind; $consultationKinds.query("nbMedicalStaff >0")) While ($workingDurationAffected<$workingDurationMax)
		If ($consultationKind.minDuration=Null:C1517)
			$consultationKind.minDuration:=900
		End if 
		Case of 
			: ($exclusive)
				$continue:=Not:C34(Bool:C1537($consultationKind.exclusiveKind))
			: (Bool:C1537($consultationKind.exclusiveKind))
				$continue:=True:C214
				$exclusive:=True:C214
			Else 
				$continue:=True:C214
		End case 
		
		If ($continue)
			$nbMedicalHouse:=Num:C11($consultationKind.nbMedicalHouse)
			If ($nbMedicalHouse=0)
				$nbMedicalHouse:=ds:C1482.MedicalHouse.all().length
			End if 
			$formula:=Formula:C1597((Random:C100%1000)+(This:C1470.level*500))
			$esMedicalHouse:=ds:C1482.MedicalHouse.all().orderByFormula($formula).slice(0; $nbMedicalHouse)
			
			Case of 
				: ($consultationKind.schedule.morning#Null:C1517) & ($consultationKind.schedule.afternoon#Null:C1517)
					
					$workingDurationMorning:=sfw_schedule_getWorkingDuration($consultationKind.schedule.morning.work)
					$workingQuartersMorning:=sfw_schedule_getWorkingQuarters($consultationKind.schedule.morning.work)
					$workingDurationAfternoon:=sfw_schedule_getWorkingDuration($consultationKind.schedule.afternoon.work)
					$workingQuartersAfternoon:=sfw_schedule_getWorkingQuarters($consultationKind.schedule.afternoon.work)
					If ($consultationKind.schedule.fullday=Null:C1517)
						$consultationKind.schedule.fullday:=New object:C1471
						$consultationKind.schedule.fullday.work:=$consultationKind.schedule.morning.work.concat($consultationKind.schedule.afternoon.work)
					End if 
					$workingDuration:=sfw_schedule_getWorkingDuration($consultationKind.schedule.fullday.work)
					$workingQuarters:=sfw_schedule_getWorkingQuarters($consultationKind.schedule.fullday.work)
					
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
						If ($quatersAvailable.countValues(1)>=($consultationKind.minDuration/900))
							$max:=sfw_schedule_getMaxIRQuarters($quatersAvailable)
							If ($max>=($consultationKind.minDuration/900))
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
							
							$eMedicalCapability:=ds:C1482.MedicalCapability.new()
							$eMedicalCapability.UUID_ConsultationKind:=$consultationKind.UUID
							$eMedicalCapability.UUID_MedicalStaff:=$eStaff.UUID
							$eMedicalCapability.UUID_MedicalHouse:=$esMedicalHouse[$triplet.mh].UUID
							$eMedicalCapability.schedule:=New object:C1471("default"; New object:C1471)
							$eMedicalCapability.schedule.default.min:=$consultationKind.minDuration
							$eMedicalCapability.schedule.default.work:=$workingRanges
							
							$excepts:=New collection:C1472(1; 2; 3; 4; 5; 6; 7)
							$indexOfCurrentDayNum:=$excepts.indexOf($triplet.dayNum)
							$excepts.remove($indexOfCurrentDayNum)
							$workingDurationAffected:=$workingDurationAffected+$workingNextDuration
							
							$eMedicalCapability.schedule.default.except:=$excepts
							$eMedicalCapability.save()
							
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
					
				: ($consultationKind.schedule.fullday#Null:C1517)
					
					
					$daysIndices:=New collection:C1472()
					While ($daysIndices.length<5)
						$workingQuarters:=sfw_schedule_getWorkingQuarters($consultationKind.schedule.fullday.work)
						If ($consultationKind.schedule.fullday1#Null:C1517)
							If (Random:C100%2=1)
								$workingQuarters:=sfw_schedule_getWorkingQuarters($consultationKind.schedule.fullday1.work)
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
							If ($quatersAvailable.countValues(1)>=($consultationKind.minDuration/900))
								$max:=sfw_schedule_getMaxIRQuarters($quatersAvailable)
								If ($max>=($consultationKind.minDuration/900))
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
							
							$eMedicalCapability:=ds:C1482.MedicalCapability.new()
							$eMedicalCapability.UUID_ConsultationKind:=$consultationKind.UUID
							$eMedicalCapability.UUID_MedicalStaff:=$eStaff.UUID
							$eMedicalCapability.UUID_MedicalHouse:=$esMedicalHouse[$daysIndices[$indexOfDayNum].mh].UUID
							$eMedicalCapability.schedule:=New object:C1471("default"; New object:C1471)
							$eMedicalCapability.schedule.default.min:=$consultationKind.minDuration
							$eMedicalCapability.schedule.default.work:=$workingRanges
							
							$excepts:=New collection:C1472(1; 2; 3; 4; 5; 6; 7)
							$indexOfCurrentDayNum:=$excepts.indexOf($dayNum)
							$excepts.remove($indexOfCurrentDayNum)
							$workingDurationAffected:=$workingDurationAffected+$workingNextDuration
							
							
							$eMedicalCapability.schedule.default.except:=$excepts
							$eMedicalCapability.save()
							
							
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
			
			$consultationKind.nbMedicalStaff:=$consultationKind.nbMedicalStaff-1
		End if 
		
	End for each 
	
End for each 


