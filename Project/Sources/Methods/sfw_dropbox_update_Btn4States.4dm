//%attributes = {}
$dropbox_folder:=Get 4D folder:C485(Database folder:K5:14)+"dropbox"+Folder separator:K24:12


$folder_icon:=$dropbox_folder+"icon"+Folder separator:K24:12
$folder_btn:=$dropbox_folder+"btn4states"+Folder separator:K24:12
DOCUMENT LIST:C474($folder_icon; $_document_icon)
DOCUMENT LIST:C474($folder_btn; $_document_btn)
For ($i; 1; Size of array:C274($_document_icon); 1)
	If (Find in array:C230($_document_btn; $_document_icon{$i})<=0) & ($_document_icon{$i}#".@")
		$image:=sfw_tool_icon_create4states($folder_icon+$_document_icon{$i}; $folder_btn)
	End if 
End for 
