//%attributes = {}
#DECLARE ($duration : Integer)->$answer : Text

C_LONGINT:C283($2)

If (Count parameters:C259>1)
	$nb_Segment_max:=$2
Else 
	$nb_Segment_max:=2
End if 
$answer:=""

$continue:=True:C214
$nb_segment:=0
$jour:=True:C214
$heure:=True:C214
$minute:=True:C214
While ($continue)
	Case of 
		: ($duration>(23*60*60)) & ($jour)
			$nb_jour:=$duration\(24*60*60)
			If ($nb_jour=0)
				$jour:=False:C215
			Else 
				$answer:=$answer+String:C10($nb_jour)+" j "
				$nb_segment:=$nb_segment+1
			End if 
			$duration:=$duration-($nb_jour*(24*60*60))
		: ($duration>(59*60)) & ($heure)
			$nb_heure:=$duration\(60*60)
			If ($nb_heure=0)
				$heure:=False:C215
			Else 
				$answer:=$answer+String:C10($nb_heure)+" h "
				$nb_segment:=$nb_segment+1
			End if 
			$duration:=$duration-($nb_heure*(60*60))
		: ($duration>59) & ($minute)
			$nb_min:=$duration\60
			If ($nb_min=0)
				$minute:=False:C215
			Else 
				$answer:=$answer+String:C10($nb_min)+" min "
				$nb_segment:=$nb_segment+1
			End if 
			$duration:=$duration-($nb_min*60)
		Else 
			$answer:=$answer+String:C10($duration)+" sec "
			$duration:=0
			$nb_segment:=$nb_segment+1
	End case 
	
	If ($nb_segment>=$nb_Segment_max) | ($duration=0)
		$continue:=False:C215
		
	End if 
End while 

If ($answer="")
	$answer:="-"
End if 

