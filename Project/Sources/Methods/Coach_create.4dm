//%attributes = {}
#DECLARE ($itemToCreate : Object)->$newEntity : Object



$newEntity:=ds:C1482.Coach.new()
$newEntity.fromObject($itemToCreate)
$newEntity.save()

