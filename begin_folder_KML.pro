;===============================================================================
	Pro  Begin_Folder_KML,  File_Unit, NAME=Name, TIME=Time
;===============================================================================
;	Begin Foler in KML file
;
;	Input: File Unit Number
;       Input(Optional)
;              Name: Name of Folder [String]
;	       Time: Time in KML format e.g., "2006-12-15T17:00:25Z"
;	Usage:
;	       Begin_Folder_KML, I_Unit
;	       Begin_Folder_KML, I_Unit, Name='Folder 1'
;	       Begin_Folder_KML, I_Unit, Name='Folder 1', Time='2006-12-15'
;
;		2006-10-30 Saito-A
;
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Default_Name='Folder'
if KEYWORD_SET(Name) EQ 0 then Name=Default_Name
;-------------------------------------------------------------------------------

printf, File_Unit,  '<Folder><name> '+Name+' </name>'
if KEYWORD_SET(Time) then printf, File_Unit,  '<TimeStamp><when>'+Time+'</when></TimeStamp>'

end

