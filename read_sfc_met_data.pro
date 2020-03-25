pro read_sfc_met_data,met_file,hr_lines,            $
                      hr_yyyy,hr_mm,hr_dd,hr_hour,  $
                      hr_temp,hr_humi,hr_dewp,hr_ws,hr_wd,  $
                      hr_pres,hr_rain,hr_srad


;-----------------------------------------
; read met data at Namwon
;-----------------------------------------                      
  tot_met=file_lines(met_file)-2

  met_yyyy=strarr(tot_met)
  met_mm=strarr(tot_met)
  met_dd=strarr(tot_met)
  met_time=strarr(tot_met)
  hour=fltarr(tot_met)

  met_temp=fltarr(tot_met)
  met_humi=fltarr(tot_met)
  met_dewp=fltarr(tot_met)

  met_ws=fltarr(tot_met)
  met_wd=fltarr(tot_met)
  met_pres=fltarr(tot_met)
  met_rain=fltarr(tot_met)
  met_srad=fltarr(tot_met)
  
  dum=''
  delimiter=','

  openr,lun,met_file,/get_lun

  readf,lun,dum
  readf,lun,dum

  apm=''
  met_wd_chr=''

  for i=0, tot_met-1 do begin
    readf,lun,dum
    ivar = strsplit(strcompress(dum),delimiter,/extract, preserve=preserve_null)
    isov=size(ivar,/dimensions)

    met_yyyy(i)=strmid(ivar(0),0,4)
    met_mm(i)=strmid(ivar(0),5,2)
    met_dd(i)=strmid(ivar(0),8,2)
    met_time(i)=strtrim(ivar(1),2)

    met_temp(i)=float(ivar(2))
    met_humi(i)=float(ivar(5))
    met_dewp(i)=float(ivar(6))

    met_ws(i)=float(ivar(7))

    met_wd_chr=strtrim(ivar(8),2)

    if met_wd_chr eq 'N' then met_wd(i)=0.
    if met_wd_chr eq 'NNE' then met_wd(i)=22.5
    if met_wd_chr eq 'NE' then met_wd(i)=45.
    if met_wd_chr eq 'ENE' then met_wd(i)=67.5

    if met_wd_chr eq 'E' then met_wd(i)=90.
    if met_wd_chr eq 'ESE' then met_wd(i)=112.5
    if met_wd_chr eq 'SE' then met_wd(i)=135.
    if met_wd_chr eq 'SSE' then met_wd(i)=157.5

    if met_wd_chr eq 'S' then met_wd(i)=180.
    if met_wd_chr eq 'SSW' then met_wd(i)=202.5
    if met_wd_chr eq 'SW' then met_wd(i)=225.
    if met_wd_chr eq 'WSW' then met_wd(i)=247.5

    if met_wd_chr eq 'W' then met_wd(i)=270.0
    if met_wd_chr eq 'WNW' then met_wd(i)=292.5
    if met_wd_chr eq 'NW' then met_wd(i)=315.0
    if met_wd_chr eq 'NNW' then met_wd(i)=337.5

    if met_wd_chr eq '---' then met_wd(i)=0.

    met_pres(i)=float(ivar(16))
    met_rain(i)=float(ivar(17))
    met_srad(i)=float(ivar(19))

    apm=strmid(met_time(i),strpos(met_time(i),':')+4,2)
    hour(i)=fix(strmid(met_time(i),0,strpos(met_time(i),':')))

    if apm eq 'AM' then begin
      hour(i)=fix(strmid(met_time(i),0,strpos(met_time(i),':')))
      if hour(i) eq 12 then hour(i)=0
    endif

    if apm eq 'PM' then begin
      if hour(i) eq 12 then begin
        hour(i)=fix(strmid(met_time(i),0,strpos(met_time(i),':')))
      endif else begin
        hour(i)=fix(strmid(met_time(i),0,strpos(met_time(i),':')))+12.
      endelse
    endif

  endfor
  free_lun,lun
  
  ;-----------------------------------------
  ; make hourly mean
  ;-----------------------------------------
  ih=0.

  tot_temp=0.
  tot_humi=0.
  tot_dewp=0.
  tot_ws=0.
  tot_wd=0.
  tot_pres=0.
  tot_rain=0.
  tot_srad=0.

  hourly_temp=-999.
  hourly_humi=-999.
  hourly_dewp=-999.
  hourly_ws=-999.
  hourly_wd=-999.
  hourly_pres=-999.
  hourly_rain=-999.
  hourly_srad=-999.
  
  hourly_met_file='temp_met_file.dat'
  openw,lunhr,hourly_met_file,/get_lun
  
  for i=0, tot_met-2 do begin
  
    ; find hourly values

    if hour(i) eq hour(i+1) then begin
  
      tot_temp=tot_temp+met_temp(i)
      tot_humi=tot_humi+met_humi(i)
      tot_dewp=tot_dewp+met_dewp(i)
      tot_ws=tot_ws+met_ws(i)
      tot_wd=tot_wd+met_wd(i)
      tot_pres=tot_pres+met_pres(i)
      tot_rain=tot_rain+met_rain(i)
      tot_srad=tot_srad+met_srad(i)
      ih=ih+1
    endif else begin
     
      if ih gt 1 then begin
        hourly_temp=tot_temp/ih
        hourly_humi=tot_humi/ih
        hourly_dewp=tot_dewp/ih
        hourly_ws=tot_ws/ih
        hourly_wd=tot_wd/ih
        hourly_pres=tot_pres/ih
        hourly_rain=tot_rain/ih
        hourly_srad=tot_srad/ih
      endif  
      if ih eq 0 then begin
        hourly_temp=met_temp(i)
        hourly_humi=met_humi(i)
        hourly_dewp=met_dewp(i)
        hourly_ws=met_ws(i)
        hourly_wd=met_wd(i)
        hourly_pres=met_pres(i)
        hourly_rain=met_rain(i)
        hourly_srad=met_srad(i)
      endif

      printf,lunhr,  $
             met_yyyy(i),met_mm(i),met_dd(i),hour(i),  $
             hourly_temp,hourly_humi,hourly_dewp,      $
             hourly_ws,hourly_wd,hourly_pres,          $
             hourly_rain,hourly_srad,format='(3a4,i4,8f15.5)'

      ih=0.

      tot_temp=0.
      tot_humi=0.
      tot_dewp=0.
      tot_ws=0.
      tot_wd=0.
      tot_pres=0.
      tot_rain=0.
      tot_srad=0.

      hourly_temp=-999.
      hourly_humi=-999.
      hourly_dewp=-999.
      hourly_ws=-999.
      hourly_wd=-999.
      hourly_pres=-999.
      hourly_rain=-999.
      hourly_srad=-999.

    endelse  ;hour(i)  
  
  endfor  
  free_lun,lunhr
  
  
  ;-----------------------------------------
  ; read hourly mean
  ;-----------------------------------------
  
  hr_lines=file_lines(hourly_met_file)
  
  hr_yyyy=strarr(hr_lines)
  hr_mm=strarr(hr_lines)
  hr_dd=strarr(hr_lines)
  hr_hour=fltarr(hr_lines)
  
  hr_temp=fltarr(hr_lines)
  hr_humi=fltarr(hr_lines)
  hr_dewp=fltarr(hr_lines)
  hr_ws=fltarr(hr_lines)
  hr_wd=fltarr(hr_lines)
  hr_pres=fltarr(hr_lines)
  hr_rain=fltarr(hr_lines)
  hr_srad=fltarr(hr_lines)
  
  openr,lunhr,hourly_met_file,/get_lun
  
  a1=''
  a2=''
  a3=''
  
  for ihr=0, hr_lines-1 do begin
    readf,lunhr,a1,a2,a3,d1,  $
          d2,d3,d4,d5,d6,d7,d8,d9,format='(3a4,i4,8f15.5)'
    hr_yyyy(ihr)=strtrim(a1,2)
    hr_mm(ihr) =strtrim(a2,2)
    hr_dd(ihr)  =strtrim(a3,2)
    hr_hour(ihr)=d1
    
    hr_temp(ihr)=d2
    hr_humi(ihr)=d3
    hr_dewp(ihr)=d4
    hr_ws(ihr)=d5
    hr_wd(ihr)=d6
    hr_pres(ihr)=d7
    hr_rain(ihr)=d8
    hr_srad(ihr)=d9
      
  endfor   ;ihr
  free_lun,lunhr

end