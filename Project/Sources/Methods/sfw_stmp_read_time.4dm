//%attributes = {}
// sfw_stmp_read_time (stmp : integer ) -> Time

#DECLARE ($stmp : Integer)->$time : Time

$time:=Time:C179($stmp%86400)
