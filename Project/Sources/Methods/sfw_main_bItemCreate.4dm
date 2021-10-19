//%attributes = {}
var $newEntity : Object
var $callbackBeforeSave : Text
var $callbackSave : Text
var $indexInEntitySelection : Integer

Form:C1466.current_item.UUID:=Generate UUID:C1066

$callbackBeforeSave:=Form:C1466.entry.dataclass+"_beforeSave"
If (sfw_methodExist($callbackBeforeSave))
	EXECUTE METHOD:C1007($callbackBeforeSave; *; Form:C1466.subForm)
End if 

$callbackSave:=Form:C1466.entry.dataclass+"_create"
If (sfw_methodExist($callbackSave))
	EXECUTE METHOD:C1007($callbackSave; $newEntity; OB Copy:C1225(Form:C1466.current_item))
Else 
	$newEntity:=ds:C1482[Form:C1466.entry.dataclass].new()
	$newEntity.fromObject(Form:C1466.current_item)
	$newEntity.save()
End if 

Form:C1466.subForm.calculation:=New object:C1471
Form:C1466.subForm:=Form:C1466.subForm

Form:C1466.lb_items.add($newEntity)
sfw_lb_items_sort
$indexInEntitySelection:=$newEntity.indexOf(Form:C1466.lb_items)
Form:C1466.lb_items:=Form:C1466.lb_items
LISTBOX SELECT ROW:C912(*; "lb_items"; $indexInEntitySelection+1; lk replace selection:K53:1)
Form:C1466.current_item:=Form:C1466.lb_items[$indexInEntitySelection]

Form:C1466.situation.mode:="Modify"  //whem we save a new item, we continue with the modify mode
sfw_lb_items_selectionChange
sfw_main_draw_button
