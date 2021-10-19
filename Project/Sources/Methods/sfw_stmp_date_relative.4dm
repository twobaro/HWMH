//%attributes = {}
#DECLARE ($stmp : Integer)->$result : Text

var $date : Date

$date:=sfw_stmp_read_date($stmp)
$result:=sfw_date_relative($date)