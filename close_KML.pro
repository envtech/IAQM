;===============================================================================
	Pro  Close_KML, File_Unit
;===============================================================================
;	Close KML file
;
;	Input: File Unit Number
;	Usage:
;	       Close_KML,  I_Unit
;
;		2006-10-30 Saito-A
;
;-------------------------------------------------------------------------------

printf, File_Unit,  '</Document> </kml>'
close, File_Unit
free_lun, File_Unit

end

