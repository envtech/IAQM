pro gday2jday,year,month,gday,jday

normalyear=[31,28,31,30,31,30,31,31,30,31,30,31]
leapyear=[31,29,31,30,31,30,31,31,30,31,30,31]


if (year mod 4) eq 0 then begin
  currentyear=leapyear
endif else begin
  currentyear=normalyear
endelse

if month eq 1 then begin
  jday=gday
endif else begin
  jday=fix(total(currentyear[0:month-2])+gday)
endelse


end