pro plot_aermod_out,png_file,xcoor,ycoor,mod_PM25,  $
                    mean_wind_spd,mean_wind_dir,nagi_PM25,    $
                    nx,ny,minX,maxX,minY,maxY,  $
                    src_x,src_y,obs_x,obs_y


;-----------------------------------------------
; plot data
;-----------------------------------------------
xs=15  &  ys=15

;===== Plot Start =====
set_plot,'ps'
ps_name='.'+path_sep()+'temp.ps'
device, /times, /color, filename=ps_name, $
            bits=8, xsize=xs, ysize=ys, /inches
!p.font = 0 & !p.charsize=1.5 & !p.charthick=1.5

TVLCT, 255, 255, 255, 254 ; White color
TVLCT, 0, 0, 0, 253       ; Black color

!P.Color = 253
!P.Background = 254


;===== Data Scaling =====
zmin = 0.0 & zmax =10. 
n_color = 255. & interval = 1.

val = scale_vector(mod_PM25, 0, n_color,   $
                            minvalue=zmin, maxvalue=zmax,    $
                            /nan, /double)

; User Defined Symbol
mydevice=!d.name
usersym,[-0.5,0.5,0.5,-0.5], $
             [-0.5,-0.5,0.5,0.5],/fill
sz = 2

plot,[minX,minX],[minY,minY],                            $
       xrange=[minX,maxX], yrange=[minY,maxY],   $
       XTHICK=2,YTHICK=2,                                   $
       charsize=2, POSITION=[0.1, 0.1, 0.8, 0.9]
  
  
;LOADCT, 39
LOADCT, 22
for ii = 0, nx-1 do begin
for jj = 0, ny-1 DO begin
  
    if (val(ii,jj) gt 0 and val(ii,jj) lt n_color) then   $
       plots,xcoor(ii),ycoor(jj),   $
               psym=8,symsize=sz,color=long(val(ii,jj))
      
    if (val(ii,jj) gt 0 and val(ii,jj) eq n_color) then   $
       plots,xcoor(ii),ycoor(jj),   $
               psym=8,symsize=sz,color=long(n_color-1)
      
endfor
endfor


  



cgColorbar, Divisions=4, Minor=5, Format='(i3)',    $
                  Ticklen=-0.25, charsize=2,                 $
                  Range=[zmin,zmax],                          $
                  POSITION=[0.88, 0.10, 0.92, 0.90],   $
                  vertical=1,right=1
   
  
  LOADCT, 0
  

  xyouts,0.1,0.92,'Wind Speed = '  $
            +strtrim(string(mean_wind_spd),2)+'m/s', $
            /normal,font=1,charsize=3,color=0
            
  xyouts,0.6,0.92,'PM2.5 = '          $
           +strtrim(string(round(nagi_PM25)),2), $
            /normal,font=1,charsize=3,color=0

  plotsym2, 3, 2 
  plots,src_x,src_y,psym=8,symsize=2,color=0
  plotsym2, 0, 1 
  plots,obs_x,obs_y,psym=8,symsize=2,color=0
  
  
  plot,[minX,minX],[minY,minY], $
    xrange=[minX,maxX], yrange=[minY,maxY],  $
    charsize=2,POSITION=[0.1, 0.1, 0.8, 0.9]

  
device, /close

; using imagemagic, convert image format from PS --> PNG
convert_command = 'convert -background white -flatten '  $
                            +ps_name+' '+png_file
print, convert_command
spawn, convert_command ,/hide

file_delete, ps_name


end