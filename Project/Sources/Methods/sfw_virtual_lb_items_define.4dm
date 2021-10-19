//%attributes = {}

var $nil : Pointer
var $table : Pointer
var $current_panel : Text

$columnFormula:="This.name"
$columnType:=Is text:K8:3
LISTBOX INSERT COLUMN FORMULA:C970(*; "lb_items"; 1000; "col_1"; $columnFormula; $columnType; "header_1"; $nil)
LISTBOX SET PROPERTY:C1440(*; "col_1"; lk multi style:K53:71; lk yes:K53:69)
OBJECT SET TITLE:C194(*; "header_1"; sfw_xliff_read("healthdashboard.lb_items.hearder1"; "name"))

LISTBOX SET PROPERTY:C1440(*; "lb_items"; lk sortable:K53:45; lk no:K53:68)
OBJECT GET SUBFORM:C1139(*; "detail_panel"; $table; $current_panel)
If ($current_panel#"sfw_panel_default")
	OBJECT SET SUBFORM:C1138(*; "detail_panel"; "sfw_panel_default")
End if 