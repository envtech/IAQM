;----------------------------------------------------------------------------
function closest, array, value
  ;+
  ; NAME:
  ; CLOSEST
  ;
  ; PURPOSE:
  ; Find the two elements of ARRAY that is the closest in value
  ;
  ; CATEGORY:
  ; utilities
  ;
  ; CALLING SEQUENCE:
  ; index = CLOSEST(array,value)
  ;
  ; INPUTS:
  ; ARRAY = the array to search
  ; VALUE = the value we want to find the closest approach to
  ;
  ; OUTPUTS:
  ; INDEX = the index into ARRAY which is the element closest to VALUE
  ;
  ;   OPTIONAL PARAMETERS:
  ; none
  ;
  ; COMMON BLOCKS:
  ; none.
  ; SIDE EFFECTS:
  ; none.
  ; 
  ; MODIFICATION HISTORY:
  ; Written by: Kwonho Lee, 
  ;
  ;-
  
  if (n_elements(array) le 0) or (n_elements(value) le 0) then index=-1 $
  else if (n_elements(array) eq 1) then index=0 $
  else begin
    abdiff = abs(array-value)  ;form absolute difference
    index = sort(abdiff)  ;find smallest difference
  endelse
  
  return,index
end
