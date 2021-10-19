//%attributes = {}
Case of 
	: (Form:C1466.entry.dataclass#Null:C1517)
		
		$somethingToSaveOrCancel:=(String:C10(Form:C1466.situation.changeToSaveOrCancel)#"")
		
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; sfw_xliff_read("crud.mode.visualization"; "Visualization"))
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/skin/rainbow/icon/eye-24x24.png")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "view")
		If (Form:C1466.situation.mode="View")
			SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
		End if 
		If (Form:C1466.situation.mode="none") | (Form:C1466.lb_items.length=0) | ($somethingToSaveOrCancel)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		APPEND MENU ITEM:C411($refMenu; sfw_xliff_read("crud.mode.modification"; "Modification"))
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/skin/rainbow/icon/edit-24x24.png")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "modify")
		If (Form:C1466.situation.mode="modify")
			SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
		End if 
		If (Form:C1466.current_item=Null:C1517) | (Form:C1466.situation.mode="add") | (Form:C1466.situation.mode="none") | ($somethingToSaveOrCancel)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		APPEND MENU ITEM:C411($refMenu; sfw_xliff_read("crud.mode.creation"; "Creation"))
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/skin/rainbow/icon/add-24x24.png")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "add")
		If (Form:C1466.situation.mode="add")
			SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
		End if 
		If ($somethingToSaveOrCancel)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		APPEND MENU ITEM:C411($refMenu; sfw_xliff_read("crud.mode.deletion"; "Deletion"))
		SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/skin/rainbow/icon/trash-24x24.png")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "delete")
		If (Form:C1466.situation.mode="delete")
			SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
		End if 
		If (Form:C1466.current_item=Null:C1517) | (Form:C1466.situation.mode="add") | (Form:C1466.situation.mode="none") | ($somethingToSaveOrCancel)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		RELEASE MENU:C978($refMenu)
		
		If ($choose#"")
			$previousMode:=Form:C1466.situation.mode
			Form:C1466.situation.mode:=$choose
			Form:C1466.subForm:=Form:C1466.subForm
			
			Form:C1466.lb_items:=Form:C1466.lb_items
			
			$reload:=False:C215
			Case of 
				: (Form:C1466.situation.mode="view")
					
					$reload:=($previousMode#Form:C1466.situation.mode)
					If ($previousMode="add")
						$reload:=False:C215
						Form:C1466.current_item:=Null:C1517
						sfw_lb_items_selectionChange
						
					End if 
					
				: (Form:C1466.situation.mode="add")
					LISTBOX SELECT ROW:C912(*; "lb_items"; 0; lk remove from selection:K53:3)
					Form:C1466.current_item:=New object:C1471
					$dataclassObject:=ds:C1482[Form:C1466.entry.dataclass]
					For each ($attributeName; $dataclassObject)
						$attribute:=$dataclassObject[$attributeName]
						If ($attribute.kind="storage")
							Case of 
								: ($attribute.type="string")
									Form:C1466.current_item[$attributeName]:=""
								: ($attribute.type="object")
									Form:C1466.current_item[$attributeName]:=New object:C1471
								: ($attribute.type="number")
									Form:C1466.current_item[$attributeName]:=0
								: ($attribute.type="date")
									Form:C1466.current_item[$attributeName]:=!00-00-00!
								: ($attribute.type="time")
									Form:C1466.current_item[$attributeName]:=?00:00:00?
							End case 
						End if 
					End for each 
					sfw_lb_items_selectionChange
					
				: (Form:C1466.situation.mode="delete")
					$reload:=($previousMode#Form:C1466.situation.mode)
					
				Else 
					//modify
					$reload:=($previousMode#Form:C1466.situation.mode)
					$info:=Form:C1466.current_item.lock()
					If ($info.success=False:C215)
						Form:C1466.situation.mode:="view"
						$reload:=($previousMode#Form:C1466.situation.mode)
					Else 
						
					End if 
					
			End case 
			
			If ($reload)
				If (Form:C1466.current_item#Null:C1517)
					Form:C1466.current_item.reload()
				End if 
			End if 
			Form:C1466.subForm:=Form:C1466.subForm
			sfw_main_draw_button
			
		End if 
		
		
	: (Form:C1466.entry.virtual="collection")
		$refMenu:=Create menu:C408
		
		For each ($action; Form:C1466.current_item.actions)
			APPEND MENU ITEM:C411($refMenu; sfw_xliff_read($action.xliff; $action.label))
			SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/skin/rainbow/icon/action-24x24.png")
			SET MENU ITEM PARAMETER:C1004($refMenu; -1; $action.method)
			
		End for each 
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		RELEASE MENU:C978($refMenu)
		
		If ($choose#"")
			ARRAY TEXT:C222($_names; 0)
			METHOD GET NAMES:C1166($_names)
			If (Find in array:C230($_names; $choose)>0)
				EXECUTE METHOD:C1007($choose)
			End if 
		End if 
		
End case 