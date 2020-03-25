;===============================================================================
;	kml.pro
;		KML output package for IDL
;
;			2006-10-30 Saito-A
;
;	CHANGE
;		2006-12-15 Saito-A: Clean-up. Cube_KML is added.
;		2006-12-27 nobuyuki: add Normal in Plygon_KML & Cube_KML
;		2007-02-18 Saito-A: Satellite_KML, Map_KML & Arrow_KML are added.
;		2007-02-22 Saito-A: Satellite_KML, Map_KML bugs are fixed.
;		2007-03-02 Saito-A: "no_mark" is added in Arrow_KML
;		2007-06-01 Saito-A: Polygon_KML, "S_Time" & "E_Time" are added.
;		2007-06-04 Saito-A: Satellite_KML, "S_Time" & "E_Time" are added.
;               2008-01-17 Saito-A: Color_KML, RGB colors are added.
;		                    Close_KML, "Free_LUN" is added.
;		                    Map_KML, use Write_PNG for Transparent image
;		2008-01-20 Saito-A: Map_KML_M: for monthly map from "clouds"
;				    Arrow_KML: Car2pol version from "NICT_RTmodel"
;		2008-09-20 Polygon_KML: Extrude is added.
;		2008-09-20 Saito-A: Colorbar_KML: Make color bar for color plot
;
;
;===============================================================================
;===============================================================================
	Function  Open_KML, File_Name, File_Unit
;===============================================================================
;	Open KML file
;
;	Input: KML file name
;	Output: File Unit Number
;	Return: File Open Status
;	Usage:
;	      I_err=Open_KML('test.kml',I_Unit)
;
;		2006-10-30 Saito-A
;
;-------------------------------------------------------------------------------
openw,File_Unit,File_Name, ERR=error_ID, /GET_LUN
Error_ID=0

printf, File_Unit, '<?xml version="1.0" encoding="UTF-8"?> '
printf, File_Unit, '<kml xmlns="http://earth.google.com/kml/2.0"> <Document>'

 printf, File_Unit, '<Style id="VAsh">'+  $
    '<BalloonStyle><text><![CDATA[$[description]]]>'+  $
    '</text></BalloonStyle>'+  $

    '<IconStyle><Icon><href>'+  $
    'http://maps.google.com/mapfiles/kml/shapes/volcano.png' + $
    '</href></Icon></IconStyle></Style>'

return, Error_ID

end

