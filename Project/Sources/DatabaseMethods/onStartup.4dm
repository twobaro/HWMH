sfw_on_startup_database

Get_infos
appointments_cleaner

If (Not:C34(Is compiled mode:C492))
	ARRAY TEXT:C222($tTxt_Components; 0)
	COMPONENT LIST:C1001($tTxt_Components)
	If (Find in array:C230($tTxt_Components; "4DPop")>0)
		EXECUTE METHOD:C1007("4DPop_Palette")
	End if 
End if 