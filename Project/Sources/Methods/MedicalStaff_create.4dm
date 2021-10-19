//%attributes = {}
#DECLARE ($itemToCreate : Object)->$newEntity : Object

$newEntity:=ds:C1482.MedicalStaff.new()
$newEntity.fromObject($itemToCreate)
$newEntity.save()
