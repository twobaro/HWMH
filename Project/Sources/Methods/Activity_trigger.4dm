//%attributes = {}
If (Application type:C494=4D Local mode:K5:1)
	Activity_clear_cache
Else 
	EXECUTE ON CLIENT:C651("@"; "Activity_clear_cache")
End if 
