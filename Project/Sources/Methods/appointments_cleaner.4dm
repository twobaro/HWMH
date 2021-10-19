//%attributes = {}
#DECLARE ($level : Integer; $options : Object)



Case of 
	: (Count parameters:C259=0)
		$pr:=Execute on server:C373(Current method name:C684; 0; Current method name:C684; 1; *)
		
	: ($level=1)
		$options:=New object:C1471
		$options.lastDayForUpdateStatus:=Current date:C33
		appointments_update_status
		Repeat 
			appointments_cleaner(2; $options)
			DELAY PROCESS:C323(Current process:C322; 60*60)  // 1 minute
		Until (Process aborted:C672)
		
	: ($level=2)
		
		If ($options.lastDayForUpdateStatus#Current date:C33)
			$options.lastDayForUpdateStatus:=Current date:C33
			appointments_update_status
		End if 
		
		$before:=sfw_stmp_now
		$esAppointment:=ds:C1482.Appointment.query("chronoStatus.expiration < :1 & idStatus = -1"; $before)
		
		$notDropped:=$esAppointment.drop()
		//$notDropped will be drop at the next loop
		
End case 