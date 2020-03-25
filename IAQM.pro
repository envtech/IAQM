
;=======================================================================================
; ROUTINE: (IAQM) Integrated Air Quality Monitoring
;
; PURPOSE: 
; 
; - Air quality simulation: AERMOD running with DEM
; - Air quality visualization: Google Earth format (KML) 
;                 
; 
; Requited data:
; - DEM
; 
;
; AUTHOR:  Kwon-Ho Lee        21 Dec 2018
;                 Dept. of Atmos. Environ. Sci.,
;                 GWNU
;                 kwonho.lee@gmail.com
;                 
;                 
;                 
;
; REVISIONS: 
; 
;   V1.0:    2019.Jun.1   first version               
;                
;   Required Input Files are : 
;
;=======================================================================================


pro IAQM


;-----------------------------------------------
;   1. set receptor array
;-----------------------------------------------
  
  ;nx=9 &  ny=40  ; 1 array in output
  ;nx=9*22 &  ny=40*5

  ; receptor array
  lonmin=127.44348407
  lonmax=127.48775840
  latmin=35.43972978
  latmax=35.47561610
  
   roi=[latmin, latmax, lonmin, lonmax]

  
  minX=240000  &  maxX=244000
  minY=316000  &  maxY=320000

    
  dX=10  & dY=10
  
  nX=(maxX-minX)/dX+1
  nY=(maxY-minY)/dX+1
  
  xcoor=minX+findgen(nx)*dx
  ycoor=minY+findgen(ny)*dy
  
  
  src_x=242340 &  src_y=317940  ;corrected
  obs_x=241874 &  obs_y=317951
  src_Z=10.0
  
  obsx_idx=closest(xcoor,obs_x)
  obsy_idx=closest(ycoor,obs_y)
  
  
  
  
  
  ; Emission parameter
  QS =100.   ;emission rate in g/(s-m2)
  HS =10.     ;average release height
  TS =425.    ;Temp
  VS =15.      ;EXIT Vel
  DIA=1.0     ;DIAMETER
    
  PM25_ER_init=0.344520    ;kg/ton from NIER
  init_prod=1000.0  ;ton
  init_time=6.0     
  em_switch = 1
  
  period='24'
   

  pollutant = 'pm25'
  
  
  maxK=9
  maxL=40
  
  jcel_max=nx*ny/maxL/2
  
  icel_mod=(nx mod maxK)
  jcel_mod=(ny mod maxL)
  
  print, 'n_ytile    =', jcel_max
  print, 'mod_ytile=', jcel_mod
  

  
  mod_PM25=fltarr(nx,ny)
  
  Xinit=strtrim(string(minX),2)
  Xnum =strtrim(string(nX),2)
  Xdelta=strtrim(string(dX),2)
  Yinit=strtrim(string(minY),2)
  Ynum=strtrim(string(nY),2)
  Ydelta=strtrim(string(dY),2)

  sfc_file=''
  pro_file=''
  metcode=''
  probase='13.0'

  met_code='47158'

; NOAA NCDC file to read
;  ncd_pro_path = '..'+path_sep()+'NOAA_NCDC\prof'+path_sep()
  ncd_pro_path = '.'+path_sep()
  ncd_pro_file   = ncd_pro_path+'47158.y2d'


; set paths  
  met_path   = '..'+path_sep()+'MET_Data'+path_sep()
  dem_path   = '..'+path_sep()+'DEM'+path_sep()
  pm_path    = '..'+path_sep()+'PM_Data'+path_sep()
  
  out_path   = '..'+path_sep()+'AERMOD_out'+path_sep()
  hdf_path   = '..'+path_sep()+'HDF'+path_sep()
  
  png_path   = '..'+path_sep()+'PNG'+path_sep()
   
   
   
   
   
;-----------------------------------------------
;   2. read dem data
;-----------------------------------------------
  dem_file = dem_path + 'dem2d_10m.hdf'
  print, dem_file
  
  read_dem, dem_file,  $
                   dem_coord,dem
  
  dem_size=size(dem,/dimensions)
  hill=fltarr(dem_size(0),dem_size(1))
  for idem=0, dem_size(0)-1 do begin
  for jdem=0, dem_size(1)-1 do begin
       hill(idem,jdem)=dem(idem,jdem)
  endfor
  endfor
  


;--------------------------------------------
;  3. Read emission time data
;--------------------------------------------
  et_file = pm_path+'20160324_emission.csv'
  
  read_emission,et_file,                          $
                       tot_et,et_yyyy,et_mm,     $
                       et_dd,et_time,et_prod,j
  
  
  
;--------------------------------------------
;  4. Read sfc met data
;--------------------------------------------
  met_file = pm_path+'20160324_Meteorology.csv'
  
  read_sfc_met_data,met_file,hr_lines,                                  $
                               hr_yyyy,hr_mm,hr_dd,hr_hour,                $
                               hr_temp,hr_humi,hr_dewp,hr_ws,hr_wd,   $
                               hr_pres,hr_rain,hr_srad



;--------------------------------------------
;  5. Read daily PM data
;--------------------------------------------
  
  pm_file = pm_path+'NGV_daily_PM_OC.csv'

  read_pm_data,pm_file,                                       $
                       tot_pm,pm_yyyy,pm_mm,pm_dd,    $
                       pm_sampint_time,pm25,oc


;--------------------------------------------
; 6. case based AERMOD
;--------------------------------------------
normalyear=[31,28,31,30,31,30,31,31,30,31,30,31]
leapyear    =[31,29,31,30,31,30,31,31,30,31,30,31]

  close,11
  openw,11,'qs.dat'    ;emission rate

FOR ii = 2014, 2015 do begin  ;  year
   year = ii
      
   if (year mod 4) eq 0 then begin
      currentyear=leapyear
   endif else begin
      currentyear=normalyear
   endelse 

FOR jj = 1, total(currentyear) do begin  ;  day of year  
  ;FOR jj = 329, 329 do begin  ;  day of year
  
    jday = jj
    
  ; set date    
    jday2gday,year,month,jday,gday
    
    yyyy = strtrim(year,2)
    if month lt 10 then begin
       mm  = '0'+strtrim(month,2)
    endif else begin
       mm  = strtrim(month,2)
    endelse
    if gday lt 10 then begin
       dd   = '0'+strtrim(gday,2)
    endif else begin
       dd   = strtrim(gday,2)
    endelse
       
    
    
    
;--------------------------------------------
;  6.1 find collocated data wtih sfc met data
;--------------------------------------------
   
    ; hourly data for a day
    day_idx = where( (hr_yyyy eq yyyy) and   $ 
                           (hr_mm  eq mm) and $
                           (hr_dd eq dd) )
  

    
    if day_idx(0) gt 0 then begin
              
       mod_yyyy = yyyy
       mod_yy    = strmid(yyyy,2,2)
       mod_mm  = mm
       mod_dd    = dd

       print, 'collocation ==>', mod_yyyy,mod_mm,mod_dd, jday


 ; goto,noAERMOD   ; image only
  
  
;--------------------------------------------
;  6.2 make sfc met input file
;--------------------------------------------
          
       sfc_file = met_path+met_code+'_Namwon_'+   $
                     mod_yyyy+mod_mm+mod_dd+'_sfc.dat'
                     
       make_sfc_file,sfc_file,day_idx,  $
                     hr_lines,hr_yyyy,hr_mm,hr_dd,hr_hour,     $
                     hr_temp,hr_humi,hr_dewp,hr_ws,hr_wd,   $
                     hr_pres,hr_rain,hr_srad

       mean_wind_spd=mean(hr_ws(day_idx(*)))
       mean_wind_dir =mean(hr_wd(day_idx(*)))
                   
      print, mean_wind_spd
      print, mean_wind_dir
      
      
;--------------------------------------------
;  6.3 make profile met input file
;--------------------------------------------
       
       pro_file = met_path+met_code+'_Namwon_'+   $
                     mod_yyyy+mod_mm+mod_dd+'_pro.dat'
      
       make_pro_file, ncd_pro_file,pro_file,               $
                              mod_yy,mod_mm,mod_dd
      


;--------------------------------------------
;  6.4  emission rate in g/(s-m2)
;
;         1. assumption EPA
;         2. estimation from working hour
;--------------------------------------------
     
      ; assumption EPA
       if em_switch eq 1 then begin
          produced = init_prod
          prod_time = init_time
          
          QS = PM25_ER_init*produced   $
                /(prod_time*60.*60.)*1000.         
       endif
       
       
      ; estimation from working hour
       if em_switch eq 2 then begin
           
          result = where( (pm_yyyy eq mod_yyyy) and   $
                                (pm_mm  eq mod_mm) and $
                                (pm_dd eq mod_dd) )
          
          if result(0) gt 0 then begin
             produced = et_prod(result(0)) 
             prod_time = et_time(result(0))
          endif   
                          
          QS = PM25_ER_init*produced        $
                /(prod_time*60.*60.)*1000.        
       endif
      
     
         
   
           
       print,mod_yyyy,mod_mm,mod_dd,      $
               produced,prod_time,QS,            $
               format='(a4,a2,a2,3f15.5)'
               
       printf, 11, mod_yyyy,mod_mm,mod_dd,      $
               produced,prod_time,QS,            $
               format='(a4,a2,a2,3f15.5)'



;--------------------------------------------
;  6.5  make AERMOD input file & run 
;--------------------------------------------
  
       make_aeromod_input,period,src_X,src_Y,src_Z,  $
                                      QS,HS,TS,VS,DIA,            $
                                      xcoor,ycoor,dem,hill,        $
                                      sfc_file,pro_file,               $
                                      met_code,probase


      ; run AERMOD
       command='aermod.exe'
       spawn, command, /hide

      ; copy to outpuf path 
       out_file = out_path+  $
                     'Namwon_'+mod_yyyy+mod_mm+mod_dd+'.out'

       command='move aermod.out '+out_file
       spawn, command, /hide





;--------------------------------------------
;  6.6  read AERMOD output file & save hdf file
;--------------------------------------------
 
     ; collocated PM data
       result1 = where( (pm_yyyy eq mod_yyyy) and   $
                                (pm_mm  eq mod_mm) and $
                                (pm_dd eq mod_dd) )


       if result1(0) gt 0 then begin
           current_pm25 = pm25(result1(0))
           current_oc     = oc(result1(0))       
       endif else begin
        
           print, ' No PM observations on : '  $
                    +mod_yyyy+mod_mm+mod_dd
                    
           current_pm25 = -999
           current_oc     = -999        
       endelse
        
     
      
      ; read AERMOD out file and save as hdf file  
       hdf_file = hdf_path+  $
                  'Namwon_'+mod_yyyy+mod_mm+mod_dd+'.hdf'
                     
       read_aermod_out,out_file,period,hdf_file,          $
                                nx,ny,QS,mod_PM25,                            $
                                current_pm25,current_oc,                       $
                                mean_wind_spd,mean_wind_dir,             $
                                jcel_max,minX,minY,dX,dY,jcel_mod,      $
                                xcoor,obs_x,ycoor,obs_y,                      $
                                nagi_PM25
                                
       nagi_PM25=mod_PM25(obsx_idx(0),obsy_idx(0))                                

                       


;--------------------------------------------
;  6.7  read AERMOD hdf file & make image file
;--------------------------------------------

 
       hdf_file = hdf_path+  $
                     'Namwon_'+mod_yyyy+mod_mm+mod_dd+'.hdf'
  
       read_aermod_hdf,hdf_file,QS,mod_PM25,                     $
                                  measured_pm25,measured_oc,      $
                                  mean_wind_spd,mean_wind_dir
       


                                                        
       ; save as png file  
       png_file = png_path+'Namwon_'+  $
                      mod_yyyy+mod_mm+mod_dd+'.png'
       print, png_file

       title = 'Wind Speed = '  $
              +strtrim(string(mean_wind_spd,format='(f5.2)'),2)+'m/s' $
              + ', PM2.5 = '          $
              +strtrim(string(nagi_PM25,format='(f5.2)'),2)
           
         
         
       ct = COLORTABLE(72, /reverse)

       c = CONTOUR(mod_PM25, xcoor,ycoor, $
                             /FILL, AXIS_STYLE=2, $
                             RGB_TABLE=ct,MIN_VALUE=-0.01, $
                            TITLE=title,MARGIN=[0.15,0.1,0.15,0.1])

       cb = COLORBAR(TARGET=c, /BORDER,   $
                                ORIENTATION=1, $
                                TEXTPOS=1,       $
                                POSITION=[0.89,0.25,0.92,0.75])

       p1 = SCATTERPLOT(src_x,src_y, /OVERPLOT,   $
               SYMBOL='Star',SYM_SIZE=3)
       p2 = SCATTERPLOT(obs_x,obs_y, /OVERPLOT,  $
               SYMBOL='Circle',SYM_SIZE=3)                    
                      
       c.Save, png_file, BORDER=10, $
                   RESOLUTION=300, /TRANSPARENT

       c.Close


     ; scatter plot                      
     ;  plot_aermod_out,png_file,xcoor,ycoor,mod_PM25,                 $
     ;                             mean_wind_spd,mean_wind_dir,nagi_PM25,    $
     ;                             nx,ny,minX,maxX,minY,maxY,                         $
     ;                             src_x,src_y,obs_x,obs_y





;--------------------------------------------
;  6.8  convert to KML for Google Earth
;--------------------------------------------

kml_path='.'+path_sep()+'kml'+path_sep()
sub_path='.'+path_sep()+'png'+path_sep()
png_path=kml_path+'png'+path_sep()

 hhmm='1200'
 

; check path exist
test = file_search(kml_path, count=count)
if count le 0 then file_mkdir, kml_path

test = file_search(sub_path, count=count)
if count le 0 then file_mkdir, sub_path

test = file_search(png_path, count=count)
if count le 0 then file_mkdir, png_path




png_file='IAQM_'+pollutant+'_'+mod_yyyy+mod_mm+mod_dd+'.png'
kml_file='IAQM_'+pollutant+'_'+mod_yyyy+mod_mm+mod_dd+'.kml'

prod='IAQM_'+pollutant
prodname='IAQM'

make_png,png_path+png_file,mod_PM25,          $
                minX,maxX,minY,maxY,nx,ny,    $
                xcoor,ycoor,src_x,src_y,obs_x,obs_y


kml_time=strarr(2)

cLat =  (latmax-latmin)/2+lonmin
cLon = (lonmax-lonmin)/2+lonmin

Center=[clat, clon, 25.]

Width=[18.,30., 10.]
Polygon=[[55., 150., 2.], [55, 105, 2.], [15., 105., 2.],[15, 150, 2.]]

I_err=Open_KML(KML_Path+kml_file,I_Unit)




Begin_Folder_KML, I_Unit, Name=prodname

;2006-12-15T02:08:30Z


hh=strmid(hhmm,0,2)
minute1=strtrim(string(fix(strmid(hhmm,2,2))+5),2)
minute2=strtrim(string(fix(strmid(hhmm,2,2))+5)+5,2)

if gday lt 10 then begin
  dd='0'+strtrim(string(gday),2)
endif else begin
  dd=strtrim(string(gday),2)
endelse

kml_time(0)=yyyy+'-'+mm+'-'+dd+'T'+hh+':'+minute1+':00Z'
kml_time(1)=yyyy+'-'+mm+'-'+dd+'T'+hh+':'+minute2+':00Z'

Vpoints = [Center(0),Center(1),2.0]

addModelImage_KML, I_Unit,ROI,                              $
                                 MODNAME=prod,                     $
                                 MODFILE=sub_path+png_file,   $
                                 KMLTIME=kml_time

End_Folder_KML, I_Unit  ;prodname

Close_KML,  I_Unit


endif else begin
    print, 'no collocated data : '+yyyy+mm+dd  
endelse


ENDFOR   ;jj
ENDFOR   ;ii

  close,11
  
  print, 'end of AERMOD !!'


  
  
END
