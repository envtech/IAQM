pro jday2gday,year,month,jday,gday

;============================================================
; julian day to gragorian day
; input
;     yy : year
;     jday: julian day (1-365, 366)
; output
;     month :
;     gday
;============================================================

normalyear=[31,28,31,30,31,30,31,31,30,31,30,31]
leapyear=[31,29,31,30,31,30,31,31,30,31,30,31]

if (year MOD 4) eq 0 then begin
  currentyear=leapyear
endif else begin
  currentyear=normalyear
endelse

if jday le 31 then begin
  month=0
endif else begin
  month=0
  while total(currentyear[0:month]) lt jday do begin
    month=month+1
  endwhile
endelse

if jday le 31 then begin
 Gday=fix(jday)
endif else begin
 Gday=fix(jday-total(currentyear[0:month-1]))
endelse

month=month+1

end