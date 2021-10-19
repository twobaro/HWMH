//%attributes = {}
#DECLARE ()->$continue : Boolean

$continue:=False:C215

If (String:C10(Form:C1466.situation.changeToSaveOrCancel)#"")
	$formData:=New object:C1471()
	Case of 
		: (Form:C1466.situation.mode="modify")
			$refConfirm:=Open form window:C675("sfw_dial_SaveCancelContinue"; Modal form dialog box:K39:7)
			DIALOG:C40("sfw_dial_SaveCancelContinue"; $formData)
			CLOSE WINDOW:C154($refConfirm)
			
		: (Form:C1466.situation.mode="add")
			$refConfirm:=Open form window:C675("sfw_dial_CreateRenounceContinue"; Modal form dialog box:K39:7)
			DIALOG:C40("sfw_dial_CreateRenounceContinue"; $formData)
			CLOSE WINDOW:C154($refConfirm)
			
	End case 
	Case of 
		: ($formData.action="continue")
			$continue:=False:C215
			
		: ($formData.action="cancel")
			sfw_main_bItemCancel
			$continue:=True:C214
			
		: ($formData.action="save")
			sfw_main_bItemSave
			$continue:=True:C214
			
		: ($formData.action="renounce")
			sfw_main_bItemRenounce
			$continue:=True:C214
			
		: ($formData.action="create")
			sfw_main_bItemCreate
			$continue:=True:C214
			
	End case 
	
Else 
	$continue:=True:C214
	
End if 
