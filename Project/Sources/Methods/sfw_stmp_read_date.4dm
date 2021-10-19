//%attributes = {}
// sfw_stmp_read_date (stmp : integer ) -> Date

#DECLARE ($stmp : Integer)->$date : Date

$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)

$nbjours:=$stmp\86400

$date:=$date_reference+$nbjours