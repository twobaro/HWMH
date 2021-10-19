OBJECT GET COORDINATES:C663(*; "mainLogo"; $gMainLogo; $hMainLogo; $dMainLogo; $bMainLogo)
OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
$widthMainLogo:=$dMainLogo-$gMainLogo
$heightMainLogo:=$bMainLogo-$hMainLogo

OBJECT SET COORDINATES:C1248(*; "mainLogo"; \
($width/2)-($widthMainLogo/2); \
($height/2)-($heightMainLogo/2); \
($width/2)+($widthMainLogo/2); \
($height/2)+($heightMainLogo/2))
