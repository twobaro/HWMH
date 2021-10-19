//%attributes = {}
If (Application type:C494=4D Local mode:K5:1)
	sfw_country_clear_cache
Else 
	EXECUTE ON CLIENT:C651("@"; "sfw_country_clear_cache")
End if 
