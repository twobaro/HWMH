Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		$color:=Form:C1466.vision.toolbar.color
		OBJECT SET RGB COLORS:C628(*; "bkgd_topBar"; $color; $color)
		
		Form:C1466.objects:=New object:C1471
		Form:C1466.objects.Pup_medicalHouse:=New object:C1471
		Form:C1466.objects.Pup_medicalStaff:=New object:C1471
		ConsultationKind_load_cache
		MedicalHouse_load_cache
		Form:C1466.UUID_ConsultationKind:=""
		Form:C1466.UUID_MedicalHouse:=""
		Form:C1466.UUID_MedicalStaff:=""
		Form:C1466.UUID_Person:=""
		
		Form:C1466.searchPersonES:=Null:C1517
		Form:C1466.inputPersonFirstName:=""
		Form:C1466.inputPersonLastName:=""
		Form:C1466.dateFrom:=Current date:C33+1
		Form:C1466.duration:=?00:15:00?
		
		Form:C1466.lb_slots:=New collection:C1472
		
		wizard_newAppointment_Redraw
		
		SET TIMER:C645(60)  // 1 minute
		
	: (FORM Event:C1606.code=On Timer:K2:25)
		For each ($oSlot; Form:C1466.lb_slots)
			$entity:=$oSlot.entity
			If ($entity.idStatus=-1)
				$entity.chronoStatus.expiration:=sfw_stmp_now+900
				$entity.save()
			End if 
		End for each 
		
		
	: (FORM Event:C1606.code=On Unload:K2:2)  //| (FORM Event.code=On Close Box)
		
		For each ($oSlot; Form:C1466.lb_slots)
			$entity:=$oSlot.entity
			If ($entity.idStatus=-1)
				$entity.drop()
			End if 
		End for each 
		
	: (FORM Event:C1606.code=On Close Box:K2:21)
		
		For each ($oSlot; Form:C1466.lb_slots)
			$entity:=$oSlot.entity
			If ($entity.idStatus=-1)
				$entity.drop()
			End if 
		End for each 
		ACCEPT:C269
		
End case 