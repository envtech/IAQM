pro make_pro_file,ncd_pro_file,pro_file,               $
                              mod_yy,mod_mm,mod_dd

  st_height=13

  pro_line=file_lines(ncd_pro_file)
  
  openr, lun, ncd_pro_file, /GET_LUN
  openw, lunsd, pro_file, /GET_LUN
  
  dum=''
  delimiter=' '
  
  for ip=0l,  pro_line-1 do begin
  
    readf,lun,dum
    
    if strmid(dum,0,1) eq '#' then begin
      pro_yyyy=strmid(dum,6,4)
      pro_yy=strmid(pro_yyyy,2,2)
      pro_mm=strmid(dum,10,2)
      pro_dd=strmid(dum,12,2)
      pro_hh=strmid(dum,14,2)
      pro_nhgt=fix(strmid(dum,20,4))
      
      topflag=1
      stddr=99.0
      stdvws=99.0
      
      pro_year=fix(pro_yy)
      pro_month=fix(pro_mm)
      pro_day=fix(pro_dd)
      pro_hour=fix(pro_hh)
      
    if ( (pro_yy   eq mod_yy) and    $
         (pro_mm eq mod_mm) and    $
         (pro_dd  eq mod_dd)) then begin

;print, pro_year,pro_month,pro_day,pro_hour
;stop
        
        z_press=fltarr(pro_nhgt)
        z_temp=fltarr(pro_nhgt)
        z_wd=fltarr(pro_nhgt)
        z_ws=fltarr(pro_nhgt)
        z_hgt=fltarr(pro_nhgt)
        
        for ihgt=0, pro_nhgt-1 do begin
          readf,lun,dum
          z_press(ihgt)=float(strmid(dum,2,6))/100.
          
          z_temp(ihgt)=float(strmid(dum,15,5))/10.
          if z_temp(ihgt) le  -999.0 then  z_temp(ihgt)=-9.0
          
          z_wd(ihgt)=fix(strmid(dum,26,5))
          if z_wd(ihgt) le  -9999.0 then  z_wd(ihgt)=-999.0
          
          z_ws(ihgt)=float(strmid(dum,31,5))/10.
          if z_ws(ihgt) le -999.9 then z_ws(ihgt)=-99.0
          
          
          z_hgt(ihgt)= (1.0-((z_press(ihgt)/1013.25)^(0.190284)))  $
                           *145366.45*0.3048+st_height  ;in m
        endfor  ;ihgt
        
        ip=ip+pro_nhgt
        
        for ihh=1, 6 do begin
          z_hour=pro_hour+ihh
        for ihgt=1, 1 do begin
            ;for ihgt=0, nhgt-1 do begin
            ;  print, year,month,day,z_hour
            printf,lunsd,  $
                     pro_year,pro_month,pro_day,z_hour,z_hgt(ihgt),topflag,  $
                     z_wd(ihgt),z_ws(ihgt),z_temp(ihgt),stddr,stdvws,  $
                     format='(4(i2,1X),f7.1,1X,i1,1X,'  $
                                +'f7.1,4(1X,F8.2))'
        endfor  ;ihgt
        endfor  ;ihh
        
    endif
    endif
    
  endfor  ;ip
  
  free_lun, lun
  free_lun, lunsd
  
  command='copy '+pro_file+' .\met_pro.dat'
  spawn, command, /hide
  
  print,' == End of make_pro_file  !! == '

end