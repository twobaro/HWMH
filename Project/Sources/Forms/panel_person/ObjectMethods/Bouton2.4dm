$mh:=ds:C1482.MedicalHouse.new()

$mh.fromObject(Form:C1466.current_item.toObject())

$mh.save()
