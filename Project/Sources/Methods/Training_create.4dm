//%attributes = {}
#DECLARE($itemToCreate : Object)->$newEntity : Object


$newEntity:=ds:C1482.Training.new()
$newEntity.fromObject($itemToCreate)
$newEntity.save()
