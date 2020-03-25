pro make_sfc_file,sfc_file,day_idx,  $
                  hr_lines,hr_yyyy,hr_mm,hr_dd,hr_hour,  $
                  hr_temp,hr_humi,hr_dewp,hr_ws,hr_wd,   $
                  hr_pres,hr_rain,hr_srad

  ;------------------------------------
  ; read NOAA sfc met data
  ;
  ; Station identifier: RKJJ
  ; Station number: 47158
  ;Observation time: 150419/1200
  ;Station latitude: 35.11
  ;Station longitude: 126.81
  ;Station elevation: 13.0
  ;------------------------------------
  sta_lat=' 35.110N'
  sta_lon='126.810E'
  ua_id  ='47158'
  sf_id   ='47158'
  os_id   ='  '
  version=' 14134 '
    
  openw, lunsd, sfc_file, /GET_LUN
  
  printf,lunsd,  $
           sta_lat,sta_lon,' UA_ID: ',ua_id,' SF_ID: ',sf_id,  $
           ' OS_ID:',os_id,'VERSION:',version,  $
      ;    ' ADJ_U*  CCVR_Sub TEMP_Sub', $
           ' CCVR_Sub TEMP_Sub', $
          ;FORMAT='(2(2x,a8),8x,6a8,5x,a8,a6,a26)'
           FORMAT='(2(2x,a8),8x,6a8,5x,a8,a6,a12)'
    
    
    sensheat=-99.0    ;not used    
    sfcfricvel=-9.0    
    convevel=-9.0
    verpotem=-9.0    
    conbound=-999.0
    mecbound=-999.0
    molength=-999.0    
    ;sfcrough=-9.0
    sfcrough=0.1   ;Low crops, some large obstacles from Hansen(ARL,1993)    
    bownrat=1.5   ;not used
    albedo=1.0     ;not used

    refht_wind=10.0
    refht_temp=2.0

    ccvr=10      ;cloud cover (tenths)
    WSADJ='ADJ-SFC '    ;wind speed adjustment and data source flag
    WSADJ='NAD-SFC '    ;wind speed NO adjustment and data source flag
    nosubs=' NoSubs'

    run_flag=0    


    n_hr = n_elements(day_idx)

    for ihr=0, n_hr-1 do begin
    
       is = day_idx(ihr)                       

       if hr_ws(is) le 0 then begin
         windspe=0.1
         winddir=90.0
       endif else begin  
         windspe=hr_ws(is)    ;m/sec
         winddir=hr_wd(is)
       endelse
       
       sfcfricvel=0.4*windspe/alog(refht_wind/sfcrough)
       if sfcfricvel lt 0.1 then sfcfricvel = 0.1
    
       sfctemp=hr_temp(is)+273.  ;deg
      
       molength=-1.0*(sfcfricvel^3)/(0.4*9.8/sfctemp*(-0.05))
       mecbound=2300.*(sfcfricvel^(3./2.))
        
      ;added
       if hr_rain(is) gt 0 then begin
          ipcode=11
          pamt=hr_rain(is)
       endif else begin
          ipcode=0   ;precipitation type code (0=none,11=liquid,22=frozen,99=missing)
          pamt=0.    ;precipitation amount (mm/hr)
       endelse
    
       rh=hr_humi(is)      ;relative humidity (percent)
       pres=hr_pres(is)   ;hpa
    
       year       =fix(strmid(hr_yyyy(is),2,2))
       month    =fix(hr_mm(is))
       gday      =fix(hr_dd(is))
       met_year=fix(hr_yyyy(is))
      
       gday2jday,met_year,month,gday,jday
           
       printf,lunsd,  $
                 year,month,gday,jday,hr_hour(is)+1,  $
                 sensheat,sfcfricvel,convevel,verpotem,conbound,  $
                 mecbound,molength,sfcrough,bownrat,albedo,       $
                 windspe,hr_wd(is),refht_wind,sfctemp,refht_temp,  $
                 ipcode,pamt,hr_humi(is),hr_pres(is), ccvr, WSADJ,nosubs,  $  ;added
                 format='(3(i2,1x),i3,1x,i2,1x,'+   $
        'F6.1,1X,3(F6.3,1X),F5.0,1X,'+  $
        'F5.0,1X,F8.1,1X,F7.4,1X,2(F6.2,1X),'+  $
        'F7.2,1X,4(F6.1,1X),'+  $
        'I5,1x,F6.2,1x,F6.0,1X,F6.0,1X,I5,1X, 2a7)'

  endfor   ;ihr

          
  free_lun, lunsd
  
  command='copy '+sfc_file+' .\met_sfc.dat'
  spawn, command, /hide

    
  print,' == End of make_sfc_file  !! == '
  
end