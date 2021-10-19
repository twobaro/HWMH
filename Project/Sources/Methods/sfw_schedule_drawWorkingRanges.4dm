//%attributes = {}
#DECLARE ($workingRanges : Collection)->$pict : Picture


$refSVG:=SVG_New(480; 22)

$quarterSize:=5

If ($workingRanges.length=96)
	$current:=0
	$start:=-1
	$end:=-1
	For ($q; 0; 95)
		If ($workingRanges[$q]#$current)
			If ($start=-1)
				$start:=$q
				$current:=$workingRanges[$q]
			Else 
				$end:=$q
				$barHeight:=22
				$barTop:=0
				$color:=sfw_shades_getColorWorkingRange($current)
				Case of 
					: ($current=1)
						$barTop:=11
						$barHeight:=11
				End case 
				$refRect:=SVG_New_rect($refSVG; \
					$start*$quarterSize; \
					$barTop; \
					($end-$start)*$quarterSize; \
					$barHeight; \
					0; 0; $color; $color; 0)
				SVG_SET_ID($refRect; String:C10($start)+"-"+String:C10($end))
				If ($workingRanges[$q]=0)
					$start:=-1
				Else 
					$start:=$q
				End if 
				$end:=-1
				$current:=$workingRanges[$q]
			End if 
		End if 
	End for 
Else 
	While ($workingRanges.length>0)
		$start:=$workingRanges.shift()/900
		$end:=$workingRanges.shift()/900
		$refRect:=SVG_New_rect($refSVG; \
			$start*$quarterSize; \
			0; \
			($end-$start)*$quarterSize; \
			22; \
			0; 0; "cyan"; "cyan"; 0)
		SVG_SET_ID($refRect; String:C10($start)+"-"+String:C10($end))
	End while 
End if 

For ($h; 1; 23)
	$refRect:=SVG_New_line($refSVG; \
		$h*4*$quarterSize; \
		16; \
		$h*4*$quarterSize; \
		22; \
		"black"; 0.5)
	$refText:=SVG_New_text($refSVG; String:C10($h); \
		$h*4*$quarterSize; \
		2; \
		"Helvetica"; 8; Plain:K14:1; 3; "Black")
End for 
For ($q; 1; 95)
	$refRect:=SVG_New_line($refSVG; \
		$q*$quarterSize; \
		18; \
		$q*$quarterSize; \
		22; \
		"grey"; 0.5)
End for 
SVG EXPORT TO PICTURE:C1017($refSVG; $pict)
SVG_CLEAR($refSVG)