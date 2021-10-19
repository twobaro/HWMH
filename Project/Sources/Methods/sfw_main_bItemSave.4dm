//%attributes = {}
var $callbackBeforeSave : Text

$callbackBeforeSave:=Form:C1466.entry.dataclass+"_beforeSave"
If (sfw_methodExist($callbackBeforeSave))
	EXECUTE METHOD:C1007($callbackBeforeSave; *; Form:C1466.subForm)
End if 

Form:C1466.info:=Form:C1466.current_item.save()
Form:C1466.current_item.reload()  //necessary to refresh the related entities


sfw_main_draw_button

Form:C1466.subForm.calculation:=New object:C1471
Form:C1466.subForm:=Form:C1466.subForm