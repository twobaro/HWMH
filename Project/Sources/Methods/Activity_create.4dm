//%attributes = {}
#DECLARE ($itemToCreate : Object)->$newEntity : Object


$newEntity:=ds:C1482.Activity.new()
$newEntity.fromObject($itemToCreate)
$newEntity.save()
