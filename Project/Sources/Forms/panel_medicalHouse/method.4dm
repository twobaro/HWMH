sfw_panel_formMethod


If (FORM Event:C1606.code=On Load:K2:1)
	Form:C1466.scheduleSubForm:=New object:C1471
	Form:C1466.scheduleSubForm_ms:=New object:C1471
	If (Form:C1466.lb_lessonCapabilities=Null:C1517)
		Form:C1466.lb_lessonCapabilities:=New collection:C1472
	End if 
	If (Form:C1466.lb_medicalCapabilities=Null:C1517)
		Form:C1466.lb_medicalCapabilities:=New collection:C1472
	End if 
End if 

If (Form:C1466.current_item.level=0)
	Form:C1466.current_item.level:=1
End if 
If (Form:C1466.current_item.level>3)
	Form:C1466.current_item.level:=3
End if 
(OBJECT Get pointer:C1124(Object named:K67:5; "levelLabel")->):=sfw_xliff_read("medicalHouse.level"+String:C10(Form:C1466.current_item.level); "level"+String:C10(Form:C1466.current_item.level))

Case of 
	: (FORM Event:C1606.code=On Display Detail:K2:22)
	: (FORM Get current page:C276(*)=2)  // lessonCapabilities
		
		MedicalHouse_pageLessonCapab
		
	: (FORM Get current page:C276(*)=3)  // MedicalCapabilities
		
		MedicalHouse_pageMedicalCapab
		
		
End case 