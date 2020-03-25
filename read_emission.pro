pro read_emission,et_file,   $
                  tot_et,et_yyyy,et_mm,  $
                  et_dd,et_time,et_prod,j

tot_et=file_lines(et_file)-2

et_yyyy=strarr(tot_et/3)
et_mm=strarr(tot_et/3)
et_dd=strarr(tot_et/3)
et_time=strarr(tot_et/3)
et_prod=fltarr(tot_et/3)

dum=''
delimiter=','

openr,lun,et_file,/get_lun
readf,lun,dum
readf,lun,dum
j=0
for i=0, tot_et-1 do begin
  readf,lun,dum
  ivar = strsplit(strcompress(dum),delimiter,/extract, preserve=preserve_null)
  isov=size(ivar,/dimensions)

  ;2014-12-07 24  23.22 13.67

  if fix(ivar(2)) eq 1 then begin
    et_yyyy(j)=strmid(ivar(1),0,4)
    et_mm(j)=strmid(ivar(1),5,2)
    et_dd(j)=strmid(ivar(1),8,2)
    et_time(j)=strtrim(ivar(4),2)
    et_prod(j)=strtrim(ivar(6),2)
    j=j+1
  endif

endfor
free_lun,lun

end