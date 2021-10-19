//%attributes = {}
#DECLARE ()->$isInModification : Boolean

$isInModification:=((String:C10(Form:C1466.situation.mode)="modify") | (String:C10(Form:C1466.situation.mode)="add")) & (Bool:C1537(Form:C1466.notEditable)=False:C215)
