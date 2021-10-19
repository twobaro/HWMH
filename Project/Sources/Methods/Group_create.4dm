//%attributes = {}
#DECLARE ($itemToCreate : Object)->$newEntity : Object

$newEntity:=ds:C1482.Group.new()
$newEntity.fromObject($itemToCreate)
$newEntity.save()

