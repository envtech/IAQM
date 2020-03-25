pro read_aermod_out,out_file,period,hdf_file,     $
                    nx,ny,QS,mod_PM25, $
                    current_pm25,current_oc,             $
                    mean_wind_spd,mean_wind_dir,         $
                    jcel_max,minX,minY,dX,dY,jcel_mod,   $
                    xcoor,obs_x,ycoor,obs_y,             $
                    nagi_PM25


  ;-----------------------------------------------
  ; read out file
  ;-----------------------------------------------
  print, 'tot_hour = '+period  
  words = '*** THE PERIOD (    '+period+' HRS) AVERAGE CONCENTRATION'+           $
              '   VALUES FOR SOURCE GROUP: ALL      ***'

  lines=file_lines(out_file)
  
   
  openr, lun, out_file, /GET_LUN
  
  dum1=''
  dum2=''
  ivar=''
  delimiter=' '
  
  ix=0
  jy=0
    
  icel_num=0
  jcel_num=0
  
  ij=0
  jj=0
  for io=0l, lines-1 do begin
  
    readf,lun,dum1
    ;print, dum1
    
    if strtrim(dum1,2) eq words then begin
    
      for idum=0, 4 do begin
        readf,lun,dum1
      endfor
      io=io+5
            
      if strtrim(dum1,2) eq '** CONC OF PM10     IN MICROGRAMS/M**3                          **'  $
        then begin
        
        
        if jcel_num lt jcel_max then begin
          maxL=40
        endif else begin
          if jcel_num eq jcel_max then begin
             maxL=jcel_mod
          endif
        endelse
        
        for j=0, 2 do begin
           readf,lun,dum2
        endfor  ;j
        io=io+3
        
        for L=0, maxL-1 do begin
          readf,lun,dum2
          
          ivar = strsplit(strcompress(dum2),delimiter,/extract, preserve=preserve_null)
          isov=size(ivar,/dimensions)
          
          ;print, ivar
          
          if isov gt 3 then begin
            ix1=float(ivar(0))  &  jy1=float(ivar(1))  &  conc1=float(ivar(2))
            ix2=float(ivar(3))  &  jy2=float(ivar(4))  &  conc2=float(ivar(5))
            
            inum1=(ix1-minX)/dx  &  jnum1=(jy1-minY)/dy
            inum2=(ix2-minX)/dx  &  jnum2=(jy2-minY)/dy
            
            mod_PM25(inum1, jnum1) = conc1
            mod_PM25(inum2, jnum2) = conc2
          endif else begin
            ix1=float(ivar(0))  &  jy1=float(ivar(1))  
            conc1=float(ivar(2))
            
            inum1=(ix1-minX)/dx  &  jnum1=(jy1-minY)/dy
            mod_PM25(inum1, jnum1) = conc1
          endelse
          
          
          
        endfor   ;k
        io=io+maxL
        
        if jcel_num lt jcel_max then begin
          jcel_num=jcel_num+1
        endif else begin
          jcel_num=0
        endelse
        
        
      endif
    endif
    
    ;   ivar = strsplit(strcompress(dum),delimiter,/extract, preserve=preserve_null)
    ;   isov=size(ivar)
    
  endfor  ;i
  
  free_lun, lun
  
  ;-----------------------------------------------
  ; save as HDF
  ;-----------------------------------------------
  sd_id = hdf_sd_start(hdf_file, /create )
  
  sds_id = hdf_sd_create( sd_id, 'PM2.5', [nx,ny])
  hdf_sd_adddata, sds_id, mod_PM25
  hdf_sd_endaccess, sds_id

  sds_id = hdf_sd_create( sd_id, 'measured_pm25', [1])
  hdf_sd_adddata, sds_id, current_pm25
  hdf_sd_endaccess, sds_id

  sds_id = hdf_sd_create( sd_id, 'measured_oc', [1])
  hdf_sd_adddata, sds_id, current_oc
  hdf_sd_endaccess, sds_id
    
  sds_id = hdf_sd_create( sd_id, 'mean_wind_spd', [1])
  hdf_sd_adddata, sds_id, mean_wind_spd
  hdf_sd_endaccess, sds_id

  sds_id = hdf_sd_create( sd_id, 'mean_wind_dir', [1])
  hdf_sd_adddata, sds_id, mean_wind_dir
  hdf_sd_endaccess, sds_id

  sds_id = hdf_sd_create( sd_id, 'QS', [1])
  hdf_sd_adddata, sds_id, QS
  hdf_sd_endaccess, sds_id

  
  hdf_sd_end, sd_id

  x_idx=closest(xcoor,obs_x)
  y_idx=closest(ycoor,obs_y)

  nagi_PM25=mod_PM25(x_idx(0),y_idx(0))
    

 print,' == End of read_aermod_out  !! == '

end