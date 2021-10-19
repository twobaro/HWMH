$ms:=ds:C1482.MedicalStaff.new()

$ms.fromObject(Form:C1466.current_item.toObject())

$ms.save()
