
If (Form:C1466.period#Null:C1517)
	CONFIRM:C162("Are you sure that you want to delete this period: "+Form:C1466.period.name; "Delete"; "Cancel")
	If (ok=1)
		OB REMOVE:C1226(Form:C1466.schedule; Form:C1466.period.name)
		Form:C1466.schedule:=Form:C1466.schedule
		sfw_subpanel_schedule_draw
		CALL SUBFORM CONTAINER:C1086(-98001)
		
	End if 
End if 

