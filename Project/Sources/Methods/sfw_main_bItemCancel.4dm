//%attributes = {}
var $callbackBeforeCancel : Text

$callbackBeforeCancel:=Form:C1466.entry.dataclass+"_beforeCancel"
If (sfw_methodExist($callbackBeforeCancel))
	EXECUTE METHOD:C1007($callbackBeforeCancel; *; Form:C1466.subForm)
End if 


Form:C1466.current_item.reload()
Form:C1466.subForm.calculation:=New object:C1471
Form:C1466.subForm:=Form:C1466.subForm
Form:C1466.lb_items:=Form:C1466.lb_items

