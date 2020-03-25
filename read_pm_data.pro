pro read_pm_data,pm_file,  $
                 tot_pm,pm_yyyy,pm_mm,pm_dd,   $
                 pm_sampint_time,pm25,oc
  
tot_pm=file_lines(pm_file)-1

pm_yyyy=strarr(tot_pm)
pm_mm=strarr(tot_pm)
pm_dd=strarr(tot_pm)

pm_sampint_time=fltarr(tot_pm)
pm25=fltarr(tot_pm)
oc=fltarr(tot_pm)

dum=''
delimiter=','

openr,lun,pm_file,/get_lun
readf,lun,dum
for i=0, tot_pm-1 do begin
  readf,lun,dum
  ivar = strsplit(strcompress(dum),delimiter,/extract, preserve=preserve_null)
  isov=size(ivar,/dimensions)

  ;2014-12-07 24  23.22 13.67
  pm_date = strtrim(ivar(0),2)
  
  pm_yyyy(i)=strmid(pm_date,0,4)
  pm_mm(i)=strmid(pm_date,5,2)
  pm_dd(i)=strmid(pm_date,8,2)

  pm_sampint_time(i)=float(ivar(1))
  pm25(i)=float(ivar(2))
  oc(i)=float(ivar(3))
endfor

free_lun,lun

end