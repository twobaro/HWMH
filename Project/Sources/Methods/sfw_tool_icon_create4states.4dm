//%attributes = {}
#DECLARE ($imgPath : Text; $destinationFolder : Text)->$picture : Picture

var $imgPath; $imgPathPOSIX; $tmpFolder; $phpPath; $result : Text

$imgPathPOSIX:=Convert path system to POSIX:C1106($imgPath)
$destinationFolderPOSIX:=Convert path system to POSIX:C1106($destinationFolder)

$phpPath:=Get 4D folder:C485(Current resources folder:K5:16)+"sfw"+Folder separator:K24:12+"php"+Folder separator:K24:12+"images.php"

If (Test path name:C476($imgPath)=Is a document:K24:1) & ($imgPath="@.png")
	
	$phpOK:=PHP Execute:C1058($phpPath; "setImageStates"; $result; $imgPathPOSIX; $destinationFolderPOSIX)
	
	READ PICTURE FILE:C678($destinationFolder+$result; $picture)
End if 