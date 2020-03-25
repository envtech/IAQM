;===============================================================================
Pro  addModelImage_KML, File_Unit,Image_ROI,MODNAME=Modname,  $
     MODFILE=Modfile,KMLTIME=Kmltime
;===============================================================================
;		2013-6-2 Kwonho Lee
;
;-------------------------------------------------------------------------------

printf, File_Unit,'<GroundOverlay>'
printf, File_Unit,'<name> '+Modname+' </name>'
;printf, File_Unit,'<TimeSpan><begin>'+Kmltime(0)+'</begin>'
;printf, File_Unit,'          <end>'+Kmltime(1)+'</end></TimeSpan>'

; So here are 10% increments
; FF  100%  E6 CC B3 99 80 66 80 33 1A 0   0%
printf, File_Unit,'<color>73ffffff</color>'  ; opacity

printf, File_Unit,'<Icon> <href>'+Modfile+'</href>'
printf, File_Unit,'<viewBoundScale>1</viewBoundScale></Icon>'
printf, File_Unit,'<LatLonBox>'  +$
        '<north>'+strtrim(string(Image_ROI(1)),2)+'</north>'  +$
        '<south>'+strtrim(string(Image_ROI(0)),2)+'</south>' +$
        '<east>'+strtrim(string(Image_ROI(3)),2)+'</east>'   +$
        '<west>'+strtrim(string(Image_ROI(2)),2)+'</west>'  +$
        '</LatLonBox>'
printf, File_Unit,'</GroundOverlay>'

end