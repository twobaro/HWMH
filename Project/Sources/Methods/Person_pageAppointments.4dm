//%attributes = {}
var $eAppointment : cs:C1710.AppointmentEntity
var $ePrivateLesson : cs:C1710.PrivateLessonEntity
var $eGroupLesson : cs:C1710.GroupLesson
var $eGroup : cs:C1710.GroupEntity

If (String:C10(Form:C1466.current_item.UUID)#"")
	If (String:C10(Form:C1466.calculation.loadAppointmentsForUUID)#Form:C1466.current_item.UUID)
		Form:C1466.calculation.loadAppointmentsForUUID:=Form:C1466.current_item.UUID
		Form:C1466.lb_appointments:=New collection:C1472
		MedicalHouse_load_cache
		Activity_load_cache
		ConsultationKind_load_cache
		
		$meta:=New object:C1471
		$meta.fill:="#A6C1D5"
		
		For each ($eAppointment; Form:C1466.current_item.appointments)
			$appointement:=New object:C1471
			$appointement.UUID:=$eAppointment.UUID
			$appointement.dataclass:="Appointment"
			$appointement.type:=sfw_xliff_read("appointment.typeMedical"; "medical")
			$appointement.startStmp:=$eAppointment.startStmp
			$appointement.date:=sfw_stmp_read_date($eAppointment.startStmp)
			$appointement.time:=String:C10(sfw_stmp_read_time($eAppointment.startStmp); HH MM:K7:2)
			$appointement.duration:=String:C10(sfw_stmp_read_time($eAppointment.duration); HH MM:K7:2)
			$appointement.medicalHouse:=MedicalHouse_getFromCache($eAppointment.UUID_MedicalHouse).name
			$appointement.staff:=MedicalStaff_getFullName($eAppointment.medicalStaff)
			$appointement.purpose:=ConsultationKind_getFromCache($eAppointment.UUID_ConsultationKind).name
			$appointement.meta:=$meta
			Form:C1466.lb_appointments.push($appointement)
		End for each 
		
		$meta:=New object:C1471
		$meta.fill:="#D7E6A9"
		
		For each ($ePrivateLesson; Form:C1466.current_item.privateLessons)
			$appointement:=New object:C1471
			$appointement.UUID:=$ePrivateLesson.UUID
			$appointement.dataclass:="PrivateLesson"
			$appointement.type:=sfw_xliff_read("appointment.typePrivateLesson"; "Private lesson")
			$appointement.startStmp:=$ePrivateLesson.startStmp
			$appointement.date:=sfw_stmp_read_date($ePrivateLesson.startStmp)
			$appointement.time:=String:C10(sfw_stmp_read_time($ePrivateLesson.startStmp); HH MM:K7:2)
			$appointement.duration:=String:C10(sfw_stmp_read_time($ePrivateLesson.duration); HH MM:K7:2)
			$appointement.medicalHouse:=MedicalHouse_getFromCache($ePrivateLesson.UUID_MedicalHouse).name
			$appointement.staff:=Coach_getFullName($ePrivateLesson.coach)
			$appointement.purpose:=Activity_getFromCache($ePrivateLesson.UUID_Activity).name
			$appointement.meta:=$meta
			Form:C1466.lb_appointments.push($appointement)
		End for each 
		
		$meta:=New object:C1471
		$meta.fill:="#E7F6B9"
		
		For each ($eGroup; Form:C1466.current_item.groupMembers.group)
			For each ($eGroupLesson; $eGroup.groupLessons)
				$appointement:=New object:C1471
				$appointement.UUID:=$eGroupLesson.UUID
				$appointement.dataclass:="PrivateLesson"
				$appointement.type:=sfw_xliff_read("appointment.typeGroupLesson"; "Group lesson")
				$appointement.startStmp:=$eGroupLesson.startStmp
				$appointement.date:=sfw_stmp_read_date($eGroupLesson.startStmp)
				$appointement.time:=String:C10(sfw_stmp_read_time($eGroupLesson.startStmp); HH MM:K7:2)
				$appointement.duration:=String:C10(sfw_stmp_read_time($eGroupLesson.duration); HH MM:K7:2)
				$appointement.medicalHouse:=MedicalHouse_getFromCache($eGroupLesson.UUID_MedicalHouse).name
				$appointement.staff:=Coach_getFullName($eGroupLesson.coach)
				$appointement.purpose:=Activity_getFromCache($eGroupLesson.UUID_Activity).name
				$appointement.meta:=$meta
				Form:C1466.lb_appointments.push($appointement)
			End for each 
		End for each 
		Form:C1466.lb_appointments:=Form:C1466.lb_appointments.orderBy("startStmp desc")
		Form:C1466.appointment_position:=0
	End if 
Else 
	If (Form:C1466.lb_appointments=Null:C1517)
	End if 
End if 